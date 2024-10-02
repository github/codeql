---
category: minorAnalysis
---
* All AST classes in `codeql.swift.elements` are now `final`, which means that it is no longer possible to `override` predicates defined in those classes (it is, however, still possible to `extend` the classes).
