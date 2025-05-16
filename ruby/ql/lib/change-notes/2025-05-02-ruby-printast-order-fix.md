---
category: fix
---
### Bug Fixes

* The Ruby printAst.qll library now orders AST nodes slightly differently: child nodes that do not literally appear in the source code, but whose parent nodes do, are assigned a deterministic order based on a combination of source location and logical order within the parent. This fixes the non-deterministic ordering that sometimes occurred depending on evaluation order. The effect may also be visible in downstream uses of the printAst library, such as the AST view in the VSCode extension.
