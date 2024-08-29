This package aliases [`misc/codegen`](../misc/codegen) providing the Rust-specific options
in [`rust/codegen.conf`](../codegen.conf).

Running `bazel run //rust/codegen` will generate all checked in
files ([dbscheme](../ql/lib/swift.dbscheme), [QL generated code](../ql/lib/codeql/swift/generated),
[generated QL stubs](../ql/lib/codeql/swift/elements), [generated QL tests](../ql/test/extractor-tests/generated)).
