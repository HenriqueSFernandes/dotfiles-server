{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./services
  ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "ricky" ];
  };
  services.logrotate.checkConfig = false;
  environment.shellAliases = { nix-switch = "sudo nixos-rebuild switch --flake ~/dotfiles#rickycontabo"; };

  users.users.ricky = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAp+Xr3ZdBOalro1lk0/46ufr77Jc4Oh9w83w4H23OC6 ricky@ricky-laptop'' ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking = {
    hostName = "rickycontabo";
    domain = "";
    useDHCP = false;
    interfaces.ens18.ipv4.addresses = [{
      address = "194.242.57.139";
      prefixLength = 24;
    }];
    defaultGateway = "194.242.57.1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    firewall.allowedTCPPorts = [ 5000 ];
  };

  services.openssh.enable = true;
  system.stateVersion = "23.11";
  services = {
    tailscale.enable = true;
  };

}
