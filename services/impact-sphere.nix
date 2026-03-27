{ ... }:
{
  virtualisation.arion.projects = {
    impact-sphere.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere:aebe2e6c3cd7f16326372281e980f235b68f64ee";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8084:3000" ];
        };
      };
    };
  };
}
