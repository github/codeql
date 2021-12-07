/**
 * @name Inconsistent compareTo
 * @description If a class overrides 'compareTo' but not 'equals', it may mean that 'compareTo'
 *              and 'equals' are inconsistent.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/inconsistent-compareto-and-equals
 * @tags reliability
 *       correctness
 */

import java
import semmle.code.java.frameworks.Lombok

/** Holds if `t` implements `Comparable` on `typeArg`. */
predicate implementsComparableOn(RefType t, RefType typeArg) {
  exists(RefType cmp |
    t.getAnAncestor() = cmp and
    cmp.getSourceDeclaration().hasQualifiedName("java.lang", "Comparable")
  |
    // Either `t` extends `Comparable<T>`, in which case `typeArg` is `T`, ...
    typeArg = cmp.(ParameterizedType).getATypeArgument() and not typeArg instanceof Wildcard
    or
    // ... or it extends the raw type `Comparable`, in which case `typeArg` is `Object`.
    cmp instanceof RawType and typeArg instanceof TypeObject
  )
}

class CompareToMethod extends Method {
  CompareToMethod() {
    this.hasName("compareTo") and
    this.isPublic() and
    this.getNumberOfParameters() = 1 and
    // To implement `Comparable<T>.compareTo`, the parameter must either have type `T` or `Object`.
    exists(RefType typeArg, Type firstParamType |
      implementsComparableOn(this.getDeclaringType(), typeArg) and
      firstParamType = this.getParameter(0).getType() and
      (firstParamType = typeArg or firstParamType instanceof TypeObject)
    )
  }
}

from Class c, CompareToMethod compareToMethod
where
  c.fromSource() and
  compareToMethod.fromSource() and
  not exists(EqualsMethod em | em.getDeclaringType().getSourceDeclaration() = c) and
  compareToMethod.getDeclaringType().getSourceDeclaration() = c and
  // Exclude classes annotated with relevant Lombok annotations.
  not c instanceof LombokEqualsAndHashCodeGeneratedClass
select c, "This class declares $@ but inherits equals; the two could be inconsistent.",
  compareToMethod, "compareTo"
