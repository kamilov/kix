{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.shell.bash;
in {
  options.${namespace}.programs.terminal.shell.bash = {
    enable = mkBoolOpt false "Whether enable to Bash shell.";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      historyControl = ["ignoredups"];
      historyIgnore = ["ls"];

      initExtra = ''
        function settitle {
          tmux rename-window "$1"
        }

        # Set terminal title during ssh session
        function ssh {
          settitle "$*"
          command ssh "$@"
          settitle "bash"
        }
      '';

      profileExtra = ''
        [[ -f ~/.local/.profile ]] && . ~/.local/.profile
      '';
    };
  };
}
