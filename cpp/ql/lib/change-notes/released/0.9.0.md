## 0.9.0

### Breaking Changes

* The `shouldPrintFunction` predicate from `PrintAstConfiguration` has been replaced by `shouldPrintDeclaration`. Users should now override `shouldPrintDeclaration` if they want to limit the declarations that should be printed.
* The `shouldPrintFunction` predicate from `PrintIRConfiguration` has been replaced by `shouldPrintDeclaration`. Users should now override `shouldPrintDeclaration` if they want to limit the declarations that should be printed.

### Major Analysis Improvements

* The `PrintAST` library now also prints global and namespace variables and their initializers.

### Minor Analysis Improvements

* The `_Float128x` type is no longer exposed as a builtin type. As this type could not occur any code base, this should only affect queries that explicitly looked at the builtin types.
