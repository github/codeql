# Code generation suite

This directory contains the code generation suite used by the Swift extractor and the QL library. This suite will use
the abstract class specification of [`schema.yml`](schema.yml) to generate:

* [the `dbscheme` file](../ql/lib/misc.dbscheme) (see [`dbschemegen.py`](generators/dbschemegen.py))
* [the QL generated code](../ql/lib/codeql/swift/generated) and when
  appropriate [the corresponding stubs](../ql/lib/codeql/swift/elements) (see [`qlgen.py`](generators/qlgen.py))
* C++ tags and trap entries (see [`trapgen.py`](generators/trapgen.py))
* C++ structured classes (see [`cppgen.py`](generators/cppgen.py))

## Usage

By default `bazel run //misc/codegen` will update all checked-in generated files (`dbscheme` and QL sources). You can
append `--` followed by other options to tweak the behaviour, which is mainly intended for debugging.
See `bazel run //misc/codegen -- --help` for a list of all options. In particular `--generate` can be used with a comma
separated list to select what to generate (choosing among `dbscheme`, `ql`, `trap` and `cpp`).

C++ code is generated during build (see [`swift/extractor/trap/BUILD.bazel`](../extractor/trap/BUILD.bazel)). After a
build you can browse the generated code in `bazel-bin/swift/extractor/trap/generated`.

For debugging you can also run `./codegen.py` directly. You must then ensure dependencies are installed, which you can
with the command

```bash
pip3 install -r ./requirements.txt
```

## Implementation notes

The suite uses [mustache templating](https://mustache.github.io/) for generation. Templates are
in [the `templates` directory](templates), prefixed with the generation target they are used for.

Rather than passing dictionaries to the templating engine, python dataclasses are used as defined
in [the `lib` directory](lib). For each of the four generation targets the entry point for the implementation is
specified as the `generate` function in the modules within [the `generators` directory](generators).

Finally, [`codegen.py`](codegen.py) is the driver script gluing everything together and specifying the command line
options.

Unit tests are in [the `test` directory](test) and can be run via `bazel test //misc/codegen/test`.

For more details about each specific generation target, please refer to the module docstrings
in [the `generators` directory](generators).
