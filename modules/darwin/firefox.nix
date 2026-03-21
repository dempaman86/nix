{ config, lib, pkgs, ... }:
lib.mkIf config.laptop.features.firefox.enable {
  environment.systemPackages = [
    (pkgs.firefox.override {
      extraPolicies = {
        ExtensionSettings = {
          "vimium-c@gdh1995.cn" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
          };
        };
      };
    })
  ];
}
