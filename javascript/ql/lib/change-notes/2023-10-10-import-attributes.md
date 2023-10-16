---
category: minorAnalysis
---
* [Import attributes](https://github.com/tc39/proposal-import-attributes) are now supported in JavaScript code.
  Note that import attributes are an evolution of an earlier proposal called "import assertions", which were implemented in TypeScript 4.5.
  The QL library includes new predicates named `getImportAttributes()` that should be used in favor of the now deprecated `getImportAssertion()`;
  in addition, the `getImportAttributes()` method of the `DynamicImportExpr` has been renamed to `getImportOptions()`. 
