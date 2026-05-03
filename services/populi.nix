{ ... }:
{
  age.secrets.populi-db-env = {
    file = ../secrets/populi-db-env.age;
    path = "/run/agenix/populi-db-env";
    owner = "root";
    mode = "0444";
  };

  age.secrets.populi-env = {
    file = ../secrets/populi-env.age;
    path = "/run/agenix/populi-env";
    owner = "root";
    mode = "0444";
  };

  virtualisation.arion.projects = {
    populi.settings = {
      services = {
        populi.service = {
          image = "registry.henriquesf.me/populi:7f76e2b039b85de5bcb53828f0d6c0d788337aee";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8089:3000" ];
          depends_on = [ "postgres" ];
          env_file = [
            "/run/agenix/populi-env"
          ];
          environment = {
            PORT = "3000";
          };
        };

        postgres.service = {
          image = "postgres:18-alpine";
          restart = "unless-stopped";
          env_file = [ "/run/agenix/populi-db-env" ];
          ports = [ "127.0.0.1:8090:5432" ];
          volumes = [
            "populi-postgres-data:/var/lib/postgresql/"
          ];
        };
      };

      docker-compose.volumes = {
        populi-postgres-data = { };
      };
    };
  };
}

