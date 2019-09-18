/**
 * @name A phi node without two or more inputs
 * @description A phi node should have at least two inputs.
 * @kind problem
 * @problem.severity error
 * @id java/sanity/too-few-phi-inputs
 * @tags sanity
 */

import java
import semmle.code.java.dataflow.SSA

from SsaPhiNode phi, int inputs
where
  inputs = count(SsaVariable v | v = phi.getAPhiInput()) and
  inputs < 2
select phi, "Phi node for " + phi.getSourceVariable() + " has only " + inputs + " inputs."
