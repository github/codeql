/**
 * Computes scopes in which it is safe to unify all uses of a given variable.
 *
 * It is not accurate to unify variables across a disjunction, so the scope of a variable
 * is restricted to its nearest enclosing disjunction operand ("disjunct").
 * At such a disjunct, we introduce a "refinement" of the variable, which is seen as a
 * redefinition of the variable within that disjunct.
 *
 * In principle this should also be done for `this`, `result`, and local field variables
 * but currently it is not.
 */

private import codeql_ql.ast.Ast
private import codeql_ql.ast.internal.AstNodeNumbering

/** Gets the disjunction immediately containing another disjunction `inner`. */
private Disjunction getOuterDisjunction(Disjunction inner) { result.getAnOperand() = inner }

/**
 * Get the root of a disjunction tree containing `f`, if any.
 */
private Disjunction getRootDisjunction(Disjunction f) {
  not exists(getOuterDisjunction(result)) and
  result = getOuterDisjunction(f)
  or
  result = getRootDisjunction(getOuterDisjunction(f))
}

/** Get the root disjunction for `f` if there is one, other gets `f` itself. */
pragma[inline]
private AstNode tryGetRootDisjunction(AstNode f) {
  result = getRootDisjunction(f)
  or
  not exists(getRootDisjunction(f)) and
  result = f
}

AstNode getADisjunctionOperand(AstNode disjunction) {
  exists(Disjunction d |
    result = d.getAnOperand() and
    // skip intermediate nodes in large disjunctions
    disjunction = tryGetRootDisjunction(d) and
    not result instanceof Disjunction
  )
  or
  result = disjunction.(Implication).getAChild()
  or
  result = disjunction.(IfFormula).getThenPart()
  or
  result = disjunction.(IfFormula).getElsePart()
  or
  exists(Forall all |
    disjunction = all and
    exists(all.getFormula()) and
    exists(all.getRange()) and
    result = [all.getRange(), all.getFormula()]
  )
  or
  result = disjunction.(Set).getAnElement()
}

/**
 * A node that acts as a disjunction:
 * - The root in a tree of `or` operators, or
 * - An `implies`, `if`, `forall`, or set literal.
 */
class DisjunctionOperator extends AstNode {
  DisjunctionOperator() { exists(getADisjunctionOperand(this)) }

  AstNode getAnOperand() { result = getADisjunctionOperand(this) }
}

/**
 * Gets the scope of `var`, such as the predicate or `exists` clause that binds it.
 */
AstNode getVarDefScope(VarDef var) {
  // TODO: not valid for `as` expressions
  result = var.getParent()
}

/** A `VarAccess` or disjunct, representing the input to refinement of a variable. */
class VarAccessOrDisjunct = AstNode;

/**
 * Walks upwards from an access to `varDef` until encountering either the scope of `varDef`
 * or a disjunct. When a disjunct is found, the disjunct becomes the new `access`, representing
 * a refinement we intend to insert there.
 */
private AstNode getVarScope(VarDef varDef, VarAccessOrDisjunct access) {
  access.(VarAccess).getDeclaration() = varDef and
  result = access
  or
  exists(AstNode scope | scope = getVarScope(varDef, access) |
    not scope = getADisjunctionOperand(_) and
    not scope = getVarDefScope(varDef) and
    result = scope.getParent()
  )
  or
  isRefinement(varDef, _, access) and
  result = tryGetRootDisjunction(access.getParent())
}

/**
 * Holds if `inner` should be seen as a refinement of `outer`.
 *
 * `outer` is always a disjunct, and `inner` is either a `VarAccess` or another disjunct.
 */
predicate isRefinement(VarDef varDef, VarAccessOrDisjunct inner, VarAccessOrDisjunct outer) {
  getVarScope(varDef, inner) = outer and
  (
    outer = getADisjunctionOperand(_)
    or
    outer = getVarDefScope(varDef)
  )
}
