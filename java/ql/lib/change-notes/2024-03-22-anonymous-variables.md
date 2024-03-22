---
category: minorAnalysis
---
* The Java extractor and QL libraries now support Java 22, including support for anonymous variables, lambda parameters and patterns.
* Pattern cases with multiple patterns and that fall through to or from other pattern cases are now supported. The `PatternCase` class gains the new `getPatternAtIndex` and `getAPattern` predicates, and deprecates `getPattern`.
