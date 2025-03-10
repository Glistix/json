# json 🐑

**Mirrors:** [**GitHub**](https://github.com/glistix/json) | [**Codeberg**](https://codeberg.org/glistix/json)

[![Nix-compatible](https://img.shields.io/badge/target-nix-5277C3)](https://github.com/glistix/glistix)

Work with JSON in [Glistix](https://github.com/glistix/glistix)!

This is a fork of [`gleam_json`](https://github.com/gleam-lang/json) which **adds support for Glistix's Nix target**.

## Incompatibilities

Please note that, currently, **JSON decoding (the `decode` function) will crash when receiving invalid JSON input on the Nix target** instead of gracefully failing and returning an `Error`.

This is because it uses `builtins.fromJSON` which aborts execution on invalid input. A fix for this while retaining efficiency would likely depend on changes to Nix itself.

## Installation

You can use this fork by running `glistix add gleam_json` followed by adding the line below to your Glistix project's `gleam.toml` file (as of Glistix v0.7.0):

```toml
[glistix.preview.patch]
# ... Existing patches ...
# Add this line:
gleam_json = { name = "glistix_json", version = ">= 1.0.0 and < 2.0.0" }
```

This ensures transitive dependencies on `gleam_json` will also use the patch.

For the most recent instructions, please see [the Glistix handbook](https://glistix.github.io/book/recipes/overriding-packages.html).

### Encoding

```gleam
import myapp.{Cat}
import gleam/json.{object, string, array, int, null}

pub fn cat_to_json(cat: Cat) -> String {
  object([
    #("name", string(cat.name)),
    #("lives", int(cat.lives)),
    #("flaws", null()),
    #("nicknames", array(cat.nicknames, of: string)),
  ])
  |> json.to_string
}
```

### Decoding

JSON is decoded into a `Dynamic` value which can be decoded using the
`gleam/dynamic` module from the Gleam standard library.

> [!WARNING]
>
> On the Nix target, invalid JSON input will cause a crash instead of
> returning an `Error`. Ensure you always provide valid JSON input.

```gleam
import myapp.{Cat}
import gleam/json
import gleam/dynamic.{field, list, int, string}

pub fn cat_from_json(json_string: String) -> Result(Cat, json.DecodeError) {
  let cat_decoder = dynamic.decode3(
    Cat,
    field("name", of: string),
    field("lives", of: int),
    field("nicknames", of: list(string)),
  )

  json.decode(from: json_string, using: cat_decoder)
}
```
