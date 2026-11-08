class Mumcord < Formula
  desc "Voice chat client for Mumble servers"
  homepage "https://mumcord.app/"
  version "0.7.2"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_linux do
    on_intel do
      url "https://github.com/Mumcord/mumcord/releases/download/v#{version}/Mumcord_#{version}_amd64.AppImage"
      sha256 "11264b94db8957b6333ea00495c3b71d2b9fa164c6db31995c8af7ac76dbe0ca"
    end
    on_arm do
      url "https://github.com/Mumcord/mumcord/releases/download/v#{version}/Mumcord_#{version}_aarch64.AppImage"
      sha256 "70be74891689100a57d1c4c935d47c5b90f968efb871a35cfa5fb22a99f9adde"
    end
  end

  depends_on :linux

  def install
    appimage = Dir["*.AppImage"].first
    chmod 0755, appimage
    bin.install appimage => "mumcord"
  end

  def caveats
    <<~EOS
      Mumcord is installed as an AppImage at #{opt_bin}/mumcord.

      The AppImage needs FUSE 2 from your distribution:
        Debian/Ubuntu: sudo apt install libfuse2   (Ubuntu 24.04+: libfuse2t64)
        Fedora:        sudo dnf install fuse-libs
        Arch:          sudo pacman -S fuse2
      Without FUSE, start it with: mumcord --appimage-extract-and-run

      H.264 videos (e.g. Twitch in a watch party) need your distribution's gst-libav
      (Debian/Ubuntu: gstreamer1.0-libav, Fedora: gstreamer1-libav, Arch: gst-libav).
      Homebrew's GStreamer cannot be used: the AppImage brings its own GStreamer, which
      only loads plugins built for its version.
    EOS
  end

  test do
    assert_predicate bin/"mumcord", :executable?
  end
end
