# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nova/nixfiles/modules/nixos
    ];

  zramSwap = {
    enable = true;
    memoryPercent = 200;
  };

  #devices.laptop = {
  #  enable = true;
  #  intel = true;
  #  intel-new = true;
  #  performance = true;
  #};

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
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
    waybar
    hyprpaper
    hyprlock
    hypridle
    wl-clipboard
    grim
    slurp
    brightnessctl
    networkmanagerapplet
    pavucontrol
  ];

  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  # Wayland support
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; #


  nova.profile = "shared";
  nova.substituters.nova.password = builtins.readFile /home/nova/nova/nixfiles/secrets/hydra-password.txt;
  home-manager.sharedModules = [{
  	home.stateVersion = "25.05";
  }];
  home-manager.backupFileExtension = "backup";
  
  home-manager.users.nova = {

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
    # Hyprland configuration
    wayland.windowManager.hyprland = {
      enable = true;

      # Required when using UWSM
      systemd.enable = false;

      settings = {
        "$mod" = "SUPER";

        bind = [
          "$mod, RETURN, exec, kitty"
          "$mod, Q, killactive"
          "$mod, M, exit"
          "$mod, D, exec, rofi -show drun"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
        };
      };
    };
  };
}

