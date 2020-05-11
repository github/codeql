/**
 * @name Variable use with more than one corresponding SSA variable
 * @description Every reachable use of an SSA-convertible variable should correspond to
 *              exactly one SSA variable.
 * @kind problem
 * @problem.severity error
 * @id js/consistency/ambiguous-ssa-definition
 * @tags consistency
 */

import javascript

from VarUse u, int n, SsaVariable v
where
  u.getVariable() instanceof SsaSourceVariable and
  exists(ReachableBasicBlock bb | u = bb.getANode()) and
  n = count(u.getSsaVariable()) and
  n > 1 and
  v = u.getSsaVariable()
select u, "Variable use has " + n + " corresponding SSA variables: $@.", v, v.toString()
