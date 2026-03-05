{ config, pkgs, lib, ... }:

{
  home.file.".config/starship-ssh.toml".source = ./starship-ssh.toml;

  # 1. Starship 프롬프트 (공통 활성화)
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = lib.importTOML ./starship.toml;
  };

  # 2. Eza (ls 보조)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = false; 
    icons = "auto";
    git = true;
  };

  # 3. Zoxide (cd 대체)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    options = [ "--cmd cd" ];
  };

  # 4. Bat (cat 대체)
  programs.bat = {
    enable = true;
    config = { theme = "Dracula"; };
  };

  # 5. FZF (Fuzzy Finder)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # 6. Direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  # ---------------------------------------------------------
  # 7. Zsh 설정 (메인 쉘)
  # ---------------------------------------------------------
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
      if [[ "$TERM" == "xterm-ghostty" ]] && ! command -v infocmp &>/dev/null; then
        export TERM=xterm-256color
      elif [[ "$TERM" == "xterm-ghostty" ]] && ! infocmp xterm-ghostty &>/dev/null; then
        export TERM=xterm-256color
      fi
    '';

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
          if [[ -f "/usr/share/ghostty/shell-integration/zsh/ghostty-integration" ]]; then
            source "/usr/share/ghostty/shell-integration/zsh/ghostty-integration"
          elif [[ -f "$HOME/.nix-profile/share/ghostty/shell-integration/zsh/ghostty-integration" ]]; then
            source "$HOME/.nix-profile/share/ghostty/shell-integration/zsh/ghostty-integration"
          fi
        fi

        if [[ "$TERM" == "zellij" ]]; then
          export TERM=xterm-256color
          export ZELLIJ_SKIP_AUTOSTART=true
        fi

        function is_ssh() {
          [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] || \
          [[ "$(ps -o comm= -p $PPID 2>/dev/null)" == "sshd" ]]
        }

        if is_ssh; then
          export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
        fi
      '')
      ''
        if command -v fnm &>/dev/null; then
          eval "$(fnm env --use-on-cd --shell zsh)"
        fi

        export PATH=$HOME/.local/bin:$PATH

        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey '^[OA' history-substring-search-up
        bindkey '^[OB' history-substring-search-down

        if command -v pyenv &>/dev/null; then
          eval "$(pyenv init -)"
          eval "$(pyenv virtualenv-init -)"
        fi

        if [[ -n "$ZELLIJ" ]] || is_ssh; then
          printf "\e[?7l"
          local os_name="Linux"
          if [[ -f /etc/os-release ]]; then
            os_name=$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)
          fi

          {
            if is_ssh; then
              cat << 'EOF'
 ███                         █████                         █████     
░░░███                      ░░███                         ░░███      
  ░░░███          █████ ████ ░███████       █████   █████  ░███████  
    ░░░███       ░░███ ░███  ░███░░███     ███░░   ███░░   ░███░░███ 
     ███░         ░███ ░███  ░███ ░███    ░░█████ ░░█████  ░███ ░███ 
   ███░           ░███ ░███  ░███ ░███     ░░░░███ ░░░░███ ░███ ░███ 
 ███░             ░░███████  ████ █████    ██████  ██████  ████ █████
░░░       ██████   ░░░░░███ ░░░░ ░░░░░    ░░░░░░  ░░░░░░  ░░░░ ░░░░░ 
         ░░░░░░    ███ ░███                                          
                  ░░██████                                           
                   ░░░░░░
EOF
            else
              cat << 'EOF'
 ███                 █████ █████                              ██████   ██████  ███                                  ███ 
░░░███              ░░███ ░░███                              ░░██████ ██████  ░░░                                  ░░░  
  ░░░███             ░░███ ███    ██████  ████████    ███████ ░███░█████░███  ████  ████████    ██████   ████████  ████ 
    ░░░███            ░░█████    ███░░███░░███░░███  ███░░███ ░███░░███ ░███ ░░███ ░░███░░███  ░░░░░███ ░░███░░███░░███ 
     ███░              ░░███    ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░░░  ░███  ░███  ░███ ░███   ███████  ░███ ░░░  ░███ 
   ███░                 ░███    ░███ ░███ ░███ ░███ ░███ ░███ ░███      ░███  ░███  ░███ ░███  ███░░███  ░███      ░███ 
 ███░      █████████    █████   ░░██████  ████ █████░░███████ █████     █████ █████ ████ █████░░████████ █████     █████
░░░       ░░░░░░░░░    ░░░░░     ░░░░░░  ░░░░ ░░░░░  ░░░░░███░░░░░     ░░░░░ ░░░░░ ░░░░ ░░░░░  ░░░░░░░░ ░░░░░     ░░░░░ 
                                                     ███ ░███                                                           
                                                    ░░██████                                                            
                                                     ░░░░░░                                                             
EOF
            fi

            echo " $os_name"
            echo " HOST      : $(uname -n)"
            echo " SESSION   : Zellij (Stable Zsh Workspace)"
            echo " Kernel    : $(uname -r)"
            echo " Date      : $(date +'%Y-%m-%d %H:%M:%S')"
            echo " Shell     : Zsh $(zsh --version | awk '{print $2}')"
            echo " Who       : $(whoami)"
          } | lolcat

          echo "\nWelcome back to \x1b[94mZsh\x1b[94m, \x1b[1m$USER!\x1b[0m"
          printf "\e[?7h"
        fi      

        function is_vscode() {
          [[ -n "$VSCODE_IPC_HOOK_CLI" || -n "$VSCODE_PID" || "$TERM_PROGRAM" == "vscode" ]]
        }
        if [[ $- == *i* ]] && [[ -z "$ZELLIJ" ]] && [[ -z "$ZELLIJ_SKIP_AUTOSTART" ]] && ! is_vscode && ! is_ssh; then
          exec zellij
        fi
      ''
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "virtualenv" "history-substring-search" ];
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --long --icons --git";
      cat = "bat";
      tocb = "xclip -selection clipboard";
      hms = "home-manager switch --flake ~/home_env_dotfiles/#yongminari";
      hmsx = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-x86-linux";
      hmsa = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-linux";
      hmsm = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-mac";
      vi = "nvim";
      vim = "nvim";
      zj = "zellij";
    };
  };

  # ---------------------------------------------------------
  # 8. Nushell 설정 (보조/실험용 쉘)
  # ---------------------------------------------------------
  programs.nushell = {
    enable = true;
    
    envFile.text = ''
      $env.ENV_CONVERSIONS = {
        "PATH": {
          from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
          to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
        "PYTHONPATH": {
          from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
          to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
        "LD_LIBRARY_PATH": {
          from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
          to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
      }

      # SSH 접속 감지 및 Starship 설정 변경
      let is_ssh = (
        ($env.SSH_CLIENT? != null) or 
        ($env.SSH_TTY? != null) or 
        ($env.SSH_CONNECTION? != null)
      )

      if $is_ssh {
        $env.STARSHIP_CONFIG = $"($env.HOME)/.config/starship-ssh.toml"
      }
    '';

    configFile.text = ''
      $env.config = {
        show_banner: false
        edit_mode: vi
        # 커서 위치 응답 누수 방지를 위해 렌더링 방식 조정
        render_right_prompt_on_last_line: true 
        
        keybindings: [
          {
            name: fzf_history
            modifier: control
            keycode: char_r
            mode: [emacs, vi_insert, vi_normal]
            event: [ { send: executehostcommand, cmd: "commandline edit --insert (history | get command | reverse | uniq | str join (char nl) | fzf --layout=reverse --height=40% --query (commandline) | decode utf-8 | str trim)" } ]
          }
          {
            name: fzf_files
            modifier: control
            keycode: char_t
            mode: [emacs, vi_insert, vi_normal]
            event: [ { send: executehostcommand, cmd: "commandline edit --insert (fzf --layout=reverse --height=40% | decode utf-8 | str trim)" } ]
          }
        ]
      }

      # [ROS2 Bridge]
      def --env source-ros [distro: string = "humble"] {
        let setup_path = $"/opt/ros/($distro)/setup.bash"
        if ($setup_path | path exists) {
          print $"Sourcing ROS 2 ($distro)..."
          let env_vars = (bash -c $"source ($setup_path) && env" | lines | where { $in =~ "=" } | split column "=" name value)
          for row in $env_vars {
            if ($row.name | str contains "ROS") or ($row.name in ["PATH", "PYTHONPATH", "LD_LIBRARY_PATH", "AMENT_PREFIX_PATH", "CMAKE_PREFIX_PATH"]) {
              load-env { ($row.name): $row.value }
            }
          }
          print $"(ansi green_bold)ROS 2 ($distro) environment loaded.(ansi reset)"
        }
      }

      def show_welcome [] {
        let is_ssh = (($env.SSH_CLIENT? != null) or ($env.SSH_TTY? != null) or ($env.SSH_CONNECTION? != null))
        if ($env.ZELLIJ? != null) or $is_ssh {
          let host_info = (try { sys host } catch { {hostname: "unknown", kernel_version: "unknown"} })
          # print 시 이스케이프 문자 최소화
          print $"(ansi light_cyan)Welcome to Nushell Experimental Workspace! \(Sub-shell Mode\)(ansi reset)"
          print $"(ansi yellow_bold) HOST      : ($host_info.hostname)(ansi reset)"
          print $"(ansi green_bold) SESSION   : Nushell Trial(ansi reset)"
          print $"(ansi cyan_bold) Shell     : Nushell (version | get version)(ansi reset)"
          print ""
          print "Type 'exit' to return to Zsh."
        }
      }
      
      # 동기화를 위해 짧은 지연 후 실행하거나 필요할 때만 호출 가능
      show_welcome
    '';

    shellAliases = {
      ll = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --long --icons --git";
      hms = "home-manager switch --flake ~/home_env_dotfiles/#yongminari";
      hmsx = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-x86-linux";
      hmsa = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-linux";
      hmsm = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-mac";
    };
  };

  # Bash는 기본 호환성을 위해 유지
  programs.bash = {
    enable = true;
    shellAliases = {
      hms = "home-manager switch --flake ~/home_env_dotfiles/#yongminari";
      hmsx = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-x86-linux";
      hmsa = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-linux";
      hmsm = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-mac";
    };
    initExtra = ''
      # SSH 접속 여부 확인 함수
      function is_ssh() {
        [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] || \
        [[ "$(ps -o comm= -p $PPID 2>/dev/null)" == "sshd" ]]
      }

      # SSH 접속 시 Starship 전용 설정 적용
      if is_ssh; then
        export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
      fi
    '';
  };
}
