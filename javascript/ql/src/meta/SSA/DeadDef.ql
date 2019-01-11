/**
 * @name Dead SSA definition
 * @description Each SSA definition should have at least one use.
 * @kind problem
 * @problem.severity error
 * @id js/sanity/dead-ssa-definition
 * @tags sanity
 */

import javascript

from SsaVariable d
where
  not exists(d.getAUse()) and
  not d = any(SsaPseudoDefinition phi).getAnInput() and
  d.getSourceVariable() instanceof PurelyLocalVariable
select d, "Dead SSA definition " + d + "."
