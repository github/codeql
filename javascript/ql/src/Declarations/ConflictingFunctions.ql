/**
 * @name Conflicting function declarations
 * @description If two functions with the same name are declared in the same scope, one of the declarations
 *              overrides the other without warning. This makes the code hard to read and maintain, and
 *              may even lead to platform-dependent behavior.
 * @kind problem
 * @problem.severity error
 * @id js/function-declaration-conflict
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-563
 * @precision high
 */

import javascript

from FunctionDeclStmt f, FunctionDeclStmt g
where
  f.getVariable() = g.getVariable() and
  // ignore global functions; conflicts across scripts are usually false positives
  not f.getVariable().isGlobal() and
  // only report each pair once
  f.getLocation().startsBefore(g.getLocation()) and
  // ignore ambient, abstract, and overloaded declarations in TypeScript
  f.hasBody() and
  g.hasBody()
select f.getIdentifier(),
  "Declaration of " + f.describe() + " conflicts with $@ in the same scope.", g.getIdentifier(),
  "another declaration"
