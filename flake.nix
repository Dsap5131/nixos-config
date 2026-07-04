{
  description = "Framework 16 (AI 300) NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs: {
    nixosConfigurations.fw16 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        
        # Framework 16 AI 300 series (iGPU only, no dGPU module yet). 
        # When you get the NVIDIA module, switch this to:
        #   nixos-hardware.nixosModules.framework-16-amd-ai-300-series-nvidia
        nixos-hardware.nixosModules.framework-16-amd-ai-300-series

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dsapienza = import ./home.nix;
        }
      ];
    };
  };
}
