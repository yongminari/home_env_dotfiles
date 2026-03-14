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
    shellAliases = {
      hypr_shortcuts = "printf \"\n  (ansi blue_bold)🪟 Hyprland & Wofi Shortcuts(ansi reset)\n\n  (ansi green_bold)Super + Enter(ansi reset)       Launch Ghostty\n  (ansi green_bold)Super + R(ansi reset)           Launch Wofi (Runner)\n  (ansi green_bold)Super + W(ansi reset)           Work Automation (Chrome)\n  (ansi green_bold)Super + F(ansi reset)           Toggle Fullscreen\n  (ansi green_bold)Super + hjkl(ansi reset)        Move Focus (Window/Monitor)\n  (ansi green_bold)Super + , / .(ansi reset)       Cycle Monitor Focus\n  (ansi green_bold)Super + Shift + hjkl(ansi reset) Move Window Position\n  (ansi green_bold)Super + Alt + hjkl(ansi reset)   Resize Window\n  (ansi green_bold)Super + S / Shift+S(ansi reset)  Scratchpad Toggle / Move window\n  (ansi green_bold)Super + Space(ansi reset)       IBus Language Toggle\n  (ansi green_bold)Super + Q(ansi reset)           Kill Active Window\n  (ansi green_bold)Super + M(ansi reset)           Exit Hyprland\n  (ansi green_bold)Super + V(ansi reset)           Toggle Floating\n  (ansi green_bold)Super + 1~0(ansi reset)         Switch Workspace (1-10)\n  (ansi green_bold)Super + Shift + 1~0(ansi reset) Move to Workspace\n  (ansi green_bold)Super + Scroll(ansi reset)      Switch Workspaces\n  (ansi green_bold)Super + Mouse L/R(ansi reset)   Drag to Move / Resize Window\n\n\" | lolcat";
    };
  };
}
