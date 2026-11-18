import codeql.rust.elements

from BinaryExpr expr
where expr.getAnAttr() instanceof Attr
select expr, expr.getAnAttr()
