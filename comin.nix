{ pkgs, ... }:
{
  services.comin = {
    enable = true;
    poller.period = 60;
    remotes = [{
      name = "origin";
      url = "git@github.com:HenriqueSFernandes/dotfiles-server.git";
      auth.ssh = {
        privateKeyPath = "/etc/nixos/comin_ed25519";
      };
    }];
  };

}
