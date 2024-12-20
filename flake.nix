{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.agenix.inputs.darwin.follows = "";
  };

  outputs = {
    nixpkgs,
    disko,
    agenix,
    ...
  }@inputs: {
    # firstvds
    # nixos-rebuild switch --flake .#procyon20 --target-host root@procyon20 --fast
    nixosConfigurations.procyon20 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./disko-vda.nix
        disko.nixosModules.disko
        agenix.nixosModules.default
        ./hosts/procyon20.nix
      ];
      specialArgs.inputs = inputs;
    };
    # nix run github:nix-community/nixos-anywhere -- --flake .#installer root@procyon20
    nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./hosts/installer.nix
      ];
    };
  };
}
