{ ... }:

{
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = "/home/mochie/nixConfig/assets/trans-nix-wallpaper.png";
      wallpaperFillMode = "preserveAspectFit";
      wallpaperBackground.color = "30,30,38";
    };

    # disable the stupid thing that happens when you put your mouse in the upper left
    configFile = {
      kwinrc = {
        Effect-Overview.activationBorder = 0;
        Effect-overview.BorderActivate = 9;
      };
    };

    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

    panels = [
      {
        location = "bottom";
        height = 38;
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "/home/mochie/nixConfig/assets/trans-nix.svg";
            };
          }
          {
            iconTasks.launchers = [
              "applications:code.desktop"
              "applications:zen-twilight.desktop"
              "applications:kitty.desktop"
              "applications:equibop.desktop"
            ];
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.battery"
              ];
              hidden = [ "org.kde.plasma.clipboard" ];
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
              time.format = "12h";
            };
          }
        ];
      }
    ];
  };
}
