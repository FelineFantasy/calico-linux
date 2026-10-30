#!/usr/bin/env bash
# Build a Calico Linux ISO locally inside a Fedora container.
#
#   ./scripts/build-local.sh [version]
#
# Requires Docker with --privileged support and ~20 GiB of free disk space.
# Override the target Fedora release with FEDORA_RELEASE (default: 42).
set -euo pipefail

VERSION="${1:-dev}"
FEDORA_RELEASE="${FEDORA_RELEASE:-42}"
IMAGE="${IMAGE:-fedora:${FEDORA_RELEASE}}"
LABEL="Calico-Linux-${VERSION}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v docker >/dev/null 2>&1; then
  echo "error: docker is required to build locally" >&2
  exit 1
fi

docker run --privileged --rm -it \
  -v "${ROOT_DIR}:/work" \
  -w /work \
  -e FEDORA_RELEASE="${FEDORA_RELEASE}" \
  -e LABEL="${LABEL}" \
  "${IMAGE}" bash -c '
    set -euo pipefail
    dnf install -y livecd-tools spin-kickstarts git
    git clone --depth 1 --branch "f${FEDORA_RELEASE}" \
      https://pagure.io/fedora-kickstarts.git /tmp/ks
    cp /work/calico.ks /tmp/ks/calico.ks
    cp -r /work/configs /tmp/ks/configs
    cd /tmp/ks
    livecd-creator \
      --config=calico.ks \
      --fslabel="${LABEL}" \
      --cache=/var/cache/live \
      -p /tmp/ks
    cp /tmp/ks/*.iso /work/
    cd /work
    sha256sum ./*.iso > "${LABEL}.iso.sha256"
  '

echo "Done: ${ROOT_DIR}/${LABEL}.iso"
