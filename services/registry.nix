{ ... }:
{
  age.secrets.registry-htpasswd = {
    file = ../secrets/registry-htpasswd.age;
    path = "/run/agenix/registry-htpasswd";
    owner = "root";
    mode = "0444";
  };

  virtualisation.arion.projects = {
    registry.settings = {
      services = {
        registry-server.service = {
          image = "registry:2";
          restart = "always";
          environment = {
            REGISTRY_STORAGE_DELETE_ENABLED = "true";
            REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY = "/var/lib/registry";
            REGISTRY_AUTH = "htpasswd";
            REGISTRY_AUTH_HTPASSWD_REALM = "Registry Realm";
            REGISTRY_AUTH_HTPASSWD_PATH = "/auth/htpasswd";
          };
          volumes = [
            "/var/lib/registry:/var/lib/registry"
            "/run/agenix/registry-htpasswd:/auth/htpasswd:ro"
          ];
        };

        registry-ui.service = {
          image = "joxit/docker-registry-ui:latest";
          restart = "always";
          ports = [ "127.0.0.1:8080:80" ];
          environment = {
            SINGLE_REGISTRY = "true";
            REGISTRY_TITLE = "henriquesf.me registry";
            DELETE_IMAGES = "true";
            SHOW_CONTENT_DIGEST = "true";
            SHOW_CATALOG_NB_TAGS = "true";
            NGINX_PROXY_PASS_URL = "http://registry-server:5000";
            NGINX_RESOLVER = "127.0.0.11";
            REGISTRY_SECURED = "true";
          };
          depends_on = [ "registry-server" ];
        };
      };
    };
  };

}
