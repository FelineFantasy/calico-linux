# Calico Linux

A Fedora XFCE live spin, rebranded as **Calico Linux**. 🐾

Built from upstream `fedora-kickstarts` with a small `calico.ks`
overlay that rebrands `os-release`, adds a motd banner, and ships
`kitty` and `fastfetch` out of the box.

## Building via GitHub Actions

1. Go to **Actions → Build Calico Linux ISO → Run workflow**.
2. Provide a `version` (e.g. `1.0.0`) and optional `release_notes`.
3. Wait for the job to finish. The ISO is uploaded as an artifact
   and attached to a new GitHub release tagged `v<version>`.

Build time is typically 15–30 minutes on a GitHub-hosted runner.

## Building locally

The build must run inside a Fedora container, because
`livecd-creator` requires an RPM-based host.

```bash
docker run --privileged --rm -it \
  -v "$PWD:/work" -w /work \
  fedora:42 bash -c '
    set -euo pipefail
    dnf install -y livecd-tools spin-kickstarts git
    git clone --depth 1 --branch f42 https://pagure.io/fedora-kickstarts.git /tmp/ks
    cp /work/calico.ks /tmp/ks/calico.ks
    cd /tmp/ks
    livecd-creator \
      --config=calico.ks \
      --fslabel="Calico-Linux-dev" \
      --cache=/var/cache/live \
      -p /tmp/ks
    cp /tmp/ks/*.iso /work/
  '
```

Requires --privileged and around 20 GiB of free disk space.

Verifying a build

```bash
sha256sum Calico-Linux-<version>.iso
```

Compare against the .iso.sha256 file attached to the release.

Known constraints

· Built against Fedora f42 (stable). Change the branch in the
  workflow and calico.ks includes to target a different release.
· Root partition is 8 GiB, sized for XFCE + kitty + fastfetch.
· Kernel, drivers and package set come from upstream
  fedora-live-base.ks and fedora-xfce-common.ks.

Layout

```
calico.ks                     # kickstart overlay
.github/workflows/build.yml   # CI that produces the ISO
README.md                     # this file
```

## 💖 Support the Project

If you enjoy **PurrScript** and want to help keep the project alive, you can support me here:

[![DonationAlerts](https://img.shields.io/badge/DonationAlerts-Support-blue.svg)](https://www.donationalerts.com/r/felinefantasy)

Your support helps me:
- 🐱 Add new cat commands
- 🛠️ Fix bugs and improve the transpiler
- ☕ Stay awake while coding at 4 AM

Every little bit is appreciated! ❤️

## 👤 Author
- **FelineFantasy**
- **License**: MIT
