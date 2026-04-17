#require_relative "../lib/github_private_strategy"

cask "battopt" do
  version "0.0.3"
  sha256 "ea1c09b9288c393604258bc0fff48207f31e907ac00f2f2df54d6a8b7bb4a7ed"

  #url "https://github.com/js4jiang5/BattOpt/releases/download/v#{version}/BattOpt_v#{version}.dmg"
  url "file:///Users/jsjiang/Coding/SwiftUI/BattOpt/BattOpt_v0.0.3.dmg"

  name "BattOpt"
  desc "Macbook battery Maintenance Utility with hybrid CLI and GUI interface"
  homepage "https://github.com/js4jiang5/BattOpt"

  app "BattOpt.app"

  # This runs AFTER the app is moved to /Applications
  postflight do
  system_command "xattr",
                  args: ["-rd", "com.apple.quarantine", "#{appdir}/BattOpt.app"]
  #                sudo: true

  #system_command "open",
  #                args: ["-a", "#{appdir}/BattOpt.app"],
  #                print_stderr: false
  end

  # This is the caveats block
  caveats <<~EOS
    After installation, change the system settings below to receive notifications
    1. System Settings > Battery > Battery Health > click the ⓘ icon > toggle off "Optimize Battery Charging"
    2. System Settings > Notifications > enable "Allow notifications when mirroring or sharing"
    3. System Settings > Notifications > Applications > Script Editor > Choose "Alerts"
  EOS

 uninstall_preflight do
    system_command "/usr/bin/pkill", 
                   args: ["-TERM", "-f", "BattOpt"], 
                   must_succeed: false
                 
    system_command "/usr/bin/pkill", 
                   args: ["-TERM", "-f", "battopt monitor"], 
                   must_succeed: false # 即使沒人在跑也不要報錯
                   
    ## Define the system path where your setup command copied the binary
    #system_binary = "/Library/Application Support/battopt/battopt"
    #args = ["uninstall", "--from-homebrew"]

    #if File.exist?(system_binary)
    #  system_command system_binary,
    #                  args: args
    #end
  end

  ## Minimalistic uninstall block
  #uninstall signal: [
  #      ["TERM", "com.buddha-path.BattOpt"],
  #]

  zap launchctl: "com.battopt.daemon",
      delete: [
        "/Library/Application Support/battopt/battopt",
        "/Library/Application Support/battopt/dictionary",
        "/Library/Application Support/battopt/battopt.sock",
        "/Library/LaunchDaemons/com.battopt.daemon.plist",
        "/Library/Logs/battopt/battopt.log",
        "/Library/Logs/DiagnosticReports/battopt*",
        "/etc/paths.d/battopt",
        "~/Library/LaunchAgents/com.battopt.BattOptGUI.plist",
        "~/Library/Caches/com.buddha-path.BattOpt",
        "~/Library/Preferences/com.buddha-path.BattOpt.plist",
        "~/Library/HTTPStorages/com.buddha-path.BattOpt/",
        "~/Library/Logs/DiagnosticReports/BattOpt*",
      ]
end