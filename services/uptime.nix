{ ... }:
{
  virtualisation.arion.projects = {
    uptime.settings = {
      services = {
        uptime.service = {
          image = "louislam/uptime-kuma:2";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8088:3001" ];
          volumes = [
            "uptime-kuma-data:/app/data"
          ];
        };
      };
      docker-compose.volumes.uptime-kuma-data = { };
    };
  };
}
