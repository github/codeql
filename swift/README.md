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
set up the search path
in [the per-user CodeQL configuration file](https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/specifying-command-options-in-a-codeql-configuration-file#using-a-codeql-configuration-file)
.

## Code generation

Run

```bash
bazel run //swift/codegen
```

to update generated files. This can be shortened to
`bazel run codegen` if you are in the `swift` directory.

You can also run `../misc/codegen/codegen.py`, as long as you are beneath the `swift` directory.

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

### Debugging codeql database creation

If you want to debug a specific run of the extractor within an integration test or a complex `codeql database create`
invocation, you can do so using [`gdbserver`][gdbserver] or [`lldb-server`][lldb-server].

[gdbserver]: https://sourceware.org/gdb/onlinedocs/gdb/gdbserver-man.html

[lldb-server]: https://lldb.llvm.org/man/lldb-server.html

For example with `gdbserver`, you can

```bash
export CODEQL_EXTRACTOR_SWIFT_RUN_UNDER="gdbserver :1234"
export CODEQL_EXTRACTOR_SWIFT_RUN_UNDER_FILTER="SomeSwiftSource\.swift"  # can be any regex matching extractor args
```

before starting the database extraction, and when that source is encountered the extractor will be run under
a `gdbserver` instance listening on port 1234. You can then attach to the running debugging server from `gdb` or your
IDE. Please refer to your IDE's instructions for how to set up remote debugging.

In particular for breakpoints to work you might need to setup the following remote path mapping:

| Remote      | Local                                |
|-------------|--------------------------------------|
| `swift`     | `/absolute/path/to/codeql/swift`     |
| `bazel-out` | `/absolute/path/to/codeql/bazel-out` |
