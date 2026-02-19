{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = { name = "yongminari"; email = "easyid21c@gmail.com"; };
      init.defaultBranch = "main";
    };
  };
}
