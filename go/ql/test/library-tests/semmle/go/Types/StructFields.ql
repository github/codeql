import go

from StructTypeExpr ste, DefinedType defined, string name, Type tp
where
  defined.getUnderlyingType() = ste.getType() and
  ste.getType().(StructType).hasField(name, tp)
select defined, ste, name, tp.pp()
