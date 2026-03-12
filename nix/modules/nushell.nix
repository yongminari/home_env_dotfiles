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

      # SSH 접속 감지 및 Starship 설정 변경
      let is_ssh = (
        (not ($env | get -o SSH_CLIENT | is-empty)) or 
        (not ($env | get -o SSH_TTY | is-empty)) or 
        (not ($env | get -o SSH_CONNECTION | is-empty))
      )

      if $is_ssh {
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
}
