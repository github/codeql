/**
 * @name Dead SSA definition
 * @description Each SSA definition should have at least one use.
 * @kind problem
 * @problem.severity error
 * @id js/consistency/dead-ssa-definition
 * @tags consistency
 */

import javascript

from SsaVariable d
where
  not exists(d.getAUse()) and
  not d = any(SsaPseudoDefinition phi).getAnInput() and
  d.getSourceVariable() instanceof PurelyLocalVariable
select d, "Dead SSA definition " + d + "."
