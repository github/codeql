import go

from TypeSpec ts, string kind
where if ts instanceof AliasSpec then kind = "alias" else kind = "def"
select ts, ts.getName(), ts.getDeclaredType().pp(), ts.getTypeExpr(), ts.getRhsType().pp(), kind
