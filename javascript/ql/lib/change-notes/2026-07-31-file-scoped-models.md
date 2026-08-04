---
category: majorAnalysis
---
* It is now possible for custom models to refer to specific files in the codebase, using a package name of form `file:<path>`. The model should describe the public exports
  of that file. This can be used to derive sources and sinks in code that imports the file, but note that sources and sinks will not generally be placed within the file itself.
  For example, a source model `['file:lib/service.js', 'Member[getData].ReturnValue', 'remote']` could identify `require('../lib/service').getData()` as a source.
