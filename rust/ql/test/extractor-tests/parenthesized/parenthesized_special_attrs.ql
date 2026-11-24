import codeql.rust.elements

from Expr expr, AnyAttr attr
where
  exists(MacroExpr macro | expr = macro and macro.getAnAttr() = attr)
  or
  exists(StructExpr struct | expr = struct and struct.getAnAttr() = attr)
select expr, attr
