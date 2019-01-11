private import semmle.javascript.dataflow.Refinements

from Refinement ref, RefinementContext ctxt
select ref, ctxt, ref.eval(ctxt)
