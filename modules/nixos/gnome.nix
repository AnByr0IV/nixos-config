{config, lib, pkgs, ... }:

let cfg = config.my.gnome; in
{
  options.my.gnome.enable = lib.mkEnableOption "GNOME desktop with GDM";

  config = lib.mkIf cfg.enable {

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Hide GNOME top bar when full window
    environment.systemPackages = [ pkgs.gnomeExtensions.hide-top-bar ];
  };
}