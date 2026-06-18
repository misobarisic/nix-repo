# pkgs/default.nix
#{ pkgs, unstable }: {
{ pkgs }: {
  # If HakuNeko builds fine using stable dependencies:
  hakuneko = pkgs.callPackage ./hakuneko/default.nix { };
  timelauncher = pkgs.callPackage ./timelauncher/default.nix { };

  # If you add a package later that absolutely requires bleeding-edge unstable tools:
  # some-bleeding-edge-app = unstable.callPackage ./some-app/default.nix { };
}
