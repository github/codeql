/**
 * @name Phi node without inputs
 * @description Every SSA phi node should have two or more inputs.
 * @kind problem
 * @problem.severity error
 * @id js/sanity/dead-phi-node
 * @tags sanity
 */

import javascript

from SsaPhiNode phi
where not exists(phi.getAnInput())
select phi, "Phi node without inputs."
