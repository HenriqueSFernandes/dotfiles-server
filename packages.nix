# packages.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    ghostty.terminfo
    vim
    curl
    wget
    htop
    lazydocker
    arion
  ];
}
