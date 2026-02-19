{
  description = "Home Manager configuration for yongminari";

  inputs = {
    # Nixpkgs (Unstable 채널)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager (25.11 릴리스 브랜치)
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
          # Native 환경임을 명시
          extraSpecialArgs = { isWSL = false; };
        };

        # [Profile 2] WSL용 (Ghostty 제외)
        "yongminari-wsl" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/home.nix ];
          # WSL 환경임을 명시
          extraSpecialArgs = { isWSL = true; };
        };
      };
    };
}
