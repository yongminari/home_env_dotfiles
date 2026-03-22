{
  description = "Home Manager configuration for yongminari";

  inputs = {
    # Nixpkgs (Unstable - 최신 패키지)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager (Master - Nixpkgs 버전과 맞춤)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # adi1090x Rofi Themes (Flake input으로 관리)
    rofi-themes = {
      url = "github:adi1090x/rofi";
      flake = false;
    };

    # Catppuccin Hyprlock Themes (공식 브랜드 테마)
    hyprlock-themes = {
      url = "github:catppuccin/hyprlock";
      flake = false;
    };

    # Catppuccin Waybar Themes (전 세계적으로 가장 유명한 바 테마)
    waybar-themes = {
      url = "github:catppuccin/waybar";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, rofi-themes, hyprlock-themes, waybar-themes, ... }@inputs:
    let
      mkConfig = system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs; }; # 이 부분이 핵심입니다.
        modules = [ 
          ./nix/home.nix
        ];
      };

    in {
      homeConfigurations = {
        # 1. Native Linux & WSL (Unified x86_64)
        "yongminari-x86-linux"   = mkConfig "x86_64-linux";
        # 2. Native Linux & WSL (Unified aarch64)
        "yongminari-aarch-linux" = mkConfig "aarch64-linux";
        # 3. Apple Silicon Mac (aarch64-darwin)
        "yongminari-aarch-mac"   = mkConfig "aarch64-darwin";

        # [기존 호환성] "yongminari"로 실행 시 x86_64-linux를 기본으로 유지
        "yongminari"             = mkConfig "x86_64-linux";
      };
    };
}
