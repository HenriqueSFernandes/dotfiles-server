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
          image = "registry.henriquesf.me/impact-sphere-site:c075cff36634e0f56d01419fc62465eec3c97db6";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8084:3000" ];
        };
      };
    };
    impact-sphere-dash.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere-dash:1fac9cb0cabf55f18bdcbaa0690a7e6dffaee595";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8085:3000" ];
          env_file = [ "/run/agenix/impact-sphere-env" ];
        };
        postgres.service = {
          image = "postgres:18-alpine";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8091:5432" ];
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
