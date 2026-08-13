/**
 * @name Useless assignment to local variable
 * @description An assignment to a local variable that is not used later on, or whose value is always
 *              overwritten, has no effect.
 * @kind problem
 * @problem.severity warning
 * @id go/useless-assignment-to-local
 * @tags quality
 *       maintainability
 *       useless-code
 *       external/cwe/cwe-563
 * @precision very-high
 */

import go

/** Holds if `nd` is an initializer that we do not want to flag for this query. */
predicate isSimple(IR::Instruction nd) {
  exists(Expr e |
    e.isConst() or
    e.(CompositeLit).getNumElement() = 0
  |
    nd = IR::evalExprInstruction(e)
  )
  or
  nd = IR::implicitInitInstruction(_)
  or
  // don't flag parameters
  nd instanceof IR::InitParameterInstruction
}

from IR::WriteInstruction def, SsaSourceVariable target, IR::Instruction rhs, Expr lhs
where
  def.writes(target, rhs) and
  not exists(SsaExplicitDefinition ssa | ssa.getInstruction() = def) and
  // exclude assignments in dead code
  def.getBasicBlock() instanceof ReachableBasicBlock and
  // exclude assignments with default values or simple expressions
  not isSimple(rhs) and
  // exclude variables that are not used at all
  exists(target.getAReference()) and
  // exclude variables with indirect references
  not target.mayHaveIndirectReferences() and
  // Report the assigned variable rather than the whole write instruction. A write to an
  // `SsaSourceVariable` that survives the `SsaExplicitDefinition` exclusion above always has an
  // explicit left-hand side expression (writes without one, such as result-variable writes at a
  // `return`, are `SsaExplicitDefinition`s and so are already excluded), so this does not drop
  // any results.
  lhs = def.getLhs().getExpr()
select lhs, "This definition of " + target + " is never used."
