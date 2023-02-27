# Code generation suite

This directory contains the code generation suite used by the Swift extractor and the QL library. This suite will use
the abstract class specification of `schema.py` to generate:

* the `dbscheme` file (see [`dbschemegen.py`](generators/dbschemegen.py))
* the QL generated code and when appropriate the corresponding stubs (see [`qlgen.py`](generators/qlgen.py))
* C++ tags and trap entries (see [`trapgen.py`](generators/trapgen.py))
* C++ structured classes (see [`cppgen.py`](generators/cppgen.py))

An example `schema.py` [can be found in the Swift package](../../swift/schema.py).

## Usage

By default `bazel run //misc/codegen -- -c your-codegen.conf` will load options from `your-codegen.conf`. See
the [Swift configuration](../../swift/codegen.conf) for an example. Calling `misc/codegen/codegen.py` directly (provided
you installed dependencies via `pip3 install -r misc/codegen/requirements.txt`) will use a file named `codegen.conf`
contained in an ancestor directory if any exists.

See `bazel run //misc/codegen -- --help` for a list of all options. In particular `--generate` can be used with a comma
separated list to select what to generate (choosing among `dbscheme`, `ql`, `trap` and `cpp`).

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
