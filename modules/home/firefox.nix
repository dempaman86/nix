{ lib, laptop, ... }:
lib.mkIf laptop.features.firefox.enable {
  programs.firefox = {
    enable = true;
    package = null;

    policies = {
      ExtensionSettings = {
        "vimium-c@gdh1995.cn" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
        };
      };
    };
  };
}
