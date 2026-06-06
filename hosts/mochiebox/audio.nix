args@{ pkgs, ... }:

{
  systemd.user.services.fix-at2020-vol = {
    wantedBy = [ "default.target" ];
    after = [
      "pipewire.service"
      "wireplumber.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${args.lib.getExe' args.pkgs.alsa-utils "amixer"} -c AT2020USB sset Mic 100% unmute";
    };
  };
}
