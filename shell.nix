# This exposes the dev shell declared in the flake.
# Running `nix-shell` will thus be equivalent to `nix develop`.
# Source: https://wiki.nixos.org/wiki/Flakes#Using_flakes_with_stable_Nix
#
# Usage: Run `nix-shell`, and the `glistix` command will be available
# for you to use.
(import (
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  in fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash; }
) {
  src = ./.;
}).shellNix
