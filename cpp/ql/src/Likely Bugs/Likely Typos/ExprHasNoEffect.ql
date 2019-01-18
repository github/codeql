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

class PureExprInVoidContext extends ExprInVoidContext {
  PureExprInVoidContext() { this.isPure() }
}

// loop variable mentioned in the init stmt of a for
predicate accessInInitOfForStmt(Expr e) {
  e instanceof Access and
  exists(ForStmt f, ExprStmt s | f.getInitialization() = s and
                                 s.getExpr() = e)
}

/**
 * Holds if the preprocessor branch `pbd` is on line `pbdStartLine` in file `file`.
 */
predicate pbdLocation(PreprocessorBranchDirective pbd, string file, int pbdStartLine) {
  pbd.getLocation().hasLocationInfo(file, pbdStartLine, _, _, _)
}

/**
 * Holds if the body of the function `f` is on lines `fBlockStartLine` to `fBlockEndLine` in file `file`.
 */
predicate functionLocation(Function f, string file, int fBlockStartLine, int fBlockEndLine) {
  f.getBlock().getLocation().hasLocationInfo(file, fBlockStartLine, _, fBlockEndLine, _)
}
/**
 * Holds if the function `f`, or a function called by it, contains
 * code excluded by the preprocessor.
 */
predicate containsDisabledCode(Function f) {
  // `f` contains a preprocessor branch that was not taken
  exists(PreprocessorBranchDirective pbd, string file, int pbdStartLine, int fBlockStartLine, int fBlockEndLine  |
    functionLocation(f, file, fBlockStartLine, fBlockEndLine) and
    pbdLocation(pbd, file, pbdStartLine) and
    pbdStartLine <= fBlockEndLine and
    pbdStartLine >= fBlockStartLine and
    (
      pbd.(PreprocessorBranch).wasNotTaken() or

      // an else either was not taken, or it's corresponding branch
      // was not taken.
      pbd instanceof PreprocessorElse
    )
  ) or

  // recurse into function calls
  exists(FunctionCall fc |
    fc.getEnclosingFunction() = f and
    containsDisabledCode(fc.getTarget())
  )
}


/**
 * Holds if the function `f`, or a function called by it, is inside a
 * preprocessor branch that may have code in another arm
 */
predicate definedInIfDef(Function f) {
  exists(PreprocessorBranchDirective pbd, string file, int pbdStartLine, int pbdEndLine, int fBlockStartLine, int fBlockEndLine  |
    functionLocation(f, file, fBlockStartLine, fBlockEndLine) and
    pbdLocation(pbd, file, pbdStartLine) and
    pbdLocation(pbd.getNext(), file, pbdEndLine) and
    pbdStartLine <= fBlockStartLine and
    pbdEndLine >= fBlockEndLine and
    // pbd is a preprocessor branch where multiple branches exist
    (
      pbd.getNext() instanceof PreprocessorElse or
      pbd instanceof PreprocessorElse or
      pbd.getNext() instanceof PreprocessorElif or
      pbd instanceof PreprocessorElif
    )
  ) or

  // recurse into function calls
  exists(FunctionCall fc |
    fc.getEnclosingFunction() = f and
    definedInIfDef(fc.getTarget())
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
    call.getEnclosingFunction().getDeclaringType().(Class).getABaseClass+()
}

from PureExprInVoidContext peivc, Locatable parent,
  Locatable info, string info_text, string tail
where // EQExprs are covered by CompareWhereAssignMeant.ql
      not peivc instanceof EQExpr and
      // as is operator==
      not peivc.(FunctionCall).getTarget().hasName("operator==") and
      not baseCall(peivc) and
      not accessInInitOfForStmt(peivc) and
      not peivc.isCompilerGenerated() and
      not exists(Macro m | peivc = m.getAnInvocation().getAnExpandedElement()) and
      not peivc.isFromTemplateInstantiation(_) and
      parent = peivc.getParent() and
      not parent.isInMacroExpansion() and
      not parent instanceof PureExprInVoidContext and
      not peivc.getEnclosingFunction().isCompilerGenerated() and
      not peivc.getType() instanceof UnknownType and
      not containsDisabledCode(peivc.(FunctionCall).getTarget()) and
      not definedInIfDef(peivc.(FunctionCall).getTarget()) and
      if peivc instanceof FunctionCall then
        exists(Function target |
          target = peivc.(FunctionCall).getTarget() and
          info = target and
          info_text = target.getName() and
          tail = " (because $@ has no external side effects).")
      else
        (tail = "." and info = peivc and info_text = "")
select peivc, "This expression has no effect" + tail,
       info, info_text
