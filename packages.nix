# packages.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    agent-browser
    poppler-utils
    nodejs_24
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
