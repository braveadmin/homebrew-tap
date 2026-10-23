class KubeCity < Formula
  desc "A living isometric city of your Kubernetes cluster, in the browser or the terminal"
  homepage "https://github.com/braveadmin/kube-city"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.2.0/kube-city-aarch64-apple-darwin.tar.gz"
      sha256 "077481678a03e3e6a725aaceab98a27f9fb8a27bada8af6bb2c8244cc20ab66b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.2.0/kube-city-x86_64-apple-darwin.tar.gz"
      sha256 "d1cc21aaab9e699e3373b04d2a5ef5c476e3825143d33b5222e41570130cb240"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.2.0/kube-city-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "db736bd665c497b7304e3127d8d6b9b4889b080875b52289ad225c933f9d4bc8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.2.0/kube-city-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5c5bafafb0c72b4d8f2832009e44991b4f15ba7693906a6af270450a9c241c92"
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
