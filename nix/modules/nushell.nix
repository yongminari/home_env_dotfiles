{ config, pkgs, lib, ... }:

{
  programs.nushell = {
    enable = true;
    
    # 1. 환경 변수 설정
    envFile.text = ''
      $env.ENV_CONVERSIONS = {
        "PATH": {
          from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
          to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
      }

      # [Environment Detection]
      let is_ssh = (not ($env | get -o SSH_CLIENT | is-empty)) or (not ($env | get -o SSH_TTY | is-empty)) or (not ($env | get -o SSH_CONNECTION | is-empty))
      let is_docker = ("/.dockerenv" | path exists) or (if ("/proc/1/cgroup" | path exists) { (open /proc/1/cgroup | str contains "docker") } else { false })

      # [Starship 설정 연동]
      if ($is_ssh or $is_docker) {
        $env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship-ssh.toml")
      }
    '';

    # 2. 메인 설정
    configFile.text = ''
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

      # [Zellij Wrapper]
      let is_ssh = (not ($env | get -o SSH_CLIENT | is-empty)) or (not ($env | get -o SSH_TTY | is-empty)) or (not ($env | get -o SSH_CONNECTION | is-empty))
      let is_docker = ("/.dockerenv" | path exists) or (if ("/proc/1/cgroup" | path exists) { (open /proc/1/cgroup | str contains "docker") } else { false })
      
      if ($is_ssh or $is_docker) {
        alias zellij = zellij --config ($env.HOME | path join ".config" "zellij" "remote.kdl")
      }
    '';

    # (공통 에일리어스는 home.nix에서 처리됨)
    # Note: Nushell의 장점(Structured Data, Tables)을 극대화하기 위해 
    # Bash/Zsh의 시각용 에일리어스(eza, bat)는 여기서 제외하고 native 명령어를 사용합니다.
    shellAliases = {
      # Navigation & View
      la = "ls -a";
      ll = "ls -a";
      lt = "eza --tree --level=2 --icons --git"; # 트리는 시각적 효과를 위해 eza 유지
      o  = "open"; # 파일을 테이블 데이터로 열기 (JSON, YAML, CSV 등)
      
      # Short Shortcuts
      g  = "git";
      v  = "nvim";
    };
  };
}
