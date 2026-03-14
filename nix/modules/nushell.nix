{ config, pkgs, lib, ... }:

{
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

      # SSH/Docker 접속 감지 및 Starship 설정 변경
      let is_ssh = (
        (not ($env | get -o SSH_CLIENT | is-empty)) or 
        (not ($env | get -o SSH_TTY | is-empty)) or 
        (not ($env | get -o SSH_CONNECTION | is-empty))
      )
      
      let is_docker = (
        ("/.dockerenv" | path exists) or
        (if ("/proc/1/cgroup" | path exists) { (open /proc/1/cgroup | str contains "docker") } else { false })
      )

      if ($is_ssh or $is_docker) {
        $env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship-ssh.toml")
      }
    '';

    configFile.text = ''
      # [Carapace Completion Helper]
      let carapace_completer = { |spans|
        carapace $spans.0 nushell ...$spans | from json
      }

      $env.config = {
        show_banner: false
        edit_mode: vi
        render_right_prompt_on_last_line: false 
        
        completions: {
          case_sensitive: false # case-insensitive completion
          quick: true    # set this to false to prevent auto-selecting completions
          partial: true  # set this to false to prevent partial filling of the prompt
          algorithm: "fuzzy" # fuzzy matching
          external: {
            enable: true
            max_results: 100
            completer: $carapace_completer
          }
        }

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

      # [Welcome Message]
      # Nushell interaction: welcome-msg script
      ^welcome-msg

      # [SSH/Remote Zellij Theme Support]
      let is_ssh = (
        (not ($env | get -o SSH_CLIENT | is-empty)) or 
        (not ($env | get -o SSH_TTY | is-empty)) or 
        (not ($env | get -o SSH_CONNECTION | is-empty))
      )
      
      let is_docker = (
        ("/.dockerenv" | path exists) or
        (if ("/proc/1/cgroup" | path exists) { (open /proc/1/cgroup | str contains "docker") } else { false })
      )
      
      if ($is_ssh or $is_docker) {
        alias zellij = zellij --config ($env.HOME | path join ".config" "zellij" "remote.kdl")
      }
    '';

    shellAliases = {
      hypr_shortcuts = "printf \"\n  (ansi blue_bold)🪟 Hyprland & Wofi Shortcuts(ansi reset)\n\n  (ansi green_bold)Super + Enter(ansi reset)       Launch Ghostty\n  (ansi green_bold)Super + R(ansi reset)           Launch Wofi (Runner)\n  (ansi green_bold)Super + W(ansi reset)           Work Automation (Chrome)\n  (ansi green_bold)Super + F(ansi reset)           Toggle Fullscreen\n  (ansi green_bold)Super + hjkl(ansi reset)        Move Focus (Window/Monitor)\n  (ansi green_bold)Super + , / .(ansi reset)       Cycle Monitor Focus\n  (ansi green_bold)Super + Shift + hjkl(ansi reset) Move Window Position\n  (ansi green_bold)Super + Alt + hjkl(ansi reset)   Resize Window\n  (ansi green_bold)Super + S / Shift+S(ansi reset)  Scratchpad Toggle / Move window\n  (ansi green_bold)Super + Space(ansi reset)       IBus Language Toggle\n  (ansi green_bold)Super + Q(ansi reset)           Kill Active Window\n  (ansi green_bold)Super + M(ansi reset)           Exit Hyprland\n  (ansi green_bold)Super + V(ansi reset)           Toggle Floating\n  (ansi green_bold)Super + 1~0(ansi reset)         Switch Workspace (1-10)\n  (ansi green_bold)Super + Shift + 1~0(ansi reset) Move to Workspace\n  (ansi green_bold)Super + Scroll(ansi reset)      Switch Workspaces\n  (ansi green_bold)Super + Mouse L/R(ansi reset)   Drag to Move / Resize Window\n\n\" | lolcat";
    };
  };
}
