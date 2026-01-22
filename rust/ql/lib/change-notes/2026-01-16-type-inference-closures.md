---
category: minorAnalysis
---
* Added type inference support for the `FnMut(..) -> ..` and `Fn(..) -> ..` traits. They now work in type parameter bounds and are implemented by closures.