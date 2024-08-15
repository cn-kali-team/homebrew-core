class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.52.1.tar.gz"
  sha256 "622974a9653f07874d9c6a627af130163bf3cde7eb0f1b89baa2f3a7fa76b8a4"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4834afdf2217e9e9c7f19ec1442ffb51b7416aba6716618cf31b654b9d15c681"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d85289895d5b7afd2630c21298d505f336d452e06432c98c3f6688293b3a2b15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3837e453158fe40e562c4a7886e46aeae42be015e991fde049c7bef33961a5e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "db3a157120838ca2a5db4c32536308dd783c2d08208f6471ca7e9ea531d6f8c8"
    sha256 cellar: :any_skip_relocation, ventura:        "e12fd0ecf2eaf99dcfc122e71c9ba8b5b1e76c60dcfe31999fab6bd54a2e6e51"
    sha256 cellar: :any_skip_relocation, monterey:       "df6d6ea8e10654ef7278838f1a672bf579ee813a20b956fcd52ec6d8ce7abcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85d19053256ca0953b0fee7369fe4f2b306ccddd42a6a40f9de55535cb849ba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
