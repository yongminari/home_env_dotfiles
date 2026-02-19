{
  description = "Home Manager configuration for yongminari";

  inputs = {
    # Nixpkgs (Unstable 채널 - 현재 26.05)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager (Master 브랜치 - Nixpkgs Unstable과 버전을 맞춤)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        # [Profile 1] Native Linux용 (Ghostty 포함)
        "yongminari" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/home.nix ];
          extraSpecialArgs = { isWSL = false; };
        };

        # [Profile 2] WSL용 (Ghostty 제외)
        "yongminari-wsl" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/home.nix ];
          extraSpecialArgs = { isWSL = true; };
        };
      };
    };
}
