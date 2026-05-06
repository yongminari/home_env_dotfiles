{ config, lib, ... }:

{
  # 이 PC는 NVIDIA GPU를 사용함 (Hyprland 성능 최적화 활성화)
  options.myHardware.nvidia.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable NVIDIA specific configurations for Hyprland";
  };

  config.myHardware.nvidia.enable = true;
}
