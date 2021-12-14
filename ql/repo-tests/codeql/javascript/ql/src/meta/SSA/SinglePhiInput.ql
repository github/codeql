/**
 * @name Phi node with a single input
 * @description Every SSA phi node should have two or more inputs.
 * @kind problem
 * @problem.severity error
 * @id js/consistency/trivial-phi-node
 * @tags consistency
 */

import javascript

from SsaPhiNode phi
where count(phi.getAnInput()) = 1
select phi, "Phi node with exactly one input $@.", phi.getAnInput(), phi.getAnInput().toString()
