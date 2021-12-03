import default

from Wildcard w
where exists(TypeAccess ta | ta.getType().(ParameterizedType).getATypeArgument() = w)
select w, w.getLowerBoundType().toString()
