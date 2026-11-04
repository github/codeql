import unified

from StringLiteral literal
where not literal.getParent() instanceof StringInterpolationExpr
select literal, literal.getStringValue()
