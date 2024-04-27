# json 🐑

**Mirrors:** [**GitHub**](https://github.com/glistix/json) | [**Codeberg**](https://codeberg.org/glistix/json)

This is a fork of [`gleam_json`](https://github.com/gleam-lang/json) which **adds support for Glistix's Nix target.**

## Incompatibilities

Please note that, currently, **JSON decoding (the `decode` function) will crash when receiving invalid input on the Nix target**
instead of returning an `Error`.

This is because it uses `builtins.fromJSON` which aborts execution on invalid input. A fix for this would likely depend
on changes to Nix itself.

## Installation

Currently, this package must be used as a **local dependency to a Git submodule.**
This ensures transitive dependencies on `gleam_json` will also use the patch.

For instructions, please see [the Glistix handbook](https://glistix.github.io/book/recipes/overriding-packages.html).

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
> returning an `Error`. Ensure you always take valid JSON input.

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
