// Regression tests for ODASA-4753 and ODASA-4762.
import cpp

from ControlFlowNode x
select x, x.getATrueSuccessor()
