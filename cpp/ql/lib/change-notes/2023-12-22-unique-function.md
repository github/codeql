---
category: fix
---
* Under certain circumstances a function declaration that is not also a definition could be associated with a `Function` that did not have the definition as a `FunctionDeclarationEntry`. This is now fixed when only one definition exists, and a unique `Function` will exist that has both the declaration and the definition as a `FunctionDeclarationEntry`.