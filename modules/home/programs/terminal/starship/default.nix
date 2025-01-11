{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.starship;
  catppuccinCfg = config.${namespace}.theme.catppuccin;
in {
  options.${namespace}.programs.terminal.starship = {
    enable = mkBoolOpt false "Whether enable to Starship.";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;

      enableBashIntegration = true;

      settings = {
        format = lib.concatStrings [
          "[](peach)"
          "$os"
          "$username"
          "[](bg:yellow fg:peach)"
          "$directory"
          "[](bg:green fg:yellow)"
          "$git_branch"
          "$git_status"
          "[](bg:sky fg:green)"
          "$nix_shell"
          "$golang"
          "$php"
          "[](bg:surface0 fg:sky)"
          "$status"
          "$cmd_duration"
          "[](fg:surface0)"
          "$character"
        ];

        add_newline = true;

        palette = mkDefault "default";
        palettes.default = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };

        os = {
          disabled = false;
          style = "bg:peach bold fg:surface2";
          symbols = {
            NixOS = " ";
          };
        };

        username = {
          show_always = false;
          style_user = "bg:orange fg:surface2";
          style_root = "bg:orange fg:red";
          format = "[ $user ]($style)";
        };

        directory = {
          style = "bg:yellow bold fg:surface2";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            Downloads = " ";
            Projects = "󰲋 ";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol $branch ](bold fg:surface2 bg:green)]($style)";
        };

        git_status = {
          style = "bg:green bold fg:surface2";
          format = "[$all_status$ahead_behind]($style)";
        };

        status = {
          disabled = false;
          style = "bg:surface0 fg:text";
          format = "[([$maybe_int]($style fg:red))([$common_meaning]($style fg:peach))([$signal_name]($style fg:yellow))]($style)";
        };

        cmd_duration = {
          format = "[ 󰔛 $duration ]($style)";
          disabled = false;
          style = "bg:surface0 fg:text";
          show_notifications = false;
          min_time_to_notify = 60000;
        };

        line_break = {
          disabled = true;
        };

        character = {
          disabled = false;
          format = " ";
        };

        nix_shell = {
          format = "[ via nix $name ]($style)";
          style = "bg:sky bold fg:surface2";
        };

        golang = {
          symbol = "";
          format = "[$symbol ($version )]($style)";
          style = "bg:sky bold fg:surface2";
        };

        php = {
          symbol = "";
          format = "[$symbol ($version )]($style)";
          style = "bg:sky bold fg:surface2";
        };
      };
    };

    catppuccin.starship = mkIf catppuccinCfg.enable {
      enable = true;
      flavor = catppuccinCfg.flavor;
    };
  };
}
