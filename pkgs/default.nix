# pkgs/default.nix
{
  pkgs,
  timelauncherFlake,
  scrollsawFlake,
}: {
  hakuneko = pkgs.callPackage ./hakuneko/default.nix {};
  timelauncher = timelauncherFlake.lib.${pkgs.system}.mkPackage {inherit pkgs;};

  scrollsaw = scrollsawFlake.lib.${pkgs.system}.mkPackage {inherit pkgs;};
}
