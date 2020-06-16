import javascript

from ConstantExpr c
select c

query int getIntValue(Expr e) { result = e.getIntValue() }

query float getFloatValue(NumberLiteral e) { result = e.getFloatValue() }

query string getLiteralValue(Literal lit) { result = lit.getValue() }
