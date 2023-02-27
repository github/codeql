This package aliases [`misc/codegen`](../misc/codegen) providing the Swift-specific options
in [`swift/codegen.conf`](../codegen.conf).

Running `bazel run //swift/codegen` will generate all checked in
files ([dbscheme](../ql/lib/swift.dbscheme), [QL generated code](../ql/lib/codeql/swift/generated),
[generated QL stubs](../ql/lib/codeql/swift/elements), [generated QL tests](../ql/test/extractor-tests/generated)).

C++ code is generated during build (see [`swift/extractor/trap/BUILD.bazel`](../extractor/trap/BUILD.bazel)). After a
build you can browse the generated code in `bazel-bin/swift/extractor/trap/generated` from the root of the `codeql`
repository.
