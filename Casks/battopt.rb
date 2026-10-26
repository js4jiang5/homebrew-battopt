#require_relative "../lib/github_private_strategy"

cask "battopt" do
  version "1.2.11"
  sha256 "67b0a727b5cfcb682836b4f5559363253aac814cc5b51cb04d8da9d2c3db2bbe"

  url "https://github.com/js4jiang5/BattOpt/releases/download/v#{version}/BattOpt_v#{version}.dmg"

  name "BattOpt"
  desc "Macbook battery Maintenance Utility with hybrid CLI and GUI interface"
  homepage "https://github.com/js4jiang5/BattOpt"

  app "BattOpt.app"

  # This runs AFTER the app is moved to /Applications
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-rd", "com.apple.quarantine", "{{appdir}}/BattOpt.app"]
  end

  # This is the caveats block
  caveats <<~EOS
    After installation, change the system settings below to receive notifications
    1. System Settings > Battery > Battery Health > click the ⓘ icon > toggle off "Optimize Battery Charging"
    2. System Settings > Notifications > enable "Allow notifications when mirroring or sharing"
    3. System Settings > Notifications > Applications > Script Editor > Choose "Alerts"
    4. close and reopen Terminal for path to become effective
  EOS

  uninstall_preflight_steps do
    run "/usr/bin/pkill",
        args:         ["-TERM", "-f", "BattOpt"],
        must_succeed: false

    run "/usr/bin/pkill",
        args:         ["-TERM", "-f", "battopt monitor"],
        must_succeed: false
  end

  zap launchctl: "com.buddha-path.BattOpt.daemon",
      delete: [
        "/Library/Application Support/battopt/battopt",
        "/Library/Application Support/battopt/dictionary",
        "/Library/Application Support/battopt/battopt.sock",
        "/Library/LaunchDaemons/com.buddha-path.BattOpt.daemon.plist",
        "/Library/Logs/battopt/battopt.log",
        "/Library/Logs/DiagnosticReports/battopt*",
        "/etc/paths.d/battopt",
        "~/Library/LaunchAgents/com.buddha-path.BattOpt.GUI.plist",
        "~/Library/Caches/com.buddha-path.BattOpt",
        "~/Library/Preferences/com.buddha-path.BattOpt.plist",
        "~/Library/HTTPStorages/com.buddha-path.BattOpt/",
        "~/Library/Logs/DiagnosticReports/BattOpt*",
        "~/Library/Logs/battopt/battopt_gui.log",
      ]
end