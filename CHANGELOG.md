# Changelog

All notable changes to this project will be documented in this file, per [the Keep a Changelog standard](http://keepachangelog.com/).

## [Unreleased] - TBD

## [1.4.0] - 2019-10-15
### Added
- Support for `README.md` via an optional `README_NAME` environment variable

### Fixed
- Ensure readme updates when using `.distignore`

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

[Unreleased]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/master...develop
[1.4.0]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/1.2.1...1.3.0
[1.2.1]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/03e175e...d2b6608
