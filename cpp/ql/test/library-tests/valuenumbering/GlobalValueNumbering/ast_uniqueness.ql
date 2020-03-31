import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumberingImpl

// Every expression should have exactly one GVN.
// So this query should have zero results.
from Expr e
where count(globalValueNumber(e)) != 1
select e, concat(GVN g | g = globalValueNumber(e) | g.getKind(), ", ")
