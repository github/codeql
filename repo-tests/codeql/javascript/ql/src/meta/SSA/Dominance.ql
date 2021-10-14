/**
 * @name SSA definition does not dominate use
 * @description Every use of an SSA variable should be dominated by its
 *              definition.
 * @kind problem
 * @problem.severity error
 * @id js/consistency/non-dominating-ssa-definition
 * @tags consistency
 */

import javascript

/**
 * Holds if SSA definition `def` dominates `use`,
 * which is a use of the same variable.
 */
predicate dominates(SsaDefinition def, VarUse use) {
  exists(
    SsaSourceVariable v, ReachableBasicBlock defbb, int defidx, ReachableBasicBlock usebb,
    int useidx
  |
    def.definesAt(defbb, defidx, v) and usebb.useAt(useidx, v, use)
  |
    defbb = usebb and defidx <= useidx
    or
    defbb.strictlyDominates(usebb)
  )
}

from VarUse u, SsaDefinition d
where
  u.getVariable() instanceof SsaSourceVariable and
  exists(ReachableBasicBlock bb | u = bb.getANode()) and
  u = d.getVariable().getAUse() and
  not dominates(d, u)
select u, "Variable use is not dominated by its definition $@.", d, d.toString()
