{ ... }:
{
  age.secrets.impact-sphere-db-env = {
    file = ../secrets/impact-sphere-db-env.age;
    path = "/run/agenix/impact-sphere-db-env";
    owner = "root";
    mode = "0444";
  };
  age.secrets.impact-sphere-env = {
    file = ../secrets/impact-sphere-env.age;
    path = "/run/agenix/impact-sphere-env";
    owner = "root";
    mode = "0444";
  };
  virtualisation.arion.projects = {
    impact-sphere-site.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere-site:f614a0081f9cde4d67e83507852724e6345bd3b4";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8084:3000" ];
        };
      };
    };
    impact-sphere-dash.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere-dash:149879190ab94cb1679b6e69dd0310b70ed2b1e9";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8085:3000" ];
          env_file = [ "/run/agenix/impact-sphere-env" ];
        };
        postgres.service = {
          image = "postgres:18-alpine";
          restart = "unless-stopped";
          env_file = [ "/run/agenix/impact-sphere-db-env" ];
          volumes = [
            "impact-sphere-postgres-data:/var/lib/postgresql/data"
          ];
        };
      };
      docker-compose.volumes = {
        impact-sphere-postgres-data = { };
      };
    };
  };
}
