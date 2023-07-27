---
category: breaking
---
* The `shouldPrintFunction` predicate from `PrintAstConfiguration` has been replaced by `shouldPrintDeclaration`. Users should now override `shouldPrintDeclaration` if they want to limit the declarations that should be printed.
* The `shouldPrintFunction` predicate from `PrintIRConfiguration` has been replaced by `shouldPrintDeclaration`. Users should now override `shouldPrintDeclaration` if they want to limit the declarations that should be printed.
