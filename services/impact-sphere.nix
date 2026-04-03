{ ... }:
{
  virtualisation.arion.projects = {
    impact-sphere-site.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere-site:c98dc8f126f02a2cf11291a15604718f09cabe0c";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8084:3000" ];
        };
      };
    };
    impact-sphere-dash.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere-dash:b14ae20147d22d46ecbaf68c5dc10cc3eee2c5e8";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8085:3000" ];
        };
      };
    };
  };
}
