import default

from BoundedType bt
where
  bt.fromSource() or
  exists(TypeAccess ta | ta.getType().(ParameterizedType).getATypeArgument() = bt)
select bt, bt.getUpperBoundType().toString()
