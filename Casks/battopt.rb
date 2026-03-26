#require_relative "../lib/github_private_strategy"

cask "battopt" do
  version "0.0.1"
  sha256 "327ff3deec991417cc7681fb7fcdfbe4b77cb34315d8e5186f3a7cb87699b403"

  url "https://github.com/js4jiang5/BattOpt/releases/download/v#{version}/BattOpt_v#{version}.dmg"

  name "BattOpt"
  desc "Macbook battery Maintenance Utility with hybrid CLI and GUI interface"
  homepage "https://github.com/js4jiang5/BattOpt"

  app "BattOpt.app"

  # This runs AFTER the app is moved to /Applications
  postflight do
	  system_command "xattr",
                   args: ["-rd", "com.apple.quarantine", "#{appdir}/BattOpt.app"],
                   sudo: true

    system_command "open",
                   args: ["-a", "#{appdir}/BattOpt.app"],
                   print_stderr: false
  end

  # This is the caveats block
  caveats <<~EOS
    Once installation completes, BattOpt will attempt to launch automatically 
    to finalize setup. 
    
    If the app window does not appear, please launch it manually from:
      #{appdir}/BattOpt.app
  EOS

 uninstall_preflight do
    # Define the system path where your setup command copied the binary
    is_upgrade = ENV['HOMEBREW_COMMAND'] == 'upgrade'
    args = ["uninstall", "--from-homebrew"]
    args << "--is-upgrade" if is_upgrade
    system_binary = "/Library/Application Support/battopt/battopt"

    if File.exist?(system_binary)
      system_command system_binary,
                     args: args,
                     sudo: false
    end
  end

  # Minimalistic uninstall block
  uninstall quit: "com.buddha-path.BattOpt"

  zap trash: [
    "~/Library/Application Support/BattOpt",
    "~/Library/Caches/com.buddha-path.BattOpt",
    "~/Library/Preferences/com.buddha-path.BattOpt.plist",
  ]
end