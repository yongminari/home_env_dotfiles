{
  description = "Home Manager configuration for yongminari";

  inputs = {
    # Nixpkgs (Unstable 채널 사용 - 최신 패키지)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager (Master 브랜치)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux"; # 사용하는 시스템 아키텍처 (Intel/AMD)
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        yongminari = home-manager.lib.homeManagerConfiguration {
          # [Fix] system 변수 대신 pkgs를 직접 전달하여 경고 해결
          inherit pkgs;

          # 모듈 경로 지정
          modules = [ ./nix/home.nix ];
        };
      };
    };
}
