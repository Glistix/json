# This will let Nix users import from your repository without flakes.
# Exposes the flake's outputs.
# Source: https://wiki.nixos.org/wiki/Flakes#Using_flakes_with_stable_Nix
#
# Usage:
#
# let
#   yourProject = import (builtins.fetchurl { url = "your url"; sha256 = ""; });  # for example
#   mainResult = (yourProject.lib.loadGlistixPackage {}).main {};
# in doSomethingWith mainResult;
(import (
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  in fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash; }
) {
  src = ./.;
}).defaultNix
