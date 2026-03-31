{ ... }:
{
  age.secrets.rio-tinto-app-password = {
    file = ../secrets/rio-tinto-app-password.age;
    path = "/run/agenix/rio-tinto-app-password";
    owner = "root";
    mode = "0444";
  };

  virtualisation.arion.projects = {
    rio-tinto.settings = {
      services = {
        api.service = {
          image = "registry.henriquesf.me/rio-tinto-api:2c628e25abf56a29f0defecb12eb6ef68e7bc4c1";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:3000:3000" ];
          volumes = [
            "rio-tinto-api-data:/data"
          ];
          env_file = [ "/run/agenix/rio-tinto-app-password" ];
          environment = {
            PORT = "3000";
            DATA_DIR = "/data";
          };
        };

        frontend.service = {
          image = "registry.henriquesf.me/rio-tinto-frontend:2c628e25abf56a29f0defecb12eb6ef68e7bc4c1";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8081:80" ];
        };
      };

      docker-compose.volumes.rio-tinto-api-data = { };
    };
  };
}

