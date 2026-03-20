{ config, lib, ... }:
let
  keyboardDeviceKey = "com.apple.keyboard.modifiermapping.1452-833-0";
  keyboardMapping = [
    {
      HIDKeyboardModifierMappingSrc = 1095216660483;
      HIDKeyboardModifierMappingDst = 30064771300;
    }
    {
      HIDKeyboardModifierMappingSrc = 280379760050179;
      HIDKeyboardModifierMappingDst = 30064771296;
    }
    {
      HIDKeyboardModifierMappingSrc = 30064771129;
      HIDKeyboardModifierMappingDst = 30064771113;
    }
    {
      HIDKeyboardModifierMappingSrc = 30064771300;
      HIDKeyboardModifierMappingDst = 30064771300;
    }
    {
      HIDKeyboardModifierMappingSrc = 30064771296;
      HIDKeyboardModifierMappingDst = 30064771296;
    }
  ];
  keyboardMappingArrayArgs = lib.concatMapStringsSep " \\\n      " (mapping:
    "'<dict><key>HIDKeyboardModifierMappingSrc</key><integer>${toString mapping.HIDKeyboardModifierMappingSrc}</integer><key>HIDKeyboardModifierMappingDst</key><integer>${toString mapping.HIDKeyboardModifierMappingDst}</integer></dict>'"
  ) keyboardMapping;
in
{
  system.activationScripts.postUserDefaults.text = ''
    /usr/bin/sudo -u ${config.system.primaryUser} /usr/bin/defaults -currentHost write -g '${keyboardDeviceKey}' -array \
      ${keyboardMappingArrayArgs}
    /usr/bin/killall cfprefsd >/dev/null 2>&1 || true

  '' + lib.optionalString config.laptop.features.dock.enable ''
    /usr/bin/defaults write com.apple.dock autohide -bool true
    /usr/bin/defaults write com.apple.dock orientation -string left
    /usr/bin/defaults write com.apple.dock show-recents -bool false
    /usr/bin/defaults write com.apple.dock tilesize -int 45
    /usr/bin/defaults write com.apple.dock wvous-br-corner -int 14
    /usr/bin/killall Dock >/dev/null 2>&1 || true
  '';
}
