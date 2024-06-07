/**
 * Provides classes and predicates for SSA representation (Static Single Assignment form).
 */

import cpp
import semmle.code.cpp.controlflow.Dominance
import SSAUtils

/**
 * The SSA logic comes in two versions: the standard SSA and range-analysis RangeSSA.
 * This class provides the standard SSA logic.
 */
class StandardSsa extends SsaHelper {
  StandardSsa() { this = 0 }
}

/**
 * A definition of one or more SSA variables, including phi node definitions.
 * An _SSA variable_, as defined in the literature, is effectively the pair of
 * an `SsaDefinition d` and a `StackVariable v`, written `(d, v)` in this
 * documentation. Note that definitions and uses can be coincident due to the
 * presence of parameter definitions and phi nodes.
 *
 * Not all `StackVariable`s of a function have SSA definitions. If the variable
 * has its address taken, either explicitly or implicitly, then it is excluded
 * from analysis. `SsaDefinition`s are not generated in locations that are
 * statically seen to be unreachable.
 */
class SsaDefinition extends ControlFlowNodeBase {
  SsaDefinition() { exists(StandardSsa x | x.ssa_defn(_, this, _, _)) }

  /**
   * Gets a variable corresponding to an SSA StackVariable defined by
   * this definition.
   */
  StackVariable getAVariable() { exists(StandardSsa x | x.ssa_defn(result, this, _, _)) }

  /**
   * Gets a string representation of the SSA variable represented by the pair
   * `(this, v)`.
   */
  string toString(StackVariable v) { exists(StandardSsa x | result = x.toString(this, v)) }

  /** Gets a use of the SSA variable represented by the pair `(this, v)`. */
  VariableAccess getAUse(StackVariable v) { exists(StandardSsa x | result = x.getAUse(this, v)) }

  /**
   * Gets the control-flow node for this definition. This will usually be the
   * control-flow node that assigns to this variable as a side effect, but
   * there are some exceptions. If `this` is defined by initialization, the
   * result is the value of `Initializer.getExpr()` for that initialization.
   * If `this` is a function parameter (see `definedByParameter`), the result
   * will be the function entry point. If `this` variable is defined by being
   * passed as a reference in a function call, including overloaded
   * operators, the result will be the `VariableAccess` expression for this
   * parameter. If `this` is a phi node (see `isPhiNode`), the result will be
   * the node where control flow is joined from multiple paths.
   */
  ControlFlowNode getDefinition() { result = this }

  /** Gets the `BasicBlock` containing this definition. */
  BasicBlock getBasicBlock() { result.contains(this.getDefinition()) }

  /** Holds if this definition is a phi node for variable `v`. */
  predicate isPhiNode(StackVariable v) { exists(StandardSsa x | x.phi_node(v, this)) }

  /** Gets the location of this definition. */
  Location getLocation() { result = this.(ControlFlowNode).getLocation() }

  /** Holds if the SSA variable `(this, p)` is defined by parameter `p`. */
  predicate definedByParameter(Parameter p) { this = p.getFunction().getEntryPoint() }

  /**
   * Holds if the SSA variable `(result, v)` is an input to the phi definition
   * `(this, v)`.
   */
  SsaDefinition getAPhiInput(StackVariable v) {
    this.isPhiNode(v) and
    result.reachesEndOfBB(v, this.(BasicBlock).getAPredecessor())
  }

  /**
   * Gets the expression assigned to the SSA variable `(this, v)`, if any,
   * when it is not a phi definition. The following is an exhaustive list of
   * expressions that may be the result of this predicate.
   *
   * - The contained expression of an `Initializer`.
   * - The right-hand side of an `AssignExpr`.
   * - An `AssignOperation`.
   * - A `CrementOperation`.
   *
   * In all cases except `PostfixCrementOperation`, the variable `v` will be
   * equal to the result of this predicate after evaluation of
   * `this.getDefinition()`.
   *
   * If the SSA variable is defined in other ways than those four (such as
   * function parameters or `f(&x)`) there is no result. These cases are
   * instead covered via `definedByParameter` and `getDefinition`,
   * respectively.
   */
  Expr getDefiningValue(StackVariable v) {
    exists(ControlFlowNode def | def = this.getDefinition() |
      def = v.getInitializer().getExpr() and def = result
      or
      exists(AssignExpr assign |
        def = assign and
        assign.getLValue() = v.getAnAccess() and
        result = assign.getRValue()
      )
      or
      exists(AssignOperation assign |
        def = assign and
        assign.getLValue() = v.getAnAccess() and
        result = assign
      )
      or
      exists(CrementOperation crement |
        def = crement and
        crement.getOperand() = v.getAnAccess() and
        result = crement
      )
    )
  }

  /** Holds if `(this, v)` reaches the end of basic block `b`. */
  predicate reachesEndOfBB(StackVariable v, BasicBlock b) {
    exists(StandardSsa x | x.ssaDefinitionReachesEndOfBB(v, this, b))
  }

  /**
   * Gets a definition that ultimately defines this variable and is not
   * itself a phi node.
   */
  SsaDefinition getAnUltimateSsaDefinition(StackVariable v) {
    result = this.getAPhiInput(v).getAnUltimateSsaDefinition(v)
    or
    v = this.getAVariable() and
    not this.isPhiNode(v) and
    result = this
  }

  /**
   * Gets a possible defining expression for `v` at this SSA definition,
   * recursing backwards through phi definitions. Not all definitions have a
   * defining expression---see the documentation for `getDefiningValue`.
   */
  Expr getAnUltimateDefiningValue(StackVariable v) {
    result = this.getAnUltimateSsaDefinition(v).getDefiningValue(v)
  }
}
