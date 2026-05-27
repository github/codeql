---
category: breaking
---
* Removed the deprecated `overrideReturnsNull` predicate from `Options.qll`. Use `CustomOptions.overrideReturnsNull` instead.
* Removed the deprecated `returnsNull` predicate from `Options.qll`. Use `CustomOptions.returnsNull` instead.
* Removed the deprecated `exits` predicate from `Options.qll`. Use `CustomOptions.exist` instead.
* Removed the deprecated `exprExits` predicate from `Options.qll`. Use `CustomOptions.exprExits` instead.
* Removed the deprecated `alwaysCheckReturnValue` predicate from `Options.qll`. Use `CustomOptions.alwaysCheckReturnValue` instead.
* Removed the deprecated `okToIgnoreReturnValue` predicate from `Options.qll`. Use `CustomOptions.okToIgnoreReturnValue` instead.
* Removed the deprecated `semmle.code.cpp.Member`. Import `semmle.code.cpp.Element` and/or `semmle.code.cpp.Type` directly.
* Removed the deprecated `UnknownDefaultLocation` class. Use `UnknownLocation` instead.
* Removed the deprecated `UnknownExprLocation` class. Use `UnknownLocation` instead.
* Removed the deprecated `UnknownStmtLocation` class. Use `UnknownLocation` instead.
* Removed the deprecated `TemplateParameter` class. Use `TypeTemplateParameter` instead.
* Support for class resolution across link targets has been removed for databases which were created with CodeQL versions before 1.23.0.
