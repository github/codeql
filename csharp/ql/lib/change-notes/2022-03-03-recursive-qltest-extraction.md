---
category: breaking
---
* `codeql test run` now extracts source code recursivelly from sub folders. This may break existing tests that have other tests in nested sub folders, as those will now get the nested test code included.