# Contributing to Calico Linux

Thanks for taking a look at the project. This repository only holds the
kickstart overlay and the CI that turns it into a bootable ISO, so changes are
small and easy to review.

## Layout

| Path | Purpose |
| --- | --- |
| `calico.ks` | kickstart overlay applied on top of Fedora XFCE |
| `.github/workflows/build.yml` | CI that builds the ISO and publishes a release |
| `scripts/build-local.sh` | containerised local build |
| `README.md` | user-facing docs |

## Making a change

1. Fork the repo and create a branch: `git switch -c fix/my-change`.
2. Keep the diff focused - one logical change per pull request.
3. Follow the existing kickstart style: 4 spaces, `%packages` blocks before
   `%post`, and no trailing whitespace (see `.editorconfig`).
4. Make sure `calico.ks` still references package groups that exist in the
   targeted Fedora branch.

## Testing

A full ISO build takes 15-30 minutes, so it is usually enough to:

```bash
# syntax sanity check for the kickstart
ksvalidator calico.ks
```

and, for anything touching packaging or branding, one local build:

```bash
./scripts/build-local.sh test
```

CI runs the same build for pull requests; the resulting ISO is uploaded as a
workflow artifact.

## Release notes

Version bumps, release tags and ISO checksums are handled by the build
workflow. When opening a PR, add a line to `CHANGELOG.md` under `Unreleased`.
