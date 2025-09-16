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
  ];

 # this is only here for the fish integration
  programs.direnv.enable = true;

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
    userName = "mochie~!";
    userEmail = "187453775+mochienya@users.noreply.github.com";
  };
}
