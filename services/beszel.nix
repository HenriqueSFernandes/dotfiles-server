{ ... }:
{
  age.secrets.beszel-agent-key = {
    file = ../secrets/beszel-agent-key.age;
    path = "/run/agenix/beszel-agent-key";
    owner = "root";
    mode = "0444";
  };
  age.secrets.beszel-agent-token = {
    file = ../secrets/beszel-agent-token.age;
    path = "/run/agenix/beszel-agent-token";
    owner = "root";
    mode = "0444";
  };

  virtualisation.arion.projects.beszel.settings = {
    services = {
      hub.service = {
        image = "henrygd/beszel:latest";
        container_name = "beszel-hub";
        restart = "unless-stopped";
        ports = [ "127.0.0.1:8090:8090" ];
        volumes = [
          "beszel-data:/beszel_data"
          "beszel-socket:/beszel_socket"
        ];
        environment = {
          APP_URL = "https://beszel.henriquesf.me";
        };
      };

      agent.service = {
        image = "henrygd/beszel-agent:latest";
        container_name = "beszel-agent";
        restart = "unless-stopped";
        network_mode = "host";
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro"
          "beszel-socket:/beszel_socket"
          "/run/agenix/beszel-agent-key:/config/key:ro"
          "/run/agenix/beszel-agent-token:/config/token:ro"
        ];
        environment = {
          LISTEN = "/beszel_socket/beszel.sock";
          KEY_FILE = "/config/key";
          TOKEN_FILE = "/config/token";
        };
      };
    };

    docker-compose.volumes = {
      beszel-data = { };
      beszel-socket = { };
    };
  };
}
