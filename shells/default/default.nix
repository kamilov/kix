{
  mkShell,
  pkgs,
  namespace,
  ...
}:
mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";

  packages = with pkgs; [
    nh

    statix
    deadnix
    alejandra
    home-manager
    git
    sops
    ssh-to-age
    gnupg
    age
  ];

  shellHook = ''
    echo 🔨 Welcome to ${namespace}
  '';
}
