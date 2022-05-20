private import semmle.javascript.dataflow.Refinements

from Refinement r
where r.getParent() instanceof ExprStmt
select r
