# Swift on CodeQL

## Warning

The Swift CodeQL package is an experimental and unsupported work in progress.

## Building the Swift extractor

First ensure you have Bazel installed, for example with

```bash
brew install bazelisk
```

then from the `ql` directory run

```bash
bazel run //swift:create-extractor-pack    # --cpu=darwin_x86_64 # Uncomment on Arm-based Macs
```

which will install `swift/extractor-pack`.

Notice you can run `bazel run :create-extractor-pack` if you already are in the `swift` directory.

Using `codeql ... --search-path=swift/extractor-pack` will then pick up the Swift extractor. You can also use
`--search-path=.`, as the extractor pack is mentioned in the root `codeql-workspace.yml`. Alternatively, you can
set up the search path in [the per-user CodeQL configuration file](https://codeql.github.com/docs/codeql-cli/specifying-command-options-in-a-codeql-configuration-file/#using-a-codeql-configuration-file).

## Code generation

Run

```bash
bazel run //swift/codegen
```

to update generated files. This can be shortened to
`bazel run codegen` if you are in the `swift` directory.

## IDE setup

### CLion and the native bazel plugin

You can use [CLion][1] with the official [IntelliJ Bazel plugin][2], creating the project from scratch with default
options. This is known to have issues on non-Linux platforms.

[1]: https://www.jetbrains.com/clion/

[2]: https://ij.bazel.build/

### CMake project

The `CMakeLists.txt` file allows to load the Swift extractor as a CMake project, which allows integration into a wider
variety of IDEs. Building with CMake also creates a `compile_commands.json` compilation database that can be picked up
by even more IDEs. In particular, opening the `swift` directory in VSCode should work.
