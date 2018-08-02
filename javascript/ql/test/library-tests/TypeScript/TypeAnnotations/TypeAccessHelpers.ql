import javascript

from TypeAccess type, int n
where type.hasTypeArguments()
select type, type.getNumTypeArgument(), n, type.getTypeArgument(n)
