{ pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    ./registry.nix
    ./riotinto.nix
  ];


  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."registry.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8080
    '';
    virtualHosts."tennis.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8081
    '';
    virtualHosts."api.tennis.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:3000
    '';
  };

  systemd.services.caddy.serviceConfig = {
    PrivateTmp = lib.mkForce false;
    PrivateDevices = lib.mkForce false;
    ProtectSystem = lib.mkForce false;
    ProtectHome = lib.mkForce false;
    PrivateUsers = lib.mkForce false;
    RestrictNamespaces = lib.mkForce false;
  };

  virtualisation.arion.backend = "docker";

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
