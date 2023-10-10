---
category: minorAnalysis
---
* Deleted the deprecated `getAnImmediateUse`, `getAUse`, `getARhs`, and `getAValueReachingRhs` predicates from the `API::Node` class.
* Deleted the deprecated `mayReferToParameter` predicate from `DataFlow::Node`.
* Deleted the deprecated `getStaticMethod` and `getAStaticMethod` predicates from `DataFlow::ClassNode`.
* Deleted the deprecated `isLibaryFile` predicate from `ClassifyFiles.qll`, use `isLibraryFile` instead.
* Deleted many library models that were build on the AST. Use the new models that are build on the dataflow library instead.
* Deleted the deprecated `semmle.javascript.security.performance` folder, use `semmle.javascript.security.regexp` instead.
