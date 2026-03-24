{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./services
  ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "ricky" ];
    substituters = [
      "https://cache.nixos.org/" 
      "https://impact-sphere-cache.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "ricky-server-cache.cachix.org-1:5aK6kpi4p4PxJ2//bwsSO4b9lL97GqE25bCX4vJd6zw="
    ];
  };
  services.logrotate.checkConfig = false;
  environment.shellAliases = { nix-switch = "sudo nixos-rebuild switch --flake ~/dotfiles#rickycontabo"; };

  users.users.ricky = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    # Laptop Nix
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAp+Xr3ZdBOalro1lk0/46ufr77Jc4Oh9w83w4H23OC6 ricky@ricky-laptop''
    # Desktop Windows
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/tr4jHwIAoGqC8NMnEh/h5UVzgrRTatSNgQidtJGjz820Gq4Tu0hNjLvBoQOa6PuJOmI7z34e1wTanrB5cCRBNRLMdHmkSiGKcxBiT3nCKksTGTEDwTkZMiHxI0FhT+yW9JGy8trwFLEC5DI7GvQVj+1L10/+74sbEnx8ZtJI3vsQrzuM84VXfq1Z2bCxhFdn/Iqp5vUbr6WdTDpKSf1Lw2+o/A8LnwYrRbEhp6xSiIuvU+yQ7KYDZKMcpM47s/JB7HI9LYJF6fl3NqVXHfNVTbu9tdYjitl/z2A/5D9BBN19887SgUdRZGJDYk2KecP40BjnOEkmMR+NF4lmp1zpxbY19d9w+ltvu4kUpepBqTzicVCFHDsXEmQ+ns0aZ0qh7nMjSHDX5bpfNgoEl0nIwxqEGJvpvrZAda4XzHg2cajqQ+lLkaUUxKUEUDfcSBz5eC2WZUdjqkSeisnEFCLdWnE0/fTYQ+zyKNjQxowfpKQMhangXXO1/+yGV7HQCy/SZd+zuop67bfdYZzJZSR5dseHMhuKTrIAZynTpXibCS1lk2aqUw8tcGR1Vh3sXxK3DlrIW+FJbYiLkYMe3yDKDFt5P6tJymTlEFcA/3mA4vjvOJ6r4GDCWnDcze90u/lLwe/ljPFIpcosOuhr9ijYOVud8D8npGxGuLxOQpHpuQ== henriquesardofernandes@gmail.com''
    # Desktop Nix
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbtGZQgH5e1S7hu051720S1FZp423tQwH8m7nbFM66+ ricky@ricky-desktop''
  ];

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
