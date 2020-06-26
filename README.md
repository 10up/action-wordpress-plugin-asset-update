# WordPress.org Plugin Readme/Assets Update

> Deploy readme and asset updates to the WordPress Plugin Repository.

[![Support Level](https://img.shields.io/badge/support-active-green.svg)](#support-level) [![Release Version](https://img.shields.io/github/release/10up/action-wordpress-plugin-asset-update.svg)](https://github.com/10up/action-wordpress-plugin-asset-update/releases/latest) [![MIT License](https://img.shields.io/github/license/10up/action-wordpress-plugin-asset-update.svg)](https://github.com/10up/action-wordpress-plugin-asset-update/blob/develop/LICENSE)

This Action commits any readme and WordPress.org-specific assets changes in your specified branch to the WordPress.org plugin repository if no other changes have been made since the last deployment to WordPress.org. This is useful for updating things like screenshots or `Tested up to` separately from functional changes, provided your Git branching methodology avoids changing anything else in the specified branch between functional releases. It is **highly recommended** that you use a stable branch where you only merge readme/asset commits in between larger functional merges that only occur when preparing for a release (often implemented as `trunk` vs. `develop`).

Because the WordPress.org plugin repository shows information from the readme in the specified `Stable tag`, this Action also attempts to parse out the stable tag from your readme and deploy to there as well as `trunk`. If your stable tag is `trunk` or a tag that does not exist in the `tags` subfolder, it will skip that part of the update and only update `trunk` and/or `assets`.

**Important note:** If your development process leads to a situation where `trunk` (or other specified branch) only contains changes to the readme or assets directory since the last sync to the plugin directory and those changes are in preparation for the next release, those changes will go live and potentially be misleading to users. Usage of this Action assumes a fairly traditional Git methodology that involves merging all changes to `trunk` when functional changes are ready and that this seemingly unlikely situation will therefore not happen in your repo; there are no safeguards against syncing changes based on readme/asset content, as that cannot be predicted.

### ☞ This Action is meant to be used in tandem with our [WordPress.org Plugin Deploy Action](https://github.com/10up/action-wordpress-plugin-deploy)

### ☞ Check out our [collection of WordPress-focused GitHub Actions](https://github.com/10up/actions-wordpress)

## Configuration

### Required secrets

* `SVN_USERNAME`
* `SVN_PASSWORD`

[Secrets are set in your repository settings](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets). They cannot be viewed once stored.

### Optional environment variables

* `SLUG` - defaults to the respository name, customizable in case your WordPress repository has a different slug or is capitalized differently.
* `ASSETS_DIR` - defaults to `.wordpress-org`, customizable for other locations of WordPress.org plugin repository-specific assets that belong in the top-level `assets` directory (the one on the same level as `trunk`).
* `README_NAME` - defaults to `readme.txt`, customizable in case you use `README.md` instead, which is now quietly supported in the WordPress.org plugin repository.

## Example Workflow File

```yml
name: Plugin asset/readme update
on:
  push:
    branches:
    - trunk
jobs:
  trunk:
    name: Push to trunk
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: WordPress.org plugin asset/readme update
      uses: 10up/action-wordpress-plugin-asset-update@stable
      env:
        SVN_PASSWORD: ${{ secrets.SVN_PASSWORD }}
        SVN_USERNAME: ${{ secrets.SVN_USERNAME }}
```

### Known issues

* It would be more efficient to additionally use the `paths` filter for the `push` action to reduce the number of runs. So far in testing it is possible to limit it to pushes that include readme/asset files as specified, but not ones that *only* include those files. The Action itself still needs to run as written because it compares the totality of changes in the branch against what's in SVN and not just the contents of the current push.

## Changelog

A complete listing of all notable changes to WordPress.org Plugin Readme/Assets Update are documented in [CHANGELOG.md](https://github.com/10up/action-wordpress-plugin-asset-update/blob/develop/CHANGELOG.md).

## Contributing

Want to help? Check out our [contributing guidelines](CONTRIBUTING.md) to get started.

## Support Level

**Active:** 10up is actively working on this, and we expect to continue work for the foreseeable future including keeping tested up to the most recent version of WordPress.  Bug reports, feature requests, questions, and pull requests are welcome.

# Like what you see?

<p align="center">
<a href="http://10up.com/contact/"><img src="https://10updotcom-wpengine.s3.amazonaws.com/uploads/2016/10/10up-Github-Banner.png" width="850"></a>
</p>
