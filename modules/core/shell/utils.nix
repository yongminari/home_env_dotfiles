{ config, pkgs, lib, ... }:

{
  home.shellAliases = {
    ls = "eza";
    ll = "eza -l --icons --git -a";
    lt = "eza --tree --level=2 --long --icons --git";
    cat = "bat";
    # Ghostty를 유지하면서 SSH 호환성을 챙기는 가장 현대적인 방법
    gssh = "ghostty +ssh";
    # ROS 2 & Qt Wayland compatibility fixes
    rviz2 = "env QT_QPA_PLATFORM=xcb rviz2";
    wireshark = "env QT_QPA_PLATFORM=xcb wireshark";

    # Common
    g = "git";
    v = "nvim";
    vi = "nvim";
    vim = "nvim";
    zj = "zellij";
    tocb = "wl-copy";
  };

  # 공통 CLI 패키지
  home.packages = with pkgs; [
    htop
    fastfetch
    lolcat
    lsb-release
    glow      # Markdown preview
    ouch      # Archive preview/manager
    mediainfo # Media metadata
    exiftool  # Image/Media metadata
    wl-clipboard # System clipboard integration (Wayland)
  ];

  home.file.".config/starship-ssh.toml".source = ./starship-ssh.toml;
  home.file.".config/starship-docker.toml".source = ./starship-docker.toml;

  # Starship 프롬프트
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = lib.importTOML ./starship.toml;
  };

  # Eza (ls 보조)
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    icons = "auto";
    git = true;
  };

  # Zoxide (cd 대체)
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    options = [ "--cmd cd" ];
  };

  # Bat (cat 대체)
  programs.bat = {
    enable = true;
    config = { theme = "OneHalfDark"; };
  };

  # FZF (Fuzzy Finder - 기본 설정으로 복구)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  # Yazi (Terminal File Manager)
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        show_hidden = false;
        sort_by = "alphabetical";
        linemode = "githead";
      };
      status = {
        left = [
          { name = "hovered"; collect = false; }
          { name = "count"; collect = false; }
          { name = "githead"; collect = false; }
        ];
        right = [
          { name = "cursor"; collect = false; }
          { name = "sort"; collect = false; }
          { name = "permissions"; collect = false; }
        ];
      };
      opener = {
        edit = [
          { run = ''${pkgs.neovim}/bin/nvim "$@"''; block = true; }
        ];
      };
      preview = {
        rules = [
          { mime = "{image,audio,video}/*"; run = "plugin mediainfo"; }
          { mime = "application/x-subrip"; run = "plugin mediainfo"; }
          { mime = "text/markdown"; run = "plugin glow"; }
          { mime = "application/{zip,rar,7z*,tar*,gzip,xz,zstd,bzip*}"; run = "plugin ouch"; }
        ];
      };
    };

    keymap = {
      manager.prepend_keymap = [
        { on = [ "l" ]; run = "plugin smart-enter"; desc = "Enter directory or open file"; }
        { on = [ "<Enter>" ]; run = "plugin smart-enter"; desc = "Enter directory or open file"; }
        { on = [ "c" "m" ]; run = "plugin chmod"; desc = "Chmod"; }
        { on = [ "m" ]; run = "plugin relative-motions"; desc = "Relative motions"; }
        { on = [ "i" ]; run = "plugin easyjump"; desc = "Easyjump"; }
      ];
      cmp.prepend_keymap = [
        { on = [ "<Tab>" ]; run = "close --submit"; desc = "현재 선택된 제안으로 완성"; }
        { on = [ "<C-n>" ]; run = "arrow 1";        desc = "다음 제안으로 이동"; }
        { on = [ "<C-p>" ]; run = "arrow -1";       desc = "이전 제안으로 이동"; }
      ];
    };

    initLua = ''
      require("githead"):setup()
      require("shell-completion"):setup()
      require("full-border"):setup()
      require("relative-motions"):setup()
    '';

    plugins = {
      githead = pkgs.fetchFromGitHub {
        owner = "llanosrocas";
        repo = "githead.yazi";
        rev = "main";
        sha256 = "sha256-o2EnQYOxp5bWn0eLn0sCUXcbtu6tbO9pdUdoquFCTVw=";
      };
      shell-completion = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "main";
        sha256 = "sha256-kcZGQB8Dfon8OipuAcNnCeRgTp/S0mQokADkuvEG4Lc=";
      } + "/shell-completion.yazi";
      smart-enter = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "main";
        sha256 = "sha256-kcZGQB8Dfon8OipuAcNnCeRgTp/S0mQokADkuvEG4Lc=";
      } + "/smart-enter.yazi";
      chmod = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "main";
        sha256 = "sha256-kcZGQB8Dfon8OipuAcNnCeRgTp/S0mQokADkuvEG4Lc=";
      } + "/chmod.yazi";
      full-border = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "main";
        sha256 = "sha256-kcZGQB8Dfon8OipuAcNnCeRgTp/S0mQokADkuvEG4Lc=";
      } + "/full-border.yazi";
      relative-motions = pkgs.fetchFromGitHub {
        owner = "dedukun";
        repo = "relative-motions.yazi";
        rev = "main";
        sha256 = "1kk8my0apb4ahp60krqalccp63crggh8jkvi0zdhsf26bkyv2bpn";
      };
      glow = pkgs.fetchFromGitHub {
        owner = "Reledia";
        repo = "glow.yazi";
        rev = "main";
        sha256 = "139vrns3jwaymqi2sf0fpmkn2vsw261z3195cvi4lk6bvyxbydcv";
      };
      ouch = pkgs.fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "main";
        sha256 = "0byhj3rhibky5havkv9a4c2cpfmp0czl1ann71bxh3qs7mn7z36p";
      };
      easyjump = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "easyjump.yazi";
        rev = "master";
        sha256 = "0gbzzz4j0b70lsbyrv1fp30w0w5hpcrr93lirklj4irrwrspd49a";
      };
      mediainfo = pkgs.fetchFromGitHub {
        owner = "boydaihungst";
        repo = "mediainfo.yazi";
        rev = "master";
        sha256 = "0k66zsa6i5hqd08qdg027697bk32vz7gkahmh1c24pisdlaaph9x";
      };
    };
  };

  # Carapace (Multi-shell completion)
  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  # Atuin (Magical Shell History)
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };
}
