class ScreenshotClip < Formula
  desc "Auto-copy screenshots to clipboard instantly. Built for AI-assisted workflows."
  homepage "https://github.com/TheLoneWulf-WA/screenshot-clip"
  url "https://github.com/TheLoneWulf-WA/screenshot-clip/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "4ddc06d4302f2c9449aa8b355be6359411e6c42574c8e4e843ae84add1e764cc"
  license "MIT"

  depends_on :macos
  depends_on "fswatch"

  def install
    bin.install "bin/screenshot-clip"
    bin.install "bin/screenshot-clip-install"
    bin.install "bin/screenshot-clip-uninstall"
  end

  def post_install
    ohai "Run 'screenshot-clip-install' to start the background service."
    ohai "Screenshots will auto-copy to your clipboard."
  end

  def caveats
    <<~EOS
      To start screenshot-clip:
        screenshot-clip-install

      To watch a custom folder (default is ~/Desktop):
        screenshot-clip-install ~/Pictures/Screenshots

      To stop:
        screenshot-clip-uninstall

      Logs: /tmp/screenshot-clip.log
    EOS
  end
end
