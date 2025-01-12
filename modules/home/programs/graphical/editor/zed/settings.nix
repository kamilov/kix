{
  config,
  lib,
  pkgs,
  osConfig,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkMerge;

  cfg = config.${namespace}.programs.graphical.editor.zed;
  ollamaEnabled = osConfig.services.ollama.enable;
  languages = import ./languages.nix pkgs;
in {
  config.programs.zed-editor = mkIf cfg.enable {
    inherit (languages) extraPackages extensions;

    userSettings = mkMerge [
      {inherit (languages) lsp languages;}

      {
        auto_update = false;
        autosave = "off";
        restore_on_startup = "last_workspace";
        base_keymap = "JetBrains";
        confirm_quit = false;
        load_direnv = "direct";

        # UI settings
        buffer_font_family = cfg.fontFamily;
        buffer_font_size = 14;
        ui_font_size = 16;

        scrollbar = {
          show = "auto";
          cursors = true;
          git_diff = true;
        };

        tabs = {
          git_status = true;
        };

        toolbar = {
          breadcrumbs = false;
          quick_actions = false;
        };

        chat_pannel = {button = false;};
        collaboration_panel = {button = false;};
        notification_panel = {button = false;};

        terminal = {
          font_family = cfg.fontFamily;
          font_size = 14;
        };

        show_whitespaces = "selection";

        # misc
        features = {inline_completion_provider = "none";};
        format_on_save = "off";

        indent_guides = {
          enabled = true;
          coloring = "fixed";
        };

        inlay_hints = {enabled = true;};
      }

      (mkIf ollamaEnabled {
        assistant = {
          default_model = {
            provider = "ollama";
            model = "llama3.3:latest";
          };
          version = 2;
          provider = null;
        };
        language_models.ollama.api_url = "http://localhost:11434";
      })
    ];
  };
}
