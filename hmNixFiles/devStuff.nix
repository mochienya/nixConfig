extras@{ pkgs, ... }:
{
  home.packages = with pkgs; [
    github-desktop
    devenv
    direnv
    zed-editor
    micro
    vscode
    nixd
    rustup
    gcc
    glibc
    pnpm
    nodejs_24
    bun
    nixfmt-rfc-style
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
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
