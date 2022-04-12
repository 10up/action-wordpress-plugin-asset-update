# Changelog

All notable changes to this project will be documented in this file, per [the Keep a Changelog standard](http://keepachangelog.com/).

## [Unreleased] - TBD

## [2.1.0] - 2022-04-12
### Added
- Environment variable (`IGNORE_OTHER_FILES`) allowing to deploy updates to readme and/or assets without checking other files (props [@markjaquith](https://github.com/markjaquith) via [#32](https://github.com/10up/action-wordpress-plugin-asset-update/pull/32)).

## [2.0.0] - 2021-08-24
This is now a composite Action, meaning that it runs directly on the GitHub Actions runner rather than spinning up its own container and is significantly faster.

### Added
- Set mime types on images in the SVN `assets` directory to prevent forced downloads on WordPress.org (props [@nextgenthemes](https://github.com/nextgenthemes) via [action-wordpress-plugin-deploy#40](https://github.com/10up/action-wordpress-plugin-deploy/pull/40) and [@dinhtungdu](https://github.com/dinhtungdu) via [#21](https://github.com/10up/action-wordpress-plugin-asset-update/pull/21)).
- Support for stable tag extraction from Markdown lists in README.md files (props [@grappler](https://github.com/grappler) via [#25](https://github.com/10up/action-wordpress-plugin-asset-update/pull/25)).

### Fixed
- Avoid a Debian image issue where the container could not be built (props [@helen](https://github.com/helen) via [#30](https://github.com/10up/action-wordpress-plugin-asset-update/pull/30)).

## [1.4.1] - 2020-03-12
### Fixed
- Ensure previously committed files that are later added to `.distignore` get deleted (props [@pascalknecht](https://github.com/pascalknecht) via [#18](https://github.com/10up/action-wordpress-plugin-asset-update/pull/18)).
- Escape filenames to avoid errors with filenames containing an `@` symbol (props [@Gaya](https://github.com/Gaya) via [#18](https://github.com/10up/action-wordpress-plugin-asset-update/pull/18)).
- Use `https` for WordPress.org URLs (props [@dinhtungdu](https://github.com/dinhtungdu) via [#17](https://github.com/10up/action-wordpress-plugin-asset-update/pull/17)).
- Correct encrypted secrets documentation link (props [@felipeelia](https://github.com/felipeelia) via [#11](https://github.com/10up/action-wordpress-plugin-asset-update/pull/11)_.

## [1.4.0] - 2019-10-15
### Added
- Support for `README.md` via an optional `README_NAME` environment variable.

### Fixed
- Ensure readme updates when using `.distignore`.

## [1.3.0] - 2019-08-31
### Added
- Support for `.distignore` to align with the [deploy action](https://github.com/10up/action-wordpress-plugin-deploy/).

### Changed
- Return success instead of failure when there's nothing to deploy.

## [1.2.1] - 2019-08-22
### Added
- Deploy `readme.txt` changes to the specified `Stable tag` if it exists.

### Fixed
- Account for possible whitespace around the stable tag.
- Use more robust method of copying files (`-c` flag for `rsync`).

[Unreleased]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/stable...develop
[2.1.0]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/1.4.1...2.0.0
[1.4.1]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/1.4.0...1.4.1
[1.4.0]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/1.2.1...1.3.0
[1.2.1]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/03e175e...d2b6608
