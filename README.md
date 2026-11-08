# Mumcord Homebrew tap

Install [Mumcord](https://mumcord.app/), the voice chat client for Mumble servers, with Homebrew.

**macOS**

```sh
brew install --cask mumcord/tap/mumcord
```

Mumcord updates itself; `brew upgrade --cask --greedy mumcord` also works.
`brew uninstall --cask --zap mumcord` removes the app and its data.

**Linux** (x86_64 and arm64)

```sh
brew install mumcord/tap/mumcord
```

This installs the AppImage as `mumcord`. It needs FUSE 2 from your distribution, and for
H.264 videos your distribution's gst-libav; `brew info mumcord/tap/mumcord` lists the
packages. For a regular system install use the `.deb` or `.rpm` from the
[releases](https://github.com/Mumcord/mumcord/releases).

The cask and the formula follow new Mumcord releases automatically (`.github/workflows/bump.yml`).
