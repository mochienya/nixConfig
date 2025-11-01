{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zed-editor
    micro
    vscode
    nixd
    pnpm
    nodejs_latest
    bun
    nixfmt-rfc-style
    direnv
    devenv
    lazygit
    gnupg
  ];

  # this is only here for the fish integration
  programs.direnv.enable = true;

  services.gpg-agent = {
    enable = true;
    enableScDaemon = false;
    enableExtraSocket = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs.ssh = {
    enable = true;
    matchBlocks."*".addKeysToAgent = "yes";
    extraConfig = ''
      Host github.com
          IdentityFile ~/.ssh/github
    '';
  };

  programs.git = {
    enable = true;
    signing.key = "7A49511084F4EAF1BE305CF0CC3BE964564F9554";
    settings = {
      pull.rebase = true;
      user = {
        name = "mochie~!";
        email = "187453775+mochienya@users.noreply.github.com";
      };
    };
  };
}
