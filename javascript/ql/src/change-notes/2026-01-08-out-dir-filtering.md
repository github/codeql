---
category: fix
---
* Fixed a bug that would cause `.ts` files to be skipped when they were inside the `outDir` of
  the corresponding `tsconfig.json` file. Now only JavaScript files are excluded when they appear
  in the `outDir`.
