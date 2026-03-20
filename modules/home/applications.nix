{ laptop, lib, ... }:
lib.mkIf laptop.features.applications.enable {
  targets.darwin.linkApps.enable = false;
  targets.darwin.copyApps.enable = false;
}
