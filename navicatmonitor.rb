class Navicatmonitor < Formula
  desc "Navicat Monitor is a safe, simple and agentless remote server monitoring tool that is packed with powerful features to make your monitoring effective as possible."
  homepage "https://www.navicat.com/en/products#navicat-monitor"
  url "https://navicat-download.oss-us-east-1.aliyuncs.com/monitor-download/homebrew/navicat-monitor_1.8.1.3.tar.gz"
  sha256 "9d1796a1414e8c8ae1dafc2b97928212c98e2a3c25d2d8f5ae5ad8940c1cbb67"

  bottle :unneeded

  def install
    # Preload
    system "./install.sh"
    libexec.install Dir["*"]

    # Symlink var and tmp to persist across version update
    rm_rf "#{libexec}/var"
    mkdir_p "#{var}/navicatmonitor/var"
    ln_s "#{var}/navicatmonitor/var", "#{libexec}/var"

    rm_rf "#{libexec}/tmp"
    mkdir_p "#{var}/navicatmonitor/tmp"
    ln_s "#{var}/navicatmonitor/tmp", "#{libexec}/tmp"

    # Create wrapper binary
    bin.write_exec_script "#{libexec}/wrapper"
    mv "#{bin}/wrapper", "#{bin}/navicatmonitor"
  end

  plist_options :startup => "true"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <dict>
        <key>Crashed</key>
        <true/>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{libexec}/wrapper</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{libexec}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/navicatmonitor version"
  end
end
