# packages.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    kubectl
    k9s
    argocd
    argonaut
    ghostty.terminfo
    vim
    curl
    wget
    htop
    lazydocker
    arion
  ];
}
