/**
 * @name Ssa phi-node inputs test
 * @description List all the inputs for each SSA phi-node
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.SSA

from
  File file, SsaDefinition phi, StackVariable var, SsaDefinition input, int philine, int inputline
where
  phi.getAPhiInput(var) = input and
  file = phi.getLocation().getFile() and
  philine = phi.getLocation().getStartLine() and
  inputline = input.getLocation().getStartLine()
select file.getAbsolutePath(), philine, phi.toString(var), inputline, input.toString(var)
