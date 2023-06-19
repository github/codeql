---
category: minorAnalysis
---
* Deleted many deprecated predicates and classes with uppercase `URL`, `XSS`, etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `getValueText` predicate from the `Expr`, `StringComponent`, and `ExprCfgNode` classes. Use `getConstantValue` instead.
* Deleted the deprecated `VariableReferencePattern` class, use `ReferencePattern` instead.
* Deleted all deprecated aliases in `StandardLibrary.qll`, use `codeql.ruby.frameworks.Core` and `codeql.ruby.frameworks.Stdlib` instead.