{ ... }:
{
  age.secrets.rio-tinto-api-env = {
    file = ../secrets/rio-tinto-api-env.age;
    path = "/run/agenix/rio-tinto-api-env";
    owner = "root";
    mode = "0444";
  };
  age.secrets.rio-tinto-db-env = {
    file = ../secrets/rio-tinto-db-env.age;
    path = "/run/agenix/rio-tinto-db-env";
    owner = "root";
    mode = "0444";
  };

  virtualisation.arion.projects = {
    rio-tinto.settings = {
      services = {
        api.service = {
          image = "registry.henriquesf.me/rio-tinto-api:f5ae48fdafbb767d8c581020f26411f5090a9695";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8081:3000" ];
          volumes = [
            "rio-tinto-api-data:/data"
          ];
          depends_on = [ "postgres" ];
          env_file = [
            "/run/agenix/rio-tinto-api-env"
          ];
          environment = {
            PORT = "3000";
            DATA_DIR = "/data";
          };
        };

        frontend.service = {
          image = "registry.henriquesf.me/rio-tinto-frontend:f5ae48fdafbb767d8c581020f26411f5090a9695";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8082:80" ];
        };

        postgres.service = {
          image = "postgres:18-alpine";
          restart = "unless-stopped";
          env_file = [ "/run/agenix/rio-tinto-db-env" ];
          volumes = [
            "rio-tinto-postgres-data:/var/lib/postgresql/data"
          ];
        };
      };

      docker-compose.volumes = {
        rio-tinto-api-data = { };
        rio-tinto-postgres-data = { };
      };
    };
  };
}

