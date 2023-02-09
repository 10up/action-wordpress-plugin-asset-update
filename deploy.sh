#!/bin/bash

# Note that this does not use pipefail because if the grep later
# doesn't match I want to be able to show an error first
set -eo

# Ensure SVN username and password are set
# IMPORTANT: while secrets are encrypted and not viewable in the GitHub UI,
# they are by necessity provided as plaintext in the context of the Action,
# so do not echo or use debug mode unless you want your secrets exposed!
if [[ -z "$SVN_USERNAME" ]]; then
	echo "Set the SVN_USERNAME secret"
	exit 1
fi

if [[ -z "$SVN_PASSWORD" ]]; then
	echo "Set the SVN_PASSWORD secret"
	exit 1
fi

# Allow some ENV variables to be customized
if [[ -z "$SLUG" ]]; then
	SLUG=${GITHUB_REPOSITORY#*/}
fi
echo "ℹ︎ SLUG is $SLUG"

if [[ -z "$ASSETS_DIR" ]]; then
	ASSETS_DIR=".wordpress-org"
fi
echo "ℹ︎ ASSETS_DIR is $ASSETS_DIR"

if [[ -z "$README_NAME" ]]; then
	README_NAME="readme.txt"
fi
echo "ℹ︎ README_NAME is $README_NAME"

if [[ -z "$IGNORE_OTHER_FILES" ]]; then
	IGNORE_OTHER_FILES=false
fi
echo "ℹ︎ IGNORE_OTHER_FILES is $IGNORE_OTHER_FILES"

SVN_URL="https://plugins.svn.wordpress.org/${SLUG}/"
SVN_DIR="${HOME}/svn-${SLUG}"

# Checkout just trunk and assets for efficiency
# Stable tag will come later, if applicable
echo "➤ Checking out .org repository..."
svn checkout --depth immediates "$SVN_URL" "$SVN_DIR"
cd "$SVN_DIR"
svn update --set-depth infinity assets
svn update --set-depth infinity trunk

echo "➤ Copying files..."
if [ "$IGNORE_OTHER_FILES" = true ]; then
	# Copy readme.txt to /trunk
	cp "$GITHUB_WORKSPACE/$README_NAME" trunk/$README_NAME

	# Use $TMP_DIR as the source of truth
	TMP_DIR=$GITHUB_WORKSPACE
else
	if [[ -e "$GITHUB_WORKSPACE/.distignore" ]]; then
		echo "ℹ︎ Using .distignore"

		# Use $TMP_DIR as the source of truth
		TMP_DIR=$GITHUB_WORKSPACE

		# Copy from current branch to /trunk, excluding dotorg assets
		# The --delete flag will delete anything in destination that no longer exists in source
		rsync -rc --exclude-from="$GITHUB_WORKSPACE/.distignore" "$GITHUB_WORKSPACE/" trunk/ --delete --delete-excluded
	else
		echo "ℹ︎ Using .gitattributes"

		cd "$GITHUB_WORKSPACE"

		# "Export" a cleaned copy to a temp directory
		TMP_DIR="${HOME}/archivetmp"
		mkdir "$TMP_DIR"

		git config --global user.email "10upbot+github@10up.com"
		git config --global user.name "10upbot on GitHub"

		# If there's no .gitattributes file, write a default one into place
		if [[ ! -e "$GITHUB_WORKSPACE/.gitattributes" ]]; then
			cat > "$GITHUB_WORKSPACE/.gitattributes" <<-EOL
			/$ASSETS_DIR export-ignore
			/.gitattributes export-ignore
			/.gitignore export-ignore
			/.github export-ignore
			EOL

			# Ensure we are in the $GITHUB_WORKSPACE directory, just in case
			# The .gitattributes file has to be committed to be used
			# Just don't push it to the origin repo :)
			git add .gitattributes && git commit -m "Add .gitattributes file"
		fi

		# This will exclude everything in the .gitattributes file with the export-ignore flag
		git archive HEAD | tar x --directory="$TMP_DIR"

		cd "$SVN_DIR"

		# Copy from clean copy to /trunk, excluding dotorg assets
		# The --delete flag will delete anything in destination that no longer exists in source
		rsync -rc "$TMP_DIR/" trunk/ --delete --delete-excluded
	fi
fi

# Copy dotorg assets to /assets if directory exists
if [ -d "$GITHUB_WORKSPACE/$ASSETS_DIR" ]; then
    rsync -rc "$GITHUB_WORKSPACE/$ASSETS_DIR/" assets/ --delete --delete-excluded
fi

# Fix screenshots getting force downloaded when clicking them
# https://developer.wordpress.org/plugins/wordpress-org/plugin-assets/
if test -d "$SVN_DIR/assets" && test -n "$(find "$SVN_DIR/assets" -maxdepth 1 -name "*.png" -print -quit)"; then
    svn propset svn:mime-type "image/png" "$SVN_DIR/assets/"*.png || true
fi
if test -d "$SVN_DIR/assets" && test -n "$(find "$SVN_DIR/assets" -maxdepth 1 -name "*.jpg" -print -quit)"; then
    svn propset svn:mime-type "image/jpeg" "$SVN_DIR/assets/"*.jpg || true
fi
if test -d "$SVN_DIR/assets" && test -n "$(find "$SVN_DIR/assets" -maxdepth 1 -name "*.gif" -print -quit)"; then
    svn propset svn:mime-type "image/gif" "$SVN_DIR/assets/"*.gif || true
fi
if test -d "$SVN_DIR/assets" && test -n "$(find "$SVN_DIR/assets" -maxdepth 1 -name "*.svg" -print -quit)"; then
    svn propset svn:mime-type "image/svg+xml" "$SVN_DIR/assets/"*.svg || true
fi

echo "➤ Preparing files..."

svn status

if [[ -z $(svn stat) ]]; then
	echo "🛑 Nothing to deploy!"
	exit 0
# Check if there is more than just the readme.txt modified in trunk
# The leading whitespace in the pattern is important
# so it doesn't match potential readme.txt in subdirectories!
elif svn stat trunk | grep -qvi " trunk/$README_NAME$"; then
	echo "🛑 Other files have been modified; changes not deployed"
	exit 1
fi

# Readme also has to be updated in the .org tag
echo "➤ Preparing stable tag..."
STABLE_TAG=$(grep -m 1 -E "^([*+-]\s+)?Stable tag:" "$TMP_DIR/$README_NAME" | tr -d '\r\n' | awk -F ' ' '{print $NF}')

if [[ -z "$STABLE_TAG" ]]; then
    echo "ℹ︎ Could not get stable tag from $README_NAME";
else
	echo "ℹ︎ STABLE_TAG is $STABLE_TAG"

	if svn info "^/$SLUG/tags/$STABLE_TAG" > /dev/null 2>&1; then
		svn update --set-depth infinity "tags/$STABLE_TAG"

		# Not doing the copying in SVN for the sake of easy history
		rsync -c "$TMP_DIR/$README_NAME" "tags/$STABLE_TAG/"
	else
		echo "ℹ︎ Tag $STABLE_TAG not found"
	fi
fi

# Add everything and commit to SVN
# The force flag ensures we recurse into subdirectories even if they are already added
# Suppress stdout in favor of svn status later for readability
svn add . --force > /dev/null

# SVN delete all deleted files
# Also suppress stdout here
svn status | grep '^\!' | sed 's/! *//' | xargs -I% svn rm %@ > /dev/null

#Resolves => SVN commit failed: Directory out of date
svn update

# Now show full SVN status
svn status

echo "➤ Committing files..."
svn commit -m "Updating readme/assets from GitHub" --no-auth-cache --non-interactive  --username "$SVN_USERNAME" --password "$SVN_PASSWORD"

echo "✓ Plugin deployed!"
