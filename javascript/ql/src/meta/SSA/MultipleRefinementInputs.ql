/**
 * @name Refinement node with more than one input
 * @description Every SSA refinement node should have exactly one input.
 * @kind problem
 * @problem.severity error
 * @id js/sanity/ambiguous-refinement-node
 * @tags sanity
 */

import javascript

from SsaRefinementNode ref, int n, SsaDefinition input
where
  n = count(ref.getAnInput()) and
  n > 1 and
  input = ref.getAnInput()
select ref, "Refinement node has " + n + " inputs: $@.", input, input.toString()
