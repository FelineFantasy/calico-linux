# Changelog

All notable changes to Calico Linux are documented here.
The format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and releases are tagged `v<version>`.

## [Unreleased]

### Added

- Local build script (`scripts/build-local.sh`) wrapping the containerised
  `livecd-creator` run.
- `.gitignore`, `.editorconfig` and `CONTRIBUTING.md` for repository hygiene.

### Changed

- README quick start section for guided ISO builds via GitHub Actions.

## [1.0.0]

### Added

- Initial Calico Linux live spin based on Fedora XFCE (`f42`).
- `calico.ks` overlay: branded `os-release`, motd banner, `fastfetch`.
- GitHub Actions workflow that builds the ISO and publishes a release.
