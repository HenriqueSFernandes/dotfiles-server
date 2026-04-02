{ pkgs, self, ... }:
{
  age.secrets.librechat-env = {
    file = ../secrets/librechat-env.age;
    path = "/run/agenix/librechat-env";
    owner = "root";
    mode = "0444";
  };

  system.activationScripts.librechat-config = ''
    mkdir -p /var/lib/librechat
    ${pkgs.coreutils}/bin/cp -r ${self}/librechat-config/* /var/lib/librechat/ 2>/dev/null || true
    ${pkgs.coreutils}/bin/chown -R root:root /var/lib/librechat
    ${pkgs.coreutils}/bin/chmod -R 644 /var/lib/librechat
  '';

  virtualisation.arion.projects.librechat.settings = {
    services = {
      api.service = {
        image = "registry.librechat.ai/danny-avila/librechat-dev-api:latest";
        container_name = "LibreChat-API";
        restart = "always";
        ports = [ "127.0.0.1:3080:3080" ];
        depends_on = [ "mongodb" "rag_api" ];
        env_file = [ "/run/agenix/librechat-env" ];
        environment = {
          HOST = "0.0.0.0";
          NODE_ENV = "production";
          MONGO_URI = "mongodb://mongodb:27017/LibreChat";
          MEILI_HOST = "http://meilisearch:7700";
          RAG_PORT = "8000";
          RAG_API_URL = "http://rag_api:8000";
        };
        volumes = [
          "/var/lib/librechat/librechat.yaml:/app/librechat.yaml"
          "/var/lib/librechat/images:/app/client/public/images"
          "/var/lib/librechat/uploads:/app/uploads"
          "/var/lib/librechat/logs:/app/api/logs"
        ];
      };

      client.service = {
        image = "nginx:1.27.0-alpine";
        container_name = "LibreChat-NGINX";
        restart = "always";
        ports = [ "127.0.0.1:80:80" ];
        depends_on = [ "api" ];
        volumes = [
          "/var/lib/librechat/nginx.conf:/etc/nginx/conf.d/default.conf"
        ];
      };

      mongodb.service = {
        image = "mongo:8.0.20";
        container_name = "chat-mongodb";
        restart = "always";
        volumes = [
          "/var/lib/librechat/mongo:/data/db"
        ];
        command = [ "mongod" "--noauth" ];
      };

      meilisearch.service = {
        image = "getmeili/meilisearch:v1.35.1";
        container_name = "chat-meilisearch";
        restart = "always";
        env_file = [ "/run/agenix/librechat-env" ];
        environment = {
          MEILI_HOST = "http://meilisearch:7700";
          MEILI_NO_ANALYTICS = "true";
        };
        volumes = [
          "/var/lib/librechat/meili_data:/meili_data"
        ];
      };

      vectordb.service = {
        image = "pgvector/pgvector:0.8.0-pg15-trixie";
        container_name = "chat-vectordb";
        restart = "always";
        environment = {
          POSTGRES_DB = "mydatabase";
          POSTGRES_USER = "myuser";
          POSTGRES_PASSWORD = "mypassword";
        };
        volumes = [
          "librechat_pgdata:/var/lib/postgresql/data"
        ];
      };

      rag_api.service = {
        image = "registry.librechat.ai/danny-avila/librechat-rag-api-dev-lite:latest";
        container_name = "LibreChat-RAG-API";
        restart = "always";
        depends_on = [ "vectordb" ];
        env_file = [ "/run/agenix/librechat-env" ];
        environment = {
          DB_HOST = "vectordb";
          RAG_PORT = "8000";
        };
      };
    };

    docker-compose.volumes = {
      "librechat_pgdata" = {};
    };
  };
}
