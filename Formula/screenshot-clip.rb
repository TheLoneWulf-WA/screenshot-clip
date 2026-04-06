class ScreenshotClip < Formula
  desc "Auto-copy macOS screenshots to your clipboard instantly"
  homepage "https://github.com/TheLoneWulf-WA/screenshot-clip"
  url "https://github.com/TheLoneWulf-WA/screenshot-clip/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "c1c13e993219ca4882063e6550b5225601b982763f438c7483913a978cff7b70"
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
