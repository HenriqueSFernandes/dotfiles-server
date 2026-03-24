{ ... }:
{
  services.comin = {
    enable = true;
    remotes = [{
      name = "origin";
      url = "https://github.com/henriqueSFernandes/dotfiles-server";
      branches.main.name = "main";
      poller.period = 20;
    }];
  };
}
