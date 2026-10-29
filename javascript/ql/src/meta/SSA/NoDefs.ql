/**
 * @name Variable use with no corresponding SSA variable
 * @description Every reachable use of an SSA-convertible variable should correspond to
 *              exactly one SSA variable.
 * @kind problem
 * @problem.severity error
 * @id js/consistency/dead-ssa-use
 * @tags consistency
 */

import javascript

from VarUse u
where
  u.getVariable() instanceof SsaSourceVariable and
  exists(ReachableBasicBlock bb | u = bb.getANode()) and
  not exists(u.getSsaVariable())
select u, "Variable use has no corresponding SSA variable."
