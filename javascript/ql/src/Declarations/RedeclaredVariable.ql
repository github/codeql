/**
 * @name Redeclared variable
 * @description Declaring the same variable twice is confusing and may even suggest a latent bug.
 * @kind problem
 * @problem.severity recommendation
 * @id js/variable-redeclaration
 * @tags reliability
 *       readability
 * @precision medium
 */

import javascript
private import Declarations

from Variable v, TopLevel tl, VarDecl decl, VarDecl redecl
where
  decl = firstRefInTopLevel(v, Decl(), tl) and
  redecl = refInTopLevel(v, Decl(), tl) and
  redecl != decl and
  not tl.isExterns() and
  // Ignore redeclared ambient declarations, such as overloaded functions.
  not decl.isAmbient() and
  not redecl.isAmbient() and
  // Redeclaring a namespace extends the previous definition.
  not decl = any(NamespaceDeclaration ns).getIdentifier() and
  not redecl = any(NamespaceDeclaration ns).getIdentifier()
select redecl, "This variable has already been declared $@.", decl, "here"
