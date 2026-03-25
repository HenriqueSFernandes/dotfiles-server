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
          image = "registry.henriquesf.me/rio-tinto-api:2174aa3709280b322377f1b8c0dad59780ad6f0b";
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
          image = "registry.henriquesf.me/rio-tinto-frontend:2174aa3709280b322377f1b8c0dad59780ad6f0b";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8081:80" ];
        };
      };

      docker-compose.volumes.rio-tinto-api-data = { };
    };
  };
}

