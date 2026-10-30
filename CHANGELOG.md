# Changelog

All notable changes to Calico Linux are documented here.
The format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and releases are tagged `v<version>`.

## [Unreleased]

### Added

- Local build script (`scripts/build-local.sh`) wrapping the containerised
  `livecd-creator` run.
- `.gitignore`, `.editorconfig` and `CONTRIBUTING.md` for repository hygiene.
- `kitty` terminal, available alongside the default `xfce4-terminal`.
- Quality-of-life CLI tools: `bat`, `eza`, `fzf`, `zoxide`, `ripgrep`,
  `fd-find`, `jq`, `tree`, `btop`, `ncdu`, `duf`, `inxi`, `micro`, `tmux`,
  `unzip`, `p7zip`, `zstd`.
- Branded `fastfetch` config with an ASCII cat logo, installed from
  `configs/fastfetch/` into `/etc/fastfetch/`.
- Shell integration for the new tools (`zoxide` hook, `ll`/`la` aliases for
  `eza`).

### Changed

- README quick start section for guided ISO builds via GitHub Actions.
- Interactive login shells now show `fastfetch` instead of the plain two-line
  banner (the motd/issue text banner is still used for consoles).

### Fixed

- Releases could ship an unbootable ISO. `livecd-tools` stages the kernel and
  initramfs in `configure()` *before* running the kickstart `%post` scripts,
  and it sets `base_on = True` unconditionally, which suppresses its
  `No initramfs or initrd found` error. With the kernel's own dracut failing
  in containerised builds, the resulting ISO simply had no
  `isolinux/initrd0.img` and nothing in the log said so. `calico.ks` now
  rebuilds the live initramfs in `%post` and stages it into the ISO tree from
  a `%post --nochroot` hook, and the build workflow refuses to publish an ISO
  without a working payload.
- The initramfs rebuild drops drivers that the installed kernel no longer
  ships (`ide_cd`, `ieee1394`) and expands the bare `=ata` group entry that
  dracut-install rejects, so dracut stops failing on stale livecd-tools data.
- The live root filesystem no longer keeps a second copy of the initramfs in
  `/boot`. The ISO boots from `isolinux/initrd0.img` and anaconda builds a
  fresh initramfs for installed systems, so the copy only made the ISO larger
  (and pushed it over GitHub's 2 GiB release asset limit, which failed the
  release upload). The workflow now fails before uploading an oversized ISO.

## [1.0.0]

### Added

- Initial Calico Linux live spin based on Fedora XFCE (`f42`).
- `calico.ks` overlay: branded `os-release`, motd banner, `fastfetch`.
- GitHub Actions workflow that builds the ISO and publishes a release.
