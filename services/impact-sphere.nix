{ ... }:
{
  virtualisation.arion.projects = {
    impact-sphere-site.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere-site:22f6a73b0199fa1dcd53d57c412ee45576a4f185";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8084:3000" ];
        };
      };
    };
    impact-sphere-dash.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere-dash:latest";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8085:3000" ];
        };
      };
    };
  };
}
