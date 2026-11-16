{ pkgs, lib, ... }:

let
  wallpaper = "/home/nova/Pictures/backgrounds/rocket_background.png";
in
{
  home.packages = with pkgs; [
    nwg-dock-hyprland # macOS-style dock
    swaybg            # wallpaper
    papirus-icon-theme # dock/launcher icons
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";

      monitor = ",preferred,auto,1";

      exec-once = [
        "swaybg -i ${wallpaper} -m fill"
        "waybar"
        "nm-applet --indicator"
        # -d autohide, -r resident, -i icon size, -mb bottom margin
        "nwg-dock-hyprland -d -r -i 48 -mb 10 -c 'rofi -show drun'"
      ];

      input = {
        kb_layout = "au";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = "10, 10, 10, 10";
        border_size = 2;
        "col.active_border" = "rgba(89b4faee) rgba(cba6f7ee) 45deg";
        "col.inactive_border" = "rgba(45475aaa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
        };
      };

      animations.enabled = true;

      misc.disable_hyprland_logo = true;

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, Space, exec, $menu"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod SHIFT, E, exit"
        "$mod, L, exec, hyprlock"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      ]
      ++ (builtins.concatLists (builtins.genList (i:
        let ws = toString (i + 1); in [
          "$mod, ${ws}, workspace, ${ws}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
        ]) 9));

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
    };
  };

  # Floating, centred "island" bar instead of a full-width bar
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      width = 640;        # fixed width => bar is centred, not full width
      height = 34;
      margin-top = 8;
      spacing = 12;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" ];

      "hyprland/workspaces" = {
        format = "{id}";
        on-click = "activate";
      };
      clock = {
        format = "{:%a %d %b  %H:%M}";
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "muted";
        format-icons.default = [ "" "" "" ];
        on-click = "pavucontrol";
      };
      network = {
        format-wifi = "  {essid}";
        format-ethernet = "wired";
        format-disconnected = "offline";
      };
      battery = {
        format = "{capacity}%";
        states = { warning = 30; critical = 15; };
      };
    };

    style = ''
      * {
        font-family: "Inter", "Noto Sans", sans-serif;
        font-size: 13px;
        border: none;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.75);
        color: #cdd6f4;
        border-radius: 18px;
        border: 1px solid rgba(255, 255, 255, 0.08);
      }
      #workspaces button {
        padding: 0 8px;
        color: #a6adc8;
        border-radius: 12px;
        background: transparent;
      }
      #workspaces button.active {
        color: #1e1e2e;
        background: #89b4fa;
      }
      #clock, #pulseaudio, #network, #battery {
        padding: 0 10px;
      }
      #battery.critical { color: #f38ba8; }
    '';
  };
}