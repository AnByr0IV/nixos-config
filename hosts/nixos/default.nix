{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix      # Hardware config
      ../../nova/nixfiles/modules/nixos     # Nova Nix-modules & Default Configs
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  #services.bluetooth.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.hide-top-bar

    kitty
    rofi
    wl-clipboard
    grim
    slurp
    brightnessctl
    networkmanagerapplet
    pavucontrol
    hyprlock
    hypridle
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = false;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  system.stateVersion = "26.05"; 

  nova.profile = "shared";
  nova.substituters.nova.password = builtins.readFile /home/nova/nova/nixfiles/secrets/hydra-password.txt;
  home-manager.sharedModules = [{
  	home.stateVersion = "25.05";
  }];
  home-manager.backupFileExtension = "backup";
  
  home-manager.users.nova = {
    # imports = [ ./nixosModules/hyprland-home.nix ];

    programs.git = lib.mkForce {
      enable = true;
      userName = "AnByr0IV";
      userEmail = "angusbyron28@gmail.com";
    };

    # downloaded apps
    home.packages = with pkgs;  [
      google-chrome 
      slack
      zoom-us
      discord
      spotify

      gnomeExtensions.dash-to-dock
    ];
    
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = lib.mkForce "file:///home/nova/Pictures/backgrounds/rocket_background.png";
        picture-uri-dark = lib.mkForce "file:///home/nova/Pictures/backgrounds/rocket_background.png";
        picture-options = "zoom";
      };
    
      "org/gnome/shell" = {
        enabled-extensions = [
          "hidetopbar@mathieu.bidon.ca"
          "dash-to-dock@micxgx.gmail.com" 
        ];
      };

      "org/gnome/shell/extensions/hidetopbar" = {
        enable-intellihide = true;
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = lib.mkForce "RIGHT";
        dock-fixed = lib.mkForce false;
        autohide = lib.mkForce true;
        intellihide = lib.mkForce true;
        extend-height = false;
        show-trash = false;
      };
    };
  };
}