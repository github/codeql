## 0.3.2

### Bug Fixes

* Under certain circumstances a variable declaration that is not also a definition could be associated with a `Variable` that did not have the definition as a `VariableDeclarationEntry`. This is now fixed, and a unique `Variable` will exist that has both the declaration and the definition as a `VariableDeclarationEntry`.
