# Written by runlike's release workflow (scripts/homebrew-formula.sh in
# lavie/runlike); edits here are overwritten by the next release.
class Runlike < Formula
  desc "Print the docker run command that recreates an existing container"
  homepage "https://github.com/lavie/runlike"
  license "BSD-3-Clause"

  on_macos do
    depends_on arch: :arm64 # no Intel macOS binary
    on_arm do
      url "https://github.com/lavie/runlike/releases/download/v2.0.0/runlike-darwin-arm64"
      sha256 "41df4f9522320e7fbef44e6438436d0a0a015243d2cee6b1e48ebd2ed400854e"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/lavie/runlike/releases/download/v2.0.0/runlike-linux-amd64"
      sha256 "494f5847a2ca1626fbbeb5a5ee30fdc1ba9548c5e7f73fd609b21d6f0e071964"
    end
    on_arm do
      url "https://github.com/lavie/runlike/releases/download/v2.0.0/runlike-linux-arm64"
      sha256 "58701187698b9214a6e96685c18a97f441705040e5dd33d89a09738701db9cb6"
    end
  end

  def install
    bin.install Dir["runlike-*"].first => "runlike"
  end

  test do
    assert_match "runlike v#{version}", shell_output("#{bin}/runlike --version")
    inspect = '[{"Name":"/web","Config":{"Image":"nginx:1.27","Env":["A=b c"]},"HostConfig":{}}]'
    assert_equal "docker run --name=web '--env=A=b c' --detach nginx:1.27",
                 pipe_output("#{bin}/runlike --stdin 2>/dev/null", inspect, 0).chomp
  end
end
