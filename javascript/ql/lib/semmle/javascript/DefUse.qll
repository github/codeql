/** Provides classes and predicates for working with variable definitions and uses. */

import javascript

/**
 * Holds if `def` is a CFG node that assigns the value of `rhs` to `lhs`.
 *
 * This predicate covers four kinds of definitions:
 *
 * <table border="1">
 * <tr><th>Example</th><th><code>def</code></th><th><code>lhs</code></th><th><code>rhs</code></th></tr>
 * <tr><td><code>x = y</code><td><code>x = y</code><td><code>x</code><td><code>y</code></tr>
 * <tr><td><code>var a = b</code><td><code>var a = b</code><td><code>a</code><td><code>b</code></tr>
 * <tr><td><code>function f { ... }</code><td><code>f</code><td><code>f</code><td><code>function f { ... }</code></tr>
 * <tr><td><code>function f ( x = y ){ ... }</code><td><code>x</code><td><code>x</code><td><code>y</code></tr>
 * <tr><td><code>class C { ... }</code><td><code>C</code><td><code>C</code><td><code>class C { ... }</code></tr>
 * <tr><td><code>namespace N { ... }</code><td><code>N</code><td><code>N</code><td><code>namespace N { ... }</code></tr>
 * <tr><td><code>enum E { ... }</code><td><code>E</code><td><code>E</code><td><code>enum E { ... }</code></tr>
 * <tr><td><code>import x = y</code><td><code>x</code><td><code>x</code><td><code>y</code></tr>
 * <tr><td><code>enum { x = y }</code><td><code>x</code><td><code>x</code><td><code>y</code></tr>
 * </table>
 *
 * Note that `def` and `lhs` are not in general the same: the latter
 * represents the point where `lhs` is evaluated to an assignable reference,
 * the former the point where the value of `rhs` is actually assigned
 * to that reference.
 */
private predicate defn(ControlFlowNode def, Expr lhs, AST::ValueNode rhs) {
  exists(AssignExpr assgn | def = assgn | lhs = assgn.getTarget() and rhs = assgn.getRhs())
  or
  exists(VariableDeclarator vd | def = vd | lhs = vd.getBindingPattern() and rhs = vd.getInit())
  or
  exists(Function f | def = f.getIdentifier() | lhs = def and rhs = f)
  or
  exists(ClassDefinition c | lhs = c.getIdentifier() | def = c and rhs = c and not c.isAmbient())
  or
  exists(NamespaceDeclaration n | def = n | lhs = n.getIdentifier() and rhs = n)
  or
  exists(EnumDeclaration ed | def = ed.getIdentifier() | lhs = def and rhs = ed)
  or
  exists(ImportEqualsDeclaration i | def = i |
    lhs = i.getIdentifier() and rhs = i.getImportedEntity()
  )
  or
  exists(ImportSpecifier i | def = i and not i.isTypeOnly() | lhs = i.getLocal() and rhs = i)
  or
  exists(EnumMember member | def = member.getIdentifier() |
    lhs = def and rhs = member.getInitializer()
  )
}

/**
 * Holds if `def` is a CFG node that assigns to `lhs`.
 *
 * This predicate extends the three-argument version of `defn` to also cover definitions
 * where there is no explicit right hand side:
 *
 * <table border="1">
 * <tr><th>Example</th><th><code>def</code></th><th><code>lhs</code></th></tr>
 * <tr><td><code>x += y</code><td><code>x += y</code><td><code>x</code></tr>
 * <tr><td><code>++z.q</code><td><code>++z.q</code><td><code>z.q</code></tr>
 * <tr><td><code>import { a as b } from 'm'</code><td><code>a as b</code><td><code>b</code></tr>
 * <tr><td><code>for (var p in o) ...</code><td><code>var p</code><td><code>p</code></tr>
 * <tr><td><code>enum { x  }</code><td><code>x</code><td><code>x</code></tr>
 * </table>
 *
 * Additionally, parameters are also considered definitions, which are their own `lhs`.
 */
private predicate defn(ControlFlowNode def, Expr lhs) {
  defn(def, lhs, _)
  or
  lhs = def.(CompoundAssignExpr).getTarget()
  or
  lhs = def.(UpdateExpr).getOperand().getUnderlyingReference()
  or
  exists(EnhancedForLoop efl | def = efl.getIteratorExpr() |
    lhs = def.(Expr).stripParens() or
    lhs = def.(VariableDeclarator).getBindingPattern()
  )
  or
  lhs = def and
  (
    def instanceof Parameter or
    def = any(ComprehensionBlock cb).getIterator()
  )
  or
  exists(EnumMember member | def = member.getIdentifier() |
    lhs = def and not exists(member.getInitializer())
  )
}

/**
 * Holds if `l` is one of the lvalues in the assignment `def`, or
 * a destructuring pattern that contains some of the lvalues.
 *
 * For example, if `def` is `[{ x: y }] = e`, then `l` can be any
 * of `y`, `{ x: y }` and `[{ x: y }]`.
 */
private predicate lvalAux(Expr l, ControlFlowNode def) {
  defn(def, l)
  or
  exists(ArrayPattern ap | lvalAux(ap, def) | l = ap.getAnElement().stripParens())
  or
  exists(ObjectPattern op | lvalAux(op, def) |
    l = op.getAPropertyPattern().getValuePattern().stripParens() or
    l = op.getRest().stripParens()
  )
}

/**
 * An expression that can be evaluated to a reference, that is,
 * a variable reference or a property access.
 */
class RefExpr extends Expr {
  RefExpr() {
    this instanceof VarRef or
    this instanceof PropAccess
  }
}

/**
 * A variable reference or property access that is written to.
 *
 * For instance, in the assignment `x.p = x.q`, `x.p` is written to
 * and `x.q` is not; in the expression `++i`, `i` is written to
 * (and also read from).
 */
class LValue extends RefExpr {
  LValue() { lvalAux(this, _) }

  /** Gets the definition in which this lvalue occurs. */
  ControlFlowNode getDefNode() { lvalAux(this, result) }

  /** Gets the source of the assignment. */
  AST::ValueNode getRhs() { defn(_, this, result) }
}

/**
 * A variable reference or property access that is read from.
 *
 * For instance, in the assignment `x.p = x.q`, `x.q` is read from
 * and `x.p` is not; in the expression `++i`, `i` is read from
 * (and also written to).
 */
class RValue extends RefExpr {
  RValue() {
    not this instanceof LValue and not this instanceof VarDecl
    or
    // in `x++` and `x += 1`, `x` is both RValue and LValue
    this = any(CompoundAssignExpr a).getTarget()
    or
    this = any(UpdateExpr u).getOperand().getUnderlyingReference()
    or
    this = any(NamespaceDeclaration decl).getIdentifier()
  }
}

/**
 * A ControlFlowNode that defines (that is, initializes or updates) variables or properties.
 *
 * The following program elements are definitions:
 *
 * - assignment expressions (`x = 42`)
 * - update expressions (`++x`)
 * - variable declarators with an initializer (`var x = 42`)
 * - for-in and for-of statements (`for (x in o) { ... }`)
 * - parameters of functions or catch clauses (`function (x) { ... }`)
 * - named functions (`function x() { ... }`)
 * - named classes (`class x { ... }`)
 * - import specifiers (`import { x } from 'm'`)
 *
 * Note that due to destructuring, a single `VarDef` may define multiple
 * variables and/or properties; for example, `{ x, y: z.p } = e` defines variable
 * `x` as well as property `p` of `z`.
 */
class VarDef extends ControlFlowNode {
  VarDef() { defn(this, _) }

  /**
   * Gets the target of this definition, which is either a simple variable
   * reference, a destructuring pattern, or a property access.
   */
  Expr getTarget() { defn(this, result) }

  /** Gets a variable defined by this node, if any. */
  Variable getAVariable() { result = this.getTarget().(BindingPattern).getAVariable() }

  /**
   * Gets the source of this definition, that is, the data flow node representing
   * the value that this definition assigns to its target.
   *
   * This predicate is not defined for `VarDef`s where the source is implicit,
   * such as `for-in` loops, parameters or destructuring assignments.
   */
  AST::ValueNode getSource() {
    exists(Expr target | not target instanceof DestructuringPattern and defn(this, target, result))
  }

  /**
   * Gets the source that this definition destructs, that is, the
   * right hand side of a destructuring assignment.
   */
  AST::ValueNode getDestructuringSource() {
    exists(Expr target | target instanceof DestructuringPattern and defn(this, target, result))
  }

  /**
   * Holds if this definition of `v` is overwritten by another definition, that is,
   * another definition of `v` is reachable from it in the CFG.
   */
  predicate isOverwritten(Variable v) {
    exists(BasicBlock bb, int i | bb.defAt(i, v, this) |
      exists(int j | bb.defAt(j, v, _) and j > i)
      or
      bb.getASuccessor+().defAt(_, v, _)
    )
  }
}

/**
 * A ControlFlowNode that uses (that is, reads from) a single variable.
 *
 * Some variable definitions are also uses, notably the operands of update expressions.
 */
class VarUse extends ControlFlowNode, @varref instanceof RValue {
  /** Gets the variable this use refers to. */
  Variable getVariable() { result = this.(VarRef).getVariable() }

  /**
   * Gets a definition that may reach this use.
   *
   * For global variables, each definition is considered to reach each use.
   */
  VarDef getADef() {
    result = this.getSsaVariable().getDefinition().getAContributingVarDef() or
    result.getAVariable() = this.getVariable().(GlobalVariable)
  }

  /**
   * Gets the unique SSA variable this use refers to.
   *
   * This predicate is only defined for variables that can be SSA-converted.
   */
  SsaVariable getSsaVariable() { result.getAUse() = this }
}
