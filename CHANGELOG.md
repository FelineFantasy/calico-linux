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

### Fixed

- Releases could ship an unbootable ISO: when dracut failed inside the image
  (as happens in containerised `livecd-creator` runs), `livecd-tools` only
  logged `No initramfs or initrd found` and built the ISO without
  `isolinux/initrd0.img`. `calico.ks` now rebuilds the live initramfs in
  `%post`, and the build workflow verifies the ISO payload before publishing.
- The initramfs rebuild drops drivers that the installed kernel no longer
  ships (`ide_cd`, `ieee1394`) and expands the bare `=ata` group entry that
  dracut-install rejects, so dracut stops failing on stale livecd-tools data.

## [1.0.0]

### Added

- Initial Calico Linux live spin based on Fedora XFCE (`f42`).
- `calico.ks` overlay: branded `os-release`, motd banner, `fastfetch`.
- GitHub Actions workflow that builds the ISO and publishes a release.
