args@{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = args.inputs.yazi.packages.${args.pkgs.stdenv.hostPlatform.system}.yazi;
    shellWrapperName = "yy";
    plugins =
      let
        mkPlugin =
          {
            author,
            repo,
            rev ? "main",
            hash ? args.lib.fakeHash,
            version ? "unstable",
          }:
          args.pkgs.yaziPlugins.mkYaziPlugin {
            inherit version;
            pname = repo;
            src = args.pkgs.fetchFromGitHub {
              inherit repo hash rev;
              owner = author;
            };
          };
      in
      with args.pkgs.yaziPlugins;
      {
        inherit
          smart-filter
          wl-clipboard
          ouch
          ;
        what-size = mkPlugin {
          author = "pirafrank";
          repo = "what-size.yazi";
          hash = "sha256-7q/45TopqbojNRvYDmP9+hgSGPmiyLHBcV051qpOB2Y=";
        };
      };
    keymap = {
      # each entry in the attr gets turned into `{on = <lhs>; run = <rhs>;}` in a list
      mgr.prepend_keymap =
        args.lib.mapAttrsToList
          (k: v: {
            on = k;
            run = v;
          })
          {
            "F" = "plugin smart-filter";
            "C" = "plugin ouch";
            "<C-y>" = "plugin wl-clipboard";
            "<C-s>" = "plugin what-size";
            "b" = ''shell -- ripdrag --and-exit --no-click --all-compact "$@"'';
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
        {
          run = ''
            for file; do
              ${args.lib.getExe args.pkgs.ouch} decompress "$file" --yes &
            done
            wait
          '';
        }
      ];
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with args.pkgs; [
      xdg-desktop-portal-termfilechooser
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
    text = args.lib.generators.toINI { } {
      filechooser.cmd = "${args.pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh";
    };
  };
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "yazi.desktop";
  };
}
