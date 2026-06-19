{
  description = "My personal package repository";

  inputs = {
    timelauncherInput.url = "path:./pkgs/timelauncher";
    scrollsawInput.url = "path:./pkgs/scrollsaw";
  };

  outputs = { self, nixpkgs, timelauncherInput, scrollsawInput }: let
    supportedSystems = ["x86_64-linux"];

    forAllSystems = f:
      builtins.listToAttrs (map (name: {
          inherit name;
          value = f name;
        })
        supportedSystems);
  in {
    overlay = final: prev: (import ./pkgs/default.nix {
      pkgs = final;
      timelauncherFlake = timelauncherInput;
      scrollsawFlake = scrollsawInput;
    });

    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};

        myPkgs = import ./pkgs/default.nix {
          inherit pkgs;
          timelauncherFlake = timelauncherInput;
          scrollsawFlake = scrollsawInput;
        };
      in {
        timelauncher = myPkgs.timelauncher;
        scrollsaw = myPkgs.scrollsaw;
        default = myPkgs.timelauncher;
      }
    );
  };
}
