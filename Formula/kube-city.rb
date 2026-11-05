class KubeCity < Formula
  desc "A living isometric city of your Kubernetes cluster, in the browser"
  homepage "https://github.com/braveadmin/kube-city"
  version "0.5.0"
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.5.0/kube-city-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d59556e75e2e3aae477667d5fe1a1c3c93f60299c19e7d1bad07af79f909a7e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.5.0/kube-city-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2c4e0cff546316ac02a5c7877b83f7354d50ff13679408de22efae5f9c8259f3"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-unknown-linux-gnu":         {},
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
