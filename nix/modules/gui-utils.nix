{ config, pkgs, inputs, ... }:

let
  nix-gui-run = pkgs.writeShellScriptBin "nix-gui-run" ''
    # nix-gui-run: Automatically detect GPU and apply correct nixGL wrapper
    if command -v nvidia-smi &>/dev/null; then
      # If Nvidia is detected, try to use nixGLNvidia (if installed)
      if command -v nixGLNvidia &>/dev/null; then
        exec nixGLNvidia "$@"
      else
        # Fallback to nixGLIntel for Mesa compatibility
        exec nixGLIntel "$@"
      fi
    else
      # AMD, Intel, and aarch64 Mesa drivers
      exec nixGLIntel "$@"
    fi
  '';
in
{
  home.packages = [ nix-gui-run ];
}
