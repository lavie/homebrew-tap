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
      sha256 "8fddc18cab59289f5a9c3da4ccb9116e497722b2175e19c6831a21ef848c5c2b"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/lavie/runlike/releases/download/v2.0.0/runlike-linux-amd64"
      sha256 "7b3915885a88442e7457a4093fc531b46bb4d0781b26489b3369b2af0ced59ea"
    end
    on_arm do
      url "https://github.com/lavie/runlike/releases/download/v2.0.0/runlike-linux-arm64"
      sha256 "38e0c1dbc8e6b866d41cc098f733de0a02f82fbc2b23aebc482d7e3b9ce72536"
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
