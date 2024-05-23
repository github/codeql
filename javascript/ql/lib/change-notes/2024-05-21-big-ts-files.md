---
category: fix
---
* Fixed a bug where very large TypeScript files would cause database creation to crash. Large files over 10MB were already excluded from analysis, but the file size check was not applied to TypeScript files.