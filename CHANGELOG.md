# Changelog

All notable changes to this project will be documented in this file, per [the Keep a Changelog standard](http://keepachangelog.com/).

## [Unreleased] - TBD

## [1.4.1] - 2020-03-12
### Fixed
- Ensure previously committed files that are later added to `.distignore` get deleted. Props [@pascalknecht](https://github.com/pascalknecht) via [#18](https://github.com/10up/action-wordpress-plugin-asset-update/pull/18).
- Escape filenames to avoid errors with filenames containing an `@` symbol. Props [@Gaya](https://github.com/Gaya) via [#18](https://github.com/10up/action-wordpress-plugin-asset-update/pull/18).
- Use `https` for WordPress.org URLs. Props [@dinhtungdu](https://github.com/dinhtungdu) via [#17](https://github.com/10up/action-wordpress-plugin-asset-update/pull/17).
- Correct encrypted secrets documentation link. Props [@felipeelia](https://github.com/felipeelia) via [#11](https://github.com/10up/action-wordpress-plugin-asset-update/pull/11).

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
[1.4.1]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/1.4.0...1.4.1
[1.4.0]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/1.2.1...1.3.0
[1.2.1]: https://github.com/10up/action-wordpress-plugin-asset-update/compare/03e175e...d2b6608
