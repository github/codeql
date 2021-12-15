/**
 * @name Error-prone name of loop variable
 * @description The iteration variable of a nested loop should have a descriptive name: short names like i, j, or k can cause confusion except in very simple loops.
 * @kind problem
 * @id cpp/short-loop-var-name
 * @problem.severity recommendation
 * @precision medium
 * @tags maintainability
 *       readability
 */

import cpp

predicate short(Variable v) { v.getName().length() = 1 }

predicate forStmtAncestor(Stmt child, ForStmt parent) {
  child.getParent() = parent or forStmtAncestor(child.getParent(), parent)
}

/**
 * Gets an `ArrayExpr` that's nested directly inside `ArrayExpr ae`.
 */
ArrayExpr getANestedArrayExpr(ArrayExpr ae) { result.getArrayBase() = ae }

/**
 * Holds if variables `a` and `b` are accessed in a way that looks like they
 * are a coordinate pair.  For example:
 * ```
 *  arr[x][y]
 *  arr[(y * width) + x]
 * ```
 */
predicate coordinatePair(Variable a, Variable b) {
  exists(ArrayExpr ae |
    getANestedArrayExpr*(ae).getArrayOffset().getAChild*() = a.getAnAccess() and
    getANestedArrayExpr*(ae).getArrayOffset().getAChild*() = b.getAnAccess() and
    not a = b
  )
}

from ForStmt outer, ForStmt inner, Variable iterationVar, Variable innerVar
where
  forStmtAncestor(inner, outer) and
  short(innerVar) and
  iterationVar = outer.getAnIterationVariable() and
  innerVar = inner.getAnIterationVariable() and
  short(iterationVar) and
  not coordinatePair(iterationVar, innerVar)
select iterationVar,
  "Iteration variable " + iterationVar.getName() +
    " for $@ should have a descriptive name, since there is $@.", outer, "this loop", inner,
  "a nested loop"
