/**
 * @name RangeSsa phi-node inputs test
 * @description List all the inputs for each SSA phi-node
 * @kind test
 */

import cpp
import semmle.code.cpp.rangeanalysis.RangeSSA

from RangeSsaDefinition phi, StackVariable var, RangeSsaDefinition input, int philine, int inputline
where
  phi.getAPhiInput(var) = input and
  philine = phi.getLocation().getStartLine() and
  inputline = input.getLocation().getStartLine()
select philine, phi.toString(var), inputline, input.toString(var)
