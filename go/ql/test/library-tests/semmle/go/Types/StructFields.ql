import go

from StructTypeExpr ste, NamedType named, string name, Type tp
where
  named.getUnderlyingType() = ste.getType() and
  ste.getType().(StructType).hasField(name, tp)
select named, ste, name, tp.pp()
