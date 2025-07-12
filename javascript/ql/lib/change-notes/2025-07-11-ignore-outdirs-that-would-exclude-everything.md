---
category: fix
---
* The JavaScript extractor no longer ignores source files specified in the `tsconfig.json` compiler options `outDir` if doing so would result in excluding all source code.
