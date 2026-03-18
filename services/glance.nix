{ pkgs, self, ... }:
{
  # Create directory and copy config files on activation
  system.activationScripts.glance-config = ''
    mkdir -p /var/lib/glance/config
    ${pkgs.coreutils}/bin/cp -r ${self}/glance-config/* /var/lib/glance/config/ 2>/dev/null || true
    ${pkgs.coreutils}/bin/chown -R root:root /var/lib/glance/config
    ${pkgs.coreutils}/bin/chmod -R 644 /var/lib/glance/config
  '';

  # Arion project definition for Glance
  virtualisation.arion.projects.glance.settings = {
    services = {
      glance.service = {
        image = "glanceapp/glance:latest";
        container_name = "glance";
        restart = "unless-stopped";
        ports = [ "127.0.0.1:8080:8080" ];
        volumes = [
          "/var/lib/glance/config:/app/config"
        ];
      };
    };

    docker-compose.volumes = { };
  };
}
