{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkForce getExe' types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt enabled;

  cfg = config.${namespace}.programs.terminal.git;
  aliases = import ./aliases.nix;
  ignores = import ./ignores.nix;
in {
  options.${namespace}.programs.terminal.git = with types; {
    enable = mkBoolOpt false "Whether enable to GIT.";
    sign = {
      enableDefault = mkBoolOpt true "Whether to sign commits by default.";
      key = mkOpt str "${config.home.homeDirectory}/.ssh/id_ed25519" "The key to sign commits.";
    };
    userName = mkOpt str "${config.home.user.name}" "The name to configure git with.";
    userEmail = mkOpt str "${config.home.user.name}" "The email to configure git with.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git-crypt
      git-filter-repo
      git-lfs
      gitflow
      gitleaks
      gitlint
    ];

    programs = {
      git = {
        enable = true;

        inherit (cfg) userName userEmail;
        inherit (aliases) aliases;
        inherit (ignores) ignores;

        delta = {
          enable = true;

          options = {
            features = mkForce "decorations side-by-side navigate";
            dark = true;
            line-numbers = true;
            navigate = true;
            syde-by-side = true;
          };
        };

        extraConfig = {
          credential = {
            helper = getExe' config.programs.git.package "git-credential-libsecret";
            useHttpPath = true;
          };

          fetch.prune = true;
          gpg.format = "ssh";

          init.defaultBranch = "master";

          lfs = enabled;

          push = {
            autoSetupRemote = true;
            default = "current";
          };

          pull.rebase = true;

          rebase.autoStash = true;

          safe.directory = [
            "~/.${namespace}"
            "/etc/nixos"
          ];

          signing = {
            signByDefault = cfg.sign.enableDefault;
            key = cfg.sign.key;
          };
        };
      };

      gh = {
        enable = true;

        extensions = with pkgs; [
          gh-dash
          gh-eco
          gh-cal
          gh-poi
        ];

        gitCredentialHelper = {
          enable = true;
          hosts = [
            "https://github.com"
            "https://gist.github.com"
          ];
        };
      };
    };

    home.shellAliases = aliases.shell;
  };
}
