{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    beammp-launcher
    (
      let
        libraryPath =
          with pkgs;
          lib.makeLibraryPath [
            fontconfig
            freetype
            glib
            nss
            nspr
            dbus
            atk
            cups
            libdrm
            libx11
            libxcomposite
            libxdamage
            libxext
            libxfixes
            libxrandr
            libgbm
            libxcb
            libxkbcommon
            pango
            cairo
            alsa-lib
            vulkan-loader
            libglvnd
          ];
      in
      # to be executed by steam launch args
      pkgs.writeScriptBin "launch-beamng" ''
        #!/usr/bin/env ${pkgs.lib.getExe pkgs.bash}

        set -euo pipefail

        export LD_LIBRARY_PATH="${libraryPath}:$LD_LIBRARY_PATH"

        cmd=$(printf '%s ' "$@")
        cmd=$(sed -E 's#/[^ ]*/steam-launch-wrapper -- .* ([^ ]*/proton waitforexitandrun)##' <<< "$cmd")
        cmd=$(sed -E 's#BeamNG\.drive\.exe#BinLinux/BeamNG.drive.x64#' <<< "$cmd")

        $cmd
      ''
    )
  ];
}
