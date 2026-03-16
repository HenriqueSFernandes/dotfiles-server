{ pkgs, ... }:
{
  virtualisation.arion.projects.overleaf.settings = {
    services = {
      sharelatex.service = {
        image = "tuetenk0pp/sharelatex-full:latest";
        container_name = "sharelatex";
        restart = "always";
        stop_grace_period = "60s";
        depends_on = [ "mongo" "redis" ];
        ports = [ "127.0.0.1:8082:80" ];
        volumes = [
          "/var/lib/sharelatex:/var/lib/overleaf"
        ];
        environment = {
          OVERLEAF_APP_NAME = "Overleaf Henrique";
          OVERLEAF_SITE_URL = "https://overleaf.henriquesf.me";
          OVERLEAF_BEHIND_PROXY = "true";
          OVERLEAF_ADMIN_EMAIL = "me@henriquesf.me";
          OVERLEAF_EMAIL_FROM_ADDRESS = "overleaf@henriquesf.me";
          OVERLEAF_MONGO_URL = "mongodb://mongo:27017/sharelatex";
          OVERLEAF_MONGO_REPLICA_SET = "overleaf";
          OVERLEAF_REDIS_HOST = "redis";
          REDIS_HOST = "redis";
          ENABLED_LINKED_FILE_TYPES = "project_file,project_output_file";
          ENABLE_CONVERSIONS = "true";
          EMAIL_CONFIRMATION_DISABLED = "true";
          SANDBOXED_COMPILES = "false";
        };
      };

      mongo.service = {
        image = "mongo:8.0";
        container_name = "mongo";
        restart = "always";
        command = [ "--replSet" "overleaf" ];
        volumes = [
          "/var/lib/sharelatex/mongo:/data/db"
          "${pkgs.writeText "mongodb-init-replica-set.js" ''
      rs.initiate({
        _id: 'overleaf',
        members: [
          { _id: 0, host: 'localhost:27017' }
        ]
      });
    ''}:/docker-entrypoint-initdb.d/mongodb-init-replica-set.js"
        ];
        environment.MONGO_INITDB_DATABASE = "sharelatex";
        healthcheck = {
          test = [ "CMD-SHELL" "echo 'db.stats().ok' | mongosh localhost:27017/test --quiet" ];
          interval = "10s";
          timeout = "10s";
          retries = 5;
        };
      };

      redis.service = {
        image = "redis:6.2";
        container_name = "redis";
        restart = "always";
        volumes = [
          "/var/lib/sharelatex/redis:/data"
        ];
      };
    };
  };
}
