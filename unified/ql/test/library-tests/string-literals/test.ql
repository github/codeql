import unified

from StringLiteral literal
where
  literal.getFile().getRelativePath() = "test.swift" and
  not literal.getParent() instanceof StringInterpolationExpr
select literal, literal.getStringValue()
