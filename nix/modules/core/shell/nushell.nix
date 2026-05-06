{ config, pkgs, lib, ... }:

{
  programs.nushell = {
    enable = true;
    
    # 1. 환경 변수 및 초기화 (env.nu)
    extraEnv = ''
      # [Environment Detection]
      let is_ssh = (not ($env | get -o SSH_CLIENT | is-empty)) or (not ($env | get -o SSH_TTY | is-empty)) or (not ($env | get -o SSH_CONNECTION | is-empty))
      let is_docker = ("/.dockerenv" | path exists) or (if ("/proc/1/cgroup" | path exists) { (open /proc/1/cgroup | str contains "docker") } else { false })

      # [Starship 설정 연동]
      if ($is_ssh or $is_docker) {
        $env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship-ssh.toml")
      }
    '';

    # 2. 메인 설정 (config.nu)
    extraConfig = ''
      # [Carapace Completion Helper]
      let carapace_completer = { |spans| carapace $spans.0 nushell ...$spans | from json }

      $env.config = {
        show_banner: false
        edit_mode: vi
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
          external: { enable: true, max_results: 100, completer: $carapace_completer }
        }

        # [Keybindings]
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
            event: [ { send: executehostcommand, cmd: "commandline edit --insert (fd --type f --strip-cwd-prefix --hidden --exclude .git | fzf --layout=reverse --height=40% --preview 'bat --color=always --style=numbers --line-range :500 {}' | decode utf-8 | str trim)" } ]
          }
        ]
      }

      # [Welcome Message]
      ^welcome-msg

      # [SSH Wrapper]
      # Ghostty 사용 시 'ghostty +ssh'를 통해 terminfo 자동 주입 시도 (중첩 SSH는 제외)
      def --env ssh [...args] {
        let is_ssh = (not ($env | get -o SSH_CLIENT | is-empty)) or (not ($env | get -o SSH_TTY | is-empty)) or (not ($env | get -o SSH_CONNECTION | is-empty))
        let is_ghostty = ($env.TERM? == "xterm-ghostty") or ($env.TERM_PROGRAM? == "Ghostty")
        if (not $is_ssh) and $is_ghostty {
          ^ghostty +ssh ...$args
        } else {
          with-env { TERM: "xterm-256color", COLORTERM: "truecolor" } {
            ^ssh ...$args
          }
        }
      }

      # [Zellij Wrapper]
      let is_ssh = (not ($env | get -o SSH_CLIENT | is-empty)) or (not ($env | get -o SSH_TTY | is-empty)) or (not ($env | get -o SSH_CONNECTION | is-empty))
      let is_docker = ("/.dockerenv" | path exists) or (if ("/proc/1/cgroup" | path exists) { (open /proc/1/cgroup | str contains "docker") } else { false })
      
      if ($is_ssh or $is_docker) {
        alias zellij = zellij --config ($env.HOME | path join ".config" "zellij" "remote.kdl")
      }
    '';

    # Nushell의 장점을 극대화하기 위해 시각용 에일리어스는 eza/bat 대신 native 명령어를 지향합니다.
    shellAliases = {
      # Navigation & View
      la = "ls -a";
      o  = "open"; # 파일을 테이블 데이터로 열기 (JSON, YAML, CSV 등)
      
      # Short Shortcuts
      g  = "git";
      v  = "nvim";
    };
  };
}
