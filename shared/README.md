# CodeQL Shared Libraries

This folder contains shared, language-agnostic CodeQL libraries.

Libraries are organized into separate query packs, in order to allow for
individual versioning. For example, the shared static single assignment (SSA)
library exists in the `codeql/ssa` pack, which can be referenced by adding

```
dependencies:
  codeql/ssa: 0.0.1
```

to `qlpack.yml`.

All shared libraries will belong to a `codeql/<name>` pack, and live in the
namespace `codeql.<name>`.