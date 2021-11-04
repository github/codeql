/**
 * @name Expression has no effect
 * @description A pure expression whose value is ignored is likely to be the
 *              result of a typo.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/useless-expression
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-561
 */

import cpp
private import semmle.code.cpp.commons.Exclusions

class PureExprInVoidContext extends ExprInVoidContext {
  PureExprInVoidContext() { this.isPure() }
}

// loop variable mentioned in the init stmt of a for
predicate accessInInitOfForStmt(Expr e) {
  e instanceof Access and
  exists(ForStmt f, ExprStmt s |
    f.getInitialization() = s and
    s.getExpr() = e
  )
}

/**
 * Holds if the function `f`, or a function called by it, contains
 * code excluded by the preprocessor.
 */
predicate functionContainsDisabledCodeRecursive(Function f) {
  functionContainsDisabledCode(f)
  or
  // recurse into function calls
  exists(FunctionCall fc |
    fc.getEnclosingFunction() = f and
    functionContainsDisabledCodeRecursive(fc.getTarget())
  )
}

/**
 * Holds if the function `f`, or a function called by it, is inside a
 * preprocessor branch that may have code in another arm
 */
predicate functionDefinedInIfDefRecursive(Function f) {
  functionDefinedInIfDef(f)
  or
  // recurse into function calls
  exists(FunctionCall fc |
    fc.getEnclosingFunction() = f and
    functionDefinedInIfDefRecursive(fc.getTarget())
  )
}

/**
 * Holds if `call` has the form `B::f()` or `q.B::f()`, where `B` is a base
 * class of the class containing `call`.
 *
 * This is most often used for calling base-class functions from within
 * overrides. Those functions may have no side effect in the current
 * implementation, but we should not advise callers to rely on this. That would
 * break encapsulation.
 */
predicate baseCall(FunctionCall call) {
  call.getNameQualifier().getQualifyingElement() =
    call.getEnclosingFunction().getDeclaringType().getABaseClass+()
}

from PureExprInVoidContext peivc, Locatable parent, Locatable info, string info_text, string tail
where
  // EQExprs are covered by CompareWhereAssignMeant.ql
  not peivc instanceof EQExpr and
  // as is operator==
  not peivc.(FunctionCall).getTarget().hasName("operator==") and
  not baseCall(peivc) and
  not accessInInitOfForStmt(peivc) and
  not peivc.isCompilerGenerated() and
  not peivc.getEnclosingFunction().isDefaulted() and
  not exists(Macro m | peivc = m.getAnInvocation().getAnExpandedElement()) and
  not peivc.isFromTemplateInstantiation(_) and
  not peivc.isFromUninstantiatedTemplate(_) and
  parent = peivc.getParent() and
  not parent.isInMacroExpansion() and
  not peivc.isUnevaluated() and
  not parent instanceof PureExprInVoidContext and
  not peivc.getEnclosingFunction().isCompilerGenerated() and
  not peivc.getType() instanceof UnknownType and
  not functionContainsDisabledCodeRecursive(peivc.(FunctionCall).getTarget()) and
  not functionDefinedInIfDefRecursive(peivc.(FunctionCall).getTarget()) and
  if peivc instanceof FunctionCall
  then
    exists(Function target |
      target = peivc.(FunctionCall).getTarget() and
      info = target and
      info_text = target.getName() and
      tail = " (because $@ has no external side effects)."
    )
  else (
    tail = "." and info = peivc and info_text = ""
  )
select peivc, "This expression has no effect" + tail, info, info_text
