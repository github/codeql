/**
 * @name Missing 'this' qualifier
 * @description Referencing an undeclared global variable in a class that has a member of the same name is confusing and may indicate a bug.
 * @kind problem
 * @problem.severity error
 * @id js/missing-this-qualifier
 * @tags maintainability
 *       correctness
 *       methods
 * @precision high
 */

import javascript

/**
 * Holds if `call` is a call to global function `gv` which has the same name as method
 * `intendedTarget` in the same class as `call`.
 */
predicate maybeMissingThis(CallExpr call, MethodDeclaration intendedTarget, GlobalVariable gv) {
  call.getCallee() = gv.getAnAccess() and
  call.getCalleeName() = intendedTarget.getName() and
  exists(MethodDefinition caller |
    caller.getBody() = call.getContainer() and
    intendedTarget.getDeclaringClass() = caller.getDeclaringClass()
  )
}

from CallExpr call, MethodDeclaration intendedTarget, GlobalVariable gv
where
  maybeMissingThis(call, intendedTarget, gv) and
  // exceptions:
  not (
    // affected by `with`
    exists(WithStmt with | with.mayAffect(call.getCallee()))
    or
    // locally declared, so probably intentional
    gv.getADeclaration().getTopLevel() = call.getTopLevel()
    or
    // linter declaration for the variable
    exists(Linting::GlobalDeclaration glob | glob.declaresGlobalForAccess(call.getCallee()))
    or
    // externs declaration for the variable
    exists(ExternalGlobalDecl egd | egd.getName() = call.getCalleeName())
    or
    // variable available through a namespace
    exists(Variable decl |
      decl.getName() = gv.getName() and
      decl.isNamespaceExport() and
      call.getContainer().getEnclosingContainer*() instanceof NamespaceDeclaration
    )
    or
    // call to global function with additional arguments
    exists(Function self |
      intendedTarget.getBody() = self and
      call.getEnclosingFunction() = self and
      call.flow().(DataFlow::CallNode).getNumArgument() > self.getNumParameter() and
      not self.hasRestParameter() and
      not self.usesArgumentsObject()
    )
  )
select call, "This call refers to a global function, and not the local method $@.", intendedTarget,
  intendedTarget.getName()
