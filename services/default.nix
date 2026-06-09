{ pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    ./populi.nix
    ./beszel.nix
    ./glance.nix
    ./impact-sphere.nix
    ./overleaf.nix
    ./registry.nix
    ./riotinto.nix
    ./uptime.nix
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
    virtualHosts."api.tennis.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8081
    '';
    virtualHosts."tennis.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8082
    '';
    virtualHosts."glance.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8083
    '';
    virtualHosts."impactsphere.org".extraConfig = ''
      reverse_proxy localhost:8084
    '';
    virtualHosts."dash.impactsphere.org".extraConfig = ''
      reverse_proxy localhost:8085
    '';
    virtualHosts."beszel.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8086
    '';
    virtualHosts."overleaf.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8087
    '';
    virtualHosts."uptime.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8088
    '';
    virtualHosts."status.impactsphere.org".extraConfig = ''
      reverse_proxy localhost:8088
    '';
    virtualHosts."status.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8088
    '';
    virtualHosts."populi.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8089
    '';
    virtualHosts."db.populi.henriquesf.me".extraConfig = ''
      reverse_proxy localhost:8090
    '';
    virtualHosts."flix.henriquesf.me".extraConfig = ''
      reverse_proxy 100.85.35.47:7774
    '';
    virtualHosts."jellyfin.henriquesf.me".extraConfig = ''
      reverse_proxy 100.85.35.47:8096
    '';
    virtualHosts."seerr.henriquesf.me".extraConfig = ''
      @cors_preflight {
        method OPTIONS
      }
      handle @cors_preflight {
        header Access-Control-Allow-Origin "https://flix.henriquesf.me"
        header Access-Control-Allow-Methods "GET, POST, OPTIONS, PUT, DELETE"
        header Access-Control-Allow-Headers "X-Requested-With,Content-Type,Authorization,X-Api-Key,Accept,Origin"
        header Access-Control-Allow-Credentials "true"
        respond "" 204
      }

      header Access-Control-Allow-Origin "https://flix.henriquesf.me"
      header Access-Control-Allow-Methods "GET, POST, OPTIONS, PUT, DELETE"
      header Access-Control-Allow-Headers "X-Requested-With,Content-Type,Authorization,X-Api-Key,Accept,Origin"
      header Access-Control-Allow-Credentials "true"

      reverse_proxy 100.85.35.47:5055
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
}
