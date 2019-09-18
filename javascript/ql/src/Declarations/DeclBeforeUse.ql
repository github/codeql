/**
 * @name Variable not declared before use
 * @description Variables should be declared before their first use.
 * @kind problem
 * @problem.severity warning
 * @id js/use-before-declaration
 * @tags maintainability
 *       readability
 * @precision very-high
 */

import javascript
private import Declarations

from VarAccess acc, VarDecl decl, Variable var, StmtContainer sc
where
  // the first reference to `var` in `sc` is `acc` (that is, an access, not a declaration)
  acc = firstRefInContainer(var, Ref(), sc) and
  // `decl` is a declaration of `var` in `sc` (which must come after `acc`)
  decl = refInContainer(var, Decl(), sc) and
  // exclude globals declared by a linter directive
  not exists(Linting::GlobalDeclaration glob | glob.declaresGlobalForAccess(acc)) and
  // exclude declarations in synthetic constructors
  not acc.getEnclosingFunction() instanceof SyntheticConstructor and
  // exclude results in ambient contexts
  not acc.isAmbient() and
  // a class may be referenced in its own decorators
  not exists(ClassDefinition cls |
    decl = cls.getIdentifier() and
    acc.getParent*() = cls.getADecorator()
  )
select acc, "Variable '" + acc.getName() + "' is used before its $@.", decl, "declaration"
