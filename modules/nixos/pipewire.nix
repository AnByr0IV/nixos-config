{ config, lib, ... }:

let cfg = config.my.audio; in
{
  options.my.audio.enable = lib.mkEnableOption "PipeWire audio";

  # Enable sound with pipewire, settings copied from nova template config
  config = lib.mkIf cfg.enable {

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}