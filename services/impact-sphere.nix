{ ... }:
{
  virtualisation.arion.projects = {
    impact-sphere.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere:9b98b19a6339a03a486423c423b33ac77be876a0";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8084:3000" ];
        };
      };
    };
  };
}
