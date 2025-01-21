---
category: feature
---
* New predicates `getARequiresClause`, `getTemplateRequiresClause` and `getFunctionRequiresClause` were added to the `FunctionDeclarationEntry` class, which yield the requires clauses when the entry represents a function template declaration with requires clauses.
* A new predicate `getRequiresClause` was added to the `TypeDeclarationEntry` class, which yields the requires clause when the entry represents a class template declaration with a requires clause.
* A new predicate `getRequiresClause` was added to the `VariableDeclarationEntry` class, which yields the requires clause when the entry represents a variable template declaration with a requires clause.
* A new predicate `getTypeConstraint` was added to the `TypeTemplateParameter` class, which yields the type constraint of the parameter if it exists.
