{
  description = "My personal package repository";

  outputs = { self }: {
    overlay = final: prev: (import ./pkgs/default.nix { pkgs = final; });
  };
}
