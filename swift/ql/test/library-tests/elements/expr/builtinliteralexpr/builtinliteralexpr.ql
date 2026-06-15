import swift

from BuiltinLiteralExpr e
where e.getFile().getBaseName() != ""
select e, concat(e.getValueString(), "")
