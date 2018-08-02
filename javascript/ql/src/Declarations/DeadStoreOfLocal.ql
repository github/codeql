/**
 * @name Useless assignment to local variable
 * @description An assignment to a local variable that is not used later on, or whose value is always
 *              overwritten, has no effect.
 * @kind problem
 * @problem.severity warning
 * @id js/useless-assignment-to-local
 * @tags maintainability
 *       external/cwe/cwe-563
 * @precision very-high
 */

import javascript

/**
 * Holds if `vd` is a definition of variable `v` that is dead, that is,
 * the value it assigns to `v` is not read.
 */
predicate deadStoreOfLocal(VarDef vd, PurelyLocalVariable v) {
  v = vd.getAVariable() and
  exists (vd.getSource()) and
  // the definition is not in dead code
  exists (ReachableBasicBlock rbb | vd = rbb.getANode()) and
  // but it has no associated SSA definition, that is, it is dead
  not exists (SsaExplicitDefinition ssa | ssa.defines(vd, v))
}

/**
 * Holds if `e` is an expression evaluating to `null` or `undefined`.
 *
 * This includes not only direct references to `null` and `undefined`, but
 * also `void` expressions and assignments of the form `x = rhs`, where `rhs`
 * is itself an expression evaluating to `null` or `undefined`.
 */
predicate isNullOrUndef(Expr e) {
  // `null` or `undefined`
  e instanceof NullLiteral or
  e.(VarAccess).getName() = "undefined" or
  e instanceof VoidExpr or
  // recursive case to catch multi-assignments of the form `x = y = null`
  isNullOrUndef(e.(AssignExpr).getRhs())
}

/**
 * Holds if `e` is an expression that may be used as a default initial value,
 * such as `0` or `-1`, or an empty object or array literal.
 */
predicate isDefaultInit(Expr e) {
  // primitive default values: zero, false, empty string, and (integer) -1
  e.(NumberLiteral).getValue().toFloat() = 0.0 or
  e.(NegExpr).getOperand().(NumberLiteral).getValue() = "1" or
  e.(ConstantString).getStringValue() = "" or
  e.(BooleanLiteral).getValue() = "false" or
  // initialising to an empty array or object literal, even if unnecessary,
  // can convey useful type information to the reader
  e.(ArrayExpr).getSize() = 0 or
  e.(ObjectExpr).getNumProperty() = 0 or
  // recursive case
  isDefaultInit(e.(AssignExpr).getRhs())
}

from VarDef dead, PurelyLocalVariable v  // captured variables may be read by closures, so don't flag them
where deadStoreOfLocal(dead, v) and
      // the variable should be accessed somewhere; otherwise it will be flagged by UnusedVariable
      exists(v.getAnAccess()) and
      // don't flag ambient variable definitions
      not dead.(ASTNode).isAmbient() and
      // don't flag function expressions
      not exists (FunctionExpr fe | dead = fe.getId()) and
      // don't flag function declarations nested inside blocks or other compound statements;
      // their meaning is only partially specified by the standard
      not exists (FunctionDeclStmt fd, StmtContainer outer |
        dead = fd.getId() and outer = fd.getEnclosingContainer() |
        not fd = outer.getBody().(BlockStmt).getAStmt()
      ) and
      // don't flag overwrites with `null` or `undefined`
      not isNullOrUndef(dead.getSource()) and
      // don't flag default inits that are later overwritten
      not (isDefaultInit(dead.getSource()) and dead.isOverwritten(v)) and
      // don't flag assignments in externs
      not dead.(ASTNode).inExternsFile() and
      // don't flag exported variables
      not any(ES2015Module m).exportsAs(v, _)
select dead, "This definition of " + v.getName() + " is useless, since its value is never read."
