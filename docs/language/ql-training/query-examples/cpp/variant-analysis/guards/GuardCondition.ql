import cpp
import semmle.code.cpp.controlflow.Guards

from ArrayExpr ae
where not exists(GuardCondition gc | gc.controls(ae.getBasicBlock(), true))
select ae