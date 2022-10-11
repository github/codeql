import java

class InstantiatedType extends ParameterizedType {
  InstantiatedType() { typeArgs(_, _, this) }
}

// This checks that all type parameter references are erased in the context of a $default function.
predicate containsTypeVariables(Type t) {
  t instanceof TypeVariable or
  containsTypeVariables(t.(InstantiatedType).getATypeArgument()) or
  containsTypeVariables(t.(NestedType).getEnclosingType()) or
  containsTypeVariables(t.(Wildcard).getATypeBound().getType())
}

from Expr e
where
  e.getEnclosingCallable().getName().matches("%$default") and
  containsTypeVariables(e.getType())
select e, e.getType()
