# packages.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    htop
    lazydocker
    arion
  ];
}
