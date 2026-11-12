class Mumcord < Formula
  desc "Voice chat client for Mumble servers"
  homepage "https://mumcord.app/"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/Mumcord/mumcord/releases/download/v0.8.0/Mumcord_0.8.0_amd64.AppImage"
      sha256 "19b62479176bc6a76738e952fa3bd09c2fe8c106ff8f30851c1d6219fac9f745"
    end
    on_arm do
      url "https://github.com/Mumcord/mumcord/releases/download/v0.8.0/Mumcord_0.8.0_aarch64.AppImage"
      sha256 "f3d39b41595c8edc17a5c2af72cdb96799b978fb8dc7ab8d701f7cba64a2f281"
    end
  end

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
