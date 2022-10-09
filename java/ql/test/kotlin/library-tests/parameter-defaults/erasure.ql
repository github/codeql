import java

// This checks that all type parameter references are erased in the context of a $default function.
predicate containsTypeVariables(Type t) {
  t != t.getErasure() and
  not t.getErasure().(GenericType).getRawType() = t
}

from Expr e
where
  e.getEnclosingCallable().getName().matches("%$default") and
  containsTypeVariables(e.getType())
select e, e.getType()
