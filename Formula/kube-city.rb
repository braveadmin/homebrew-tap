class KubeCity < Formula
  desc "A living isometric city of your Kubernetes cluster, in the browser or the terminal"
  homepage "https://github.com/braveadmin/kube-city"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.3.0/kube-city-aarch64-apple-darwin.tar.gz"
      sha256 "f6ecfc02f7760b42745f85314be389fbda651aefa08750de7da58591159da715"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.3.0/kube-city-x86_64-apple-darwin.tar.gz"
      sha256 "693321bac199515ed6ddea3d78672a39162702d65a17391a284e6d0851d2c68c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.3.0/kube-city-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "99a25c1725143ca24649c442dda5eb56d7bad1b86f07f37696ff8685aca40c7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.3.0/kube-city-x86_64-unknown-linux-musl.tar.gz"
      sha256 "18b16420724d9ccd4eea7062205683819cf790b0d2dd320c74e758f969e71bd0"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "kube-city"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kube-city"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "kube-city"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "kube-city"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
