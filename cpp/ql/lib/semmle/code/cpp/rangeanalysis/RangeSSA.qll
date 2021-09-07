/**
 * This library is a clone of semmle.code.cpp.controlflow.SSA, with
 * only one difference: extra phi definitions are added after
 * guards. For example:
 * ```
 *     x = f();
 *     if (x < 10) {
 *       // Block 1
 *       ...
 *     } else {
 *       // Block 2
 *       ...
 *     }
 * ```
 * In standard SSA, basic blocks 1 and 2 do not need phi definitions
 * for `x`, because they are dominated by the definition of `x` on the
 * first line.  In RangeSSA, however, we add phi definitions for `x` at
 * the beginning of blocks 1 and 2. This is useful for range analysis
 * because it enables us to deduce a more accurate range for `x` in the
 * two branches of the if-statement.
 */

import cpp
import semmle.code.cpp.controlflow.Dominance
import semmle.code.cpp.controlflow.SSAUtils
private import RangeAnalysisUtils

/**
 * The SSA logic comes in two versions: the standard SSA and range-analysis RangeSSA.
 * This class provides the range-analysis SSA logic.
 */
library class RangeSSA extends SSAHelper {
  RangeSSA() { this = 1 }

  /**
   * Add a phi node on the out-edge of a guard.
   */
  override predicate custom_phi_node(StackVariable v, BasicBlock b) {
    guard_defn(v.getAnAccess(), _, b, _)
  }
}

private predicate guard_defn(VariableAccess v, Expr guard, BasicBlock b, boolean branch) {
  guardCondition(guard, v, branch) and
  guardSuccessor(guard, branch, b)
}

private predicate guardCondition(Expr guard, VariableAccess v, boolean branch) {
  exists(Expr lhs | linearAccess(lhs, v, _, _) |
    relOpWithSwapAndNegate(guard, lhs, _, _, _, branch) or
    eqOpWithSwapAndNegate(guard, lhs, _, _, branch) or
    eqZeroWithNegate(guard, lhs, _, branch)
  )
}

private predicate guardSuccessor(Expr guard, boolean branch, BasicBlock succ) {
  branch = true and succ = guard.getATrueSuccessor()
  or
  branch = false and succ = guard.getAFalseSuccessor()
}

/**
 * A definition of one or more SSA variables, including phi node
 * definitions.  An SSA variable is effectively the pair of a definition
 * and the (non-SSA) variable that it defines.  Note definitions and uses
 * can be coincident, due to the presence of parameter definitions and phi
 * nodes.
 */
class RangeSsaDefinition extends ControlFlowNodeBase {
  RangeSsaDefinition() { exists(RangeSSA x | x.ssa_defn(_, this, _, _)) }

  /**
   * Gets a variable corresponding to a SSA StackVariable defined by
   * this definition.
   */
  StackVariable getAVariable() { exists(RangeSSA x | x.ssa_defn(result, this, _, _)) }

  /**
   * A string representation of the SSA variable represented by the pair
   * `(this, v)`.
   */
  string toString(StackVariable v) { exists(RangeSSA x | result = x.toString(this, v)) }

  /** Gets a use of the SSA variable represented by the pair `(this, v)`. */
  VariableAccess getAUse(StackVariable v) { exists(RangeSSA x | result = x.getAUse(this, v)) }

  /** Gets the control flow node for this definition. */
  ControlFlowNode getDefinition() { result = this }

  /** Gets the basic block containing this definition. */
  BasicBlock getBasicBlock() { result.contains(getDefinition()) }

  /** Whether this definition is a phi node for variable `v`. */
  predicate isPhiNode(StackVariable v) { exists(RangeSSA x | x.phi_node(v, this.(BasicBlock))) }

  /**
   * If this definition is a phi node corresponding to a guard,
   * then return the variable and the guard.
   */
  predicate isGuardPhi(VariableAccess v, Expr guard, boolean branch) {
    guard_defn(v, guard, this, branch)
  }

  /** Gets the primary location of this definition. */
  Location getLocation() { result = this.(ControlFlowNode).getLocation() }

  /** Whether this definition is from a parameter */
  predicate definedByParameter(Parameter p) { this = p.getFunction().getEntryPoint() }

  /** Gets a definition of `v` that is a phi input for this basic block. */
  RangeSsaDefinition getAPhiInput(StackVariable v) {
    this.isPhiNode(v) and
    exists(BasicBlock pred |
      pred = this.(BasicBlock).getAPredecessor() and
      result.reachesEndOfBB(v, pred) and
      // Suppose we have a CFG like this:
      //
      //    1:    x_0 = <expr>;
      //    2:    if (<cond>) {
      //    3:       if (x_0 > 1) {
      //    4:          x_1 = phi(x_0);
      //    5:       }
      //    6:    }
      //    7:    x_2 = phi(x_0, x_1);
      //
      // The phi nodes on lines 4 and 7 are both guard phi nodes,
      // because they have an incoming edge from the condition on
      // line 3. Definition x_0 on line 1 should be considered a
      // phi-input on line 7, but not on line 4. This is because
      // the only CFG path from line 1 to line 4 goes through the
      // condition on line 3, but there is a path from line 1 to
      // line 7 which does not go through the condition. The logic
      // below excludes definitions which can only reach guard phi
      // nodes by going through the corresponding guard.
      not exists(VariableAccess access |
        v = access.getTarget() and
        pred.contains(access) and
        this.isGuardPhi(access, _, _)
      )
    )
  }

  /** Gets the expression assigned to this SsaDefinition. */
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
    )
  }

  /**
   * Holds if this definition of the variable `v` reached the end of the basic block `b`.
   */
  predicate reachesEndOfBB(StackVariable v, BasicBlock b) {
    exists(RangeSSA x | x.ssaDefinitionReachesEndOfBB(v, this, b))
  }
}
