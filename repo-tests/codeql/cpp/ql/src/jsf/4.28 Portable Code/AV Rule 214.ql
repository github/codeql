/**
 * @name AV Rule 214
 * @description Assuming that non-local static objects, in separate translation units,
 *              are initialized in a special order shall not be done.
 * @kind problem
 * @id cpp/jsf/av-rule-214
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

// whether e is part of an initializer of a global variable in file f
predicate inGlobalInitializer(Expr e, File f) {
  exists(GlobalVariable gv |
    gv.getInitializer().getExpr() = e.getParent*() and
    f = gv.getFile()
  )
}

// whether c is called from within a global initializer in f
// TODO: this should be transitive, but maybe it's not worth the extra hassle
predicate calledFromGlobalInitializer(Function fn, File f) {
  exists(FunctionCall c | inGlobalInitializer(c, f) and fn = c.getTarget())
}

predicate evaluatedBeforeMain(Expr e, File f) {
  inGlobalInitializer(e, f)
  or
  exists(Function fn | calledFromGlobalInitializer(fn, f) and fn = e.getControlFlowScope())
}

// whether f1 and f2 belong to the same translation unit
predicate sameTranslationUnit(File f1, File f2) {
  exists(File f | f.getAnIncludedFile*() = f1 and f.getAnIncludedFile*() = f2)
}

from VariableAccess v, File f1, File f2
where
  v.fromSource() and
  v.isRValue() and
  evaluatedBeforeMain(v, f1) and
  v.getTarget().getFile() = f2 and
  not sameTranslationUnit(f1, f2)
select v,
  "AV Rule 214: It shall not be assumed that objects in separated translation units are initialized in a special order."
