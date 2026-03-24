{ ... }:
{
  virtualisation.arion.projects = {
    impact-sphere.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere:457a7ece8980f934c1b6cc74f2a26c04bfe6286b";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8084:3000" ];
        };
      };
    };
  };
}
