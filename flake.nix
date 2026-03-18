{
  description = "Contabo Server Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    agenix.url = "github:ryantm/agenix";
    arion.url = "github:hercules-ci/arion";
  };

  outputs = { self, nixpkgs, deploy-rs, ... }@inputs: {
    nixosConfigurations.rickycontabo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
      modules = [
        ./configuration.nix
        inputs.arion.nixosModules.arion
        inputs.agenix.nixosModules.default
      ];
    };
    deploy.nodes.contabo = {
      hostname = "194.242.57.139";

      profiles.system = {
        sshUser = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos
          self.nixosConfigurations.rickycontabo;
      };
    };

    checks = builtins.mapAttrs
      (system: deployLib: deployLib.deployChecks self.deploy)
      deploy-rs.lib;
  };
}
