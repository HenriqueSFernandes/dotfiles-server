{ ... }:
{
  virtualisation.arion.projects = {
    impact-sphere.settings = {
      services = {
        website.service = {
          image = "registry.henriquesf.me/impact-sphere:dc72a5cb7ba23fb9cc22bc299408c015def60148";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8084:3000" ];
        };
      };
    };
  };
}
