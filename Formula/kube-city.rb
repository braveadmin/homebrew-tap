class KubeCity < Formula
  desc "A living isometric city of your Kubernetes cluster, in the browser"
  homepage "https://github.com/braveadmin/kube-city"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.4.0/kube-city-aarch64-apple-darwin.tar.gz"
      sha256 "9d46d9695c0f17f80d99c955e03a0e4550ec8c8d530b40796b0efdecc3b88f6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.4.0/kube-city-x86_64-apple-darwin.tar.gz"
      sha256 "da363ef95ae1f11d74154951f993c757c3c8c72b106bca351a2f9ca7fd63864c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.4.0/kube-city-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0467d93bf0090144039761304db24fcefaf23e3dec716b8b88a7eb685f9e98ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.4.0/kube-city-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e5c1ed380a8fc4bf3f17779cb84399369f69f2d551285b65ed3ef5323ab6b3cf"
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
