{ ... }:
{
  virtualisation.arion.projects = {
    impact-sphere.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere:341c1753689868403518d3c0103d43bae659b3de";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8084:3000" ];
        };
      };
    };
  };
}
