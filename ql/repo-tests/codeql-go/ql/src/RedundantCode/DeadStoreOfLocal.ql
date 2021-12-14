/**
 * @name Useless assignment to local variable
 * @description An assignment to a local variable that is not used later on, or whose value is always
 *              overwritten, has no effect.
 * @kind problem
 * @problem.severity warning
 * @id go/useless-assignment-to-local
 * @tags maintainability
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
  nd instanceof IR::ReadArgumentInstruction
}

from IR::Instruction def, SsaSourceVariable target, IR::Instruction rhs
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
  not target.mayHaveIndirectReferences()
select def, "This definition of " + target + " is never used."
