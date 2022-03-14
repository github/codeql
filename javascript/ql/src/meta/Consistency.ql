/**
 * @name Violation of API contract
 * @description If the snapshot database or the QL library violates an API contract described
 *              in the documentation, queries that rely on the contract may yield unexpected
 *              results.
 * @kind table
 * @id js/consistency/api-contracts
 * @tags consistency
 */

import javascript

/**
 * Holds if `e` is an expression that need not have an enclosing statement.
 */
predicate exprWithoutEnclosingStmt(Expr e) {
  // Function names, parameters, default values and bodies do not have an enclosing statement.
  exists(Function f | e = f.getAChild()) or
  exists(Parameter p | e = p.getDefault()) or
  // Class members do not have enclosing statements.
  exists(MemberDefinition md | e = md.getAChild()) or
  // If an expression's parent has no enclosing statement, then neither does the expression itself.
  exprWithoutEnclosingStmt(e.getParent()) or
  // Some expressions have non-expression parents that we want to skip over.
  exprWithoutEnclosingStmt(e.getParent().(Property).getObjectExpr()) or
  exprWithoutEnclosingStmt(e.getParent().(PropertyPattern).getObjectPattern()) or
  exprWithoutEnclosingStmt(e.getParent().(JsxAttribute).getElement())
}

/**
 * Holds if `problem` is a string describing the fact that method `what`, which
 * is expected to have precisely one result, has `number` results, where `number`
 * is either zero or a number between two and ten.
 *
 * For example, if `what` is `"toString"` and `number` is `0`, then `problem` is
 * `"no results for toString()"`; if `number` is `3`, then `problem` is
 * `"3 results for toString()"`.
 */
predicate uniqueness_error(int number, string what, string problem) {
  what =
    [
      "toString", "getLocation", "getTopLevel", "getEnclosingStmt", "getContainer",
      "getEnclosingContainer", "getEntry", "getExit", "getFirstControlFlowNode", "getOuterScope",
      "getScopeElement", "getBaseName", "getOperator", "getTest"
    ] and
  (
    number = 0 and problem = "no results for " + what + "()"
    or
    number in [2 .. 10] and problem = number.toString() + " results for " + what + "()"
  )
}

/**
 * Holds if a contract involving the AST structure is violated, where `clsname`
 * is the QL class name of the entity violating the contract, `problem` describes
 * the violation, and `what` gives location information where possible.
 */
predicate ast_consistency(string clsname, string problem, string what) {
  exists(Locatable l | clsname = l.getAQlClass() |
    uniqueness_error(count(l.toString()), "toString", problem) and what = "at " + l.getLocation()
    or
    uniqueness_error(strictcount(l.getLocation()), "getLocation", problem) and
    what = l.getLocation().toString()
    or
    not exists(l.getLocation()) and problem = "no location" and what = l.toString()
  )
  or
  exists(AstNode nd | clsname = nd.getAQlClass() |
    uniqueness_error(count(nd.getTopLevel()), "getTopLevel", problem) and
    what = "at " + nd.getLocation()
  )
  or
  exists(Expr e | clsname = e.getAQlClass() |
    uniqueness_error(count(e.getContainer()), "getContainer", problem) and
    what = "at " + e.getLocation()
    or
    not exprWithoutEnclosingStmt(e) and
    uniqueness_error(count(e.getEnclosingStmt()), "getEnclosingStmt", problem) and
    what = "at " + e.getLocation()
  )
  or
  exists(Stmt s | clsname = s.getAQlClass() |
    uniqueness_error(count(s.getContainer()), "getContainer", problem) and
    what = "at " + s.getLocation()
  )
  or
  exists(StmtContainer cont | not cont instanceof TopLevel and clsname = cont.getAQlClass() |
    uniqueness_error(count(cont.getEnclosingContainer()), "getEnclosingContainer", problem) and
    what = "at " + cont.getLocation()
  )
  or
  exists(UnaryExpr ue | clsname = ue.getAQlClass() |
    uniqueness_error(count(ue.getOperator()), "getOperator", problem) and
    what = "at " + ue.getLocation()
  )
  or
  exists(UpdateExpr ue | clsname = ue.getAQlClass() |
    uniqueness_error(count(ue.getOperator()), "getOperator", problem) and
    what = "at " + ue.getLocation()
  )
  or
  exists(BinaryExpr be | clsname = be.getAQlClass() |
    uniqueness_error(count(be.getOperator()), "getOperator", problem) and
    what = "at " + be.getLocation()
  )
}

/**
 * Holds if a location entity of QL class `clsname` does not have a unique `toString`,
 * where `problem` describes the problem and `what` gives location information where possible.
 */
predicate location_consistency(string clsname, string problem, string what) {
  exists(Location l | clsname = l.getAQlClass() |
    uniqueness_error(count(l.toString()), "toString", problem) and what = "at " + l
    or
    not exists(l.toString()) and problem = "no toString" and what = "a location"
  )
}

/**
 * Holds if function or toplevel `sc` is expected to have an associated control flow graph.
 */
predicate hasCfg(StmtContainer sc) { not exists(Error err | err.getFile() = sc.getFile()) }

/**
 * Holds if a contract involving the CFG structure is violated, where `clsname`
 * is the QL class name of the entity violating the contract, `problem` describes
 * the violation, and `what` gives location information.
 */
predicate cfg_consistency(string clsname, string problem, string what) {
  exists(StmtContainer cont | clsname = cont.getAQlClass() and hasCfg(cont) |
    uniqueness_error(count(cont.getEntry()), "getEntry", problem) and
    what = "at " + cont.getLocation()
    or
    uniqueness_error(count(cont.getExit()), "getExit", problem) and
    what = "at " + cont.getLocation()
  )
  or
  exists(AstNode nd | clsname = nd.getAQlClass() and hasCfg(nd.getTopLevel()) |
    uniqueness_error(count(nd.getFirstControlFlowNode()), "getFirstControlFlowNode", problem) and
    what = "at " + nd.getLocation()
  )
}

/**
 * Holds if a contract involving scoping and name lookup is violated, where `clsname`
 * is the QL class name of the entity violating the contract, `problem` describes
 * the violation, and `what` gives location information.
 */
predicate scope_consistency(string clsname, string problem, string what) {
  exists(Scope s | clsname = s.getAQlClass() |
    uniqueness_error(count(s.toString()), "toString", problem) and what = "a scope"
    or
    not s instanceof GlobalScope and
    (
      uniqueness_error(count(s.getOuterScope()), "getOuterScope", problem) and what = s.toString()
      or
      uniqueness_error(count(s.getScopeElement()), "getScopeElement", problem) and
      what = s.toString()
    )
  )
  or
  exists(int n | n = count(GlobalScope g) and n != 1 |
    clsname = "GlobalScope" and what = "" and problem = n + " instances"
  )
}

/**
 * Holds if a JSDoc type expression of QL class `clsname` does not have a unique `toString`,
 * where `problem` describes the problem and `what` is the empty string.
 */
predicate jsdoc_consistency(string clsname, string problem, string what) {
  exists(JSDocTypeExprParent jsdtep | clsname = jsdtep.getAQlClass() |
    uniqueness_error(count(jsdtep.toString()), "toString", problem) and what = ""
  )
}

/**
 * Holds if a variable reference does not refer to a unique variable,
 * where `problem` describes the problem and `what` is the name of the variable.
 */
predicate varref_consistency(string clsname, string problem, string what) {
  exists(VarRef vr, int n | n = count(vr.getVariable()) and n != 1 |
    clsname = vr.getAQlClass() and
    what = vr.getName() and
    problem = n + " target variables instead of one"
  )
}

from string clsname, string problem, string what
where
  ast_consistency(clsname, problem, what) or
  location_consistency(clsname, problem, what) or
  scope_consistency(clsname, problem, what) or
  cfg_consistency(clsname, problem, what) or
  jsdoc_consistency(clsname, problem, what) or
  varref_consistency(clsname, problem, what)
select clsname + " " + what + " has " + problem
