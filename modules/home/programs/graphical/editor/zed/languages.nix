pkgs: {
  extraPackages = with pkgs; [
    nixd
    nil
  ];

  extension = ["nix"];

  lsp = {
    nixd.settings.diagnostic.suppress = ["sema-extra-with"];
    nil.settings.diagnostics.ignored = ["unused_binding"];
  };

  languages = {
    Nix.language_servers = ["nixd" "!nil"];
  };
}
