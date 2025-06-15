extras@{ pkgs, ... }:
{
  home.packages = with pkgs; [
    github-desktop
    zed-editor
    micro
    vscode
    nixd
    pkg-config
    openssl
    cmake
    gcc
    gnumake
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
