let
  inherit (builtins.import ./gleam.nix) listToArray Ok;

  identity = x: x;

  json_to_string = builtins.toJSON;

  # TODO: Somehow detect invalid JSON
  decode = string: Ok (builtins.fromJSON string);

  do_null = {}: null;

  object =
    entries:
      let
        entryArray = listToArray entries;
        mappedEntries =
          builtins.map
          (entry: { name = builtins.head entry; value = builtins.elemAt entry 1; })
          entryArray;
      in builtins.listToAttrs mappedEntries;

  array = listToArray;
in { inherit identity json_to_string decode do_null object array; }
