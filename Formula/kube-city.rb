class KubeCity < Formula
  desc "A living isometric city of your Kubernetes cluster, in the browser"
  homepage "https://github.com/braveadmin/kube-city"
  version "0.6.0"
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.6.0/kube-city-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b3ae4fa65c5fac92530bcf46b30b7507162b9ab76c25f6b51cf990d8b7a1aa12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.6.0/kube-city-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bd8686ff5978f8358601df22da19e5cc6285feb99f2c652184880650be78dab9"
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
