{ pkgs, self, ... }:
{
  age.secrets.glance-env = {
    file = ../secrets/glance-env.age;
    path = "/run/agenix/glance-env";
    owner = "root";
    mode = "0444";
  };
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
        ports = [ "127.0.0.1:8083:8080" ];
        volumes = [
          "/var/lib/glance/config:/app/config"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
        env_file = [ "/run/agenix/glance-env" ];
      };
    };

    docker-compose.volumes = { };
  };
}
