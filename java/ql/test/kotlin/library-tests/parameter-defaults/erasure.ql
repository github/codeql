import java

class InstantiatedType extends ParameterizedType {
  InstantiatedType() { typeArgs(_, _, this) }
}

// This checks that all type parameter references are erased in the context of a $default function.
// Note this is currently expected to fail since for the time being we extract type variable references
// even where they should be out of scope.
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
