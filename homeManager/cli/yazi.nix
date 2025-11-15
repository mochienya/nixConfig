extras@{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = extras.inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.yazi;
    plugins =
      let
        mkPlugin =
          {
            author,
            repo,
            rev ? "main",
            hash ? pkgs.lib.fakeHash,
            version ? "unstable",
          }:
          pkgs.yaziPlugins.mkYaziPlugin {
            inherit version;
            pname = repo;
            src = pkgs.fetchFromGitHub {
              inherit repo hash rev;
              owner = author;
            };
          };
      in
      with pkgs.yaziPlugins;
      {
        inherit
          smart-filter
          wl-clipboard
          ouch
          ;
        what-size = mkPlugin {
          author = "pirafrank";
          repo = "what-size.yazi";
          hash = "sha256-s2BifzWr/uewDI6Bowy7J+5LrID6I6OFEA5BrlOPNcM=";
        };
      };
    keymap = {
      # each entry in the attr gets turned into `{on = <lhs>; run = <rhs>;}` in a list
      mgr.prepend_keymap =
        pkgs.lib.mapAttrsToList
          (k: v: {
            on = k;
            run = v;
          })
          {
            "F" = "plugin smart-filter";
            "C" = "plugin ouch";
            "<C-y>" = "plugin wl-clipboard";
            "<C-s>" = "plugin what-size";
            "b" = ''shell -- ripdrag -xnA "$@"'';
          };
    };
    settings = {
      plugin.prepend_previewers =
        builtins.map
          (n: {
            mime = n;
            run = "ouch";
          })
          [
            "application/*zip"
            "application/x-tar"
            "application/x-bzip2"
            "application/x-7z-compressed"
            "application/x-rar"
            "application/vnd.rar"
            "application/x-xz"
            "application/xz"
            "application/x-zstd"
            "application/zstd"
            "application/java-archive"
          ];
      opener.extract = [
        { run = ''ouch d -yd "''${1%%.*}" "$@" ''; }
      ];
    };
  };

  # #region yazi file picker
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
      kdePackages.xdg-desktop-portal-kde
    ];
    config.common = {
      "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
    };
  };
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
  xdg.configFile."xdg-desktop-portal-termfilechooser/config" = {
    force = true;
    text = pkgs.lib.generators.toINI { } {
      filechooser.cmd = "${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh";
    };
  };
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "yazi.desktop";
  };
  # #endregion
}
