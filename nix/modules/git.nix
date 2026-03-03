{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    # 'settings'가 아니라 아래와 같이 직접 지정해야 합니다.
    userName = "yongminari";
    userEmail = "easyid21c@gmail.com";

    # 나머지 설정들 (init, core 등)은 여기에 넣습니다.
    extraConfig = {
      init.defaultBranch = "main";
      core.ignorecase = true; # 아까 논의한 윈도우-리눅스 혼용 설정
    };
  };
}
