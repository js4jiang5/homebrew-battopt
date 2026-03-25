#require_relative "../lib/github_private_strategy"

cask "battopt" do
  version "0.0.1"
  sha256 "42cd13a76ae197bbf07ade0c4338377b48f9177706c4cf93ea568e2c34219a84"

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
                   args: ["-a", "BattOpt"],
                   print_stderr: false
  end

  # This is the caveats block
  caveats <<~EOS
    BattOpt has been installed to /Applications. 
    It should open automatically to complete setup.
    If it doesn't, please launch it from your Applications folder.
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
                     sudo: true
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