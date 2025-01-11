{
  config,
  lib,
  pkgs,
  host,
  namespace,
  ...
}: let
  inherit (builtins) filter;
  inherit (lib) mkIf listToAttrs mapAttrsToList flatten nameValuePair types;
  inherit (lib.${namespace}) mkOpt force-attrs;

  xdgCfg = config.${namespace}.xdg;
  mimeMap = {
    browser = [
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
      "x-scheme-handler/chrome"
      "x-www-browser"
      "application/pdf"
    ];
    editor = [
      "text/plain"
      "application/json"
      "application/rss+xml"
      "application/xml"
      "application/x-shellscript"
    ];
    image = [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/jpg"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/vnd.microsoft.icon"
      "image/webp"
    ];
    video = [
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/webm"
      "video/x-flv"
      "video/x-matroska"
      "video/x-msvideo"
    ];
    files = [
      "inode/directory"
    ];
    office = [
      "application/vnd.oasis.opendocument.text"
      "application/vnd.oasis.opendocument.spreadsheet"
      "application/vnd.oasis.opendocument.presentation"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/msword"
      "application/vnd.ms-excel"
      "application/vnd.ms-powerpoint"
      "application/rtf"
    ];
    terminal = [
      "terminal"
    ];
    archive = [
      "application/zip"
      "application/rar"
      "application/7z"
      "application/tar"
    ];
  };
  desktopEntry = name: "${name}.desktop";
  defaultApplications = listToAttrs (
    filter (value: value != null) (
      flatten (
        mapAttrsToList (key:
          map (
            type:
              if xdgCfg.${key} != ""
              then nameValuePair type [(desktopEntry xdgCfg.${key})]
              else null
          ))
        mimeMap
      )
    )
  );
in {
  options.${namespace}.xdg = with types; {
    browser = mkOpt str "" "The browser desktop entry name.";
    editor = mkOpt str "" "The editor desktop entry name.";
    image = mkOpt str "" "The image viewer desktop entry name.";
    video = mkOpt str "" "The video application desktop entry name.";
    files = mkOpt str "" "The file manager desktop entry name.";
    office = mkOpt str "" "The office application desktop entry name.";
    terminal = mkOpt str "" "The terminal application desktop entry name.";
    archive = mkOpt str "" "The arvive application desktop entry name.";
    associations = mkOpt attrs {} "Mixed mime types associations.";
  };

  config.home = {
    sessionVariables =
      {
        VISUAL = mkIf (xdgCfg.editor != "") (desktopEntry xdgCfg.editor);
      }
      // force-attrs {
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_CACHE_HOME = "$HOME/.local/cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_DESKTOP_DIR = "$HOME";
      };

    packages = with pkgs; [
      xdg-utils
    ];

    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";

      # nix
      nd = "nix develop";
      nfu = "nix flake update";
      nrs = "sudo nixos-rebuild switch --flake ~/.${namespace}#${host}";
    };
  };

  config.xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = defaultApplications;
      associations.added = xdgCfg.associations // defaultApplications;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
