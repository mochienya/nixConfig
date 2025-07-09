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
    nodejs_latest
    bun
    nixfmt-rfc-style
    extras.inputs.mcp-nixos.packages.${pkgs.system}.mcp-nixos
    direnv
    devenv
  ];

  programs.direnv.enable = true;

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
