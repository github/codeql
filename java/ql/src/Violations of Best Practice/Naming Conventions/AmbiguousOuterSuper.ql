/**
 * @name Subtle call to inherited method
 * @description An unqualified call to a method that exists with the same signature in both a
 *              superclass and an outer class is ambiguous.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/subtle-inherited-call
 * @tags reliability
 *       readability
 */

import java

RefType nestedSupertypePlus(RefType t) {
  t.getASourceSupertype() = result and
  t instanceof NestedType
  or
  exists(RefType mid | mid = nestedSupertypePlus(t) | mid.getASourceSupertype() = result)
}

/**
 * A call (without a qualifier) in a nested type
 * to an inherited method with the specified `signature`.
 */
predicate callToInheritedMethod(RefType lexicalScope, MethodCall ma, string signature) {
  not ma.getMethod().isStatic() and
  not ma.hasQualifier() and
  ma.getEnclosingCallable().getDeclaringType() = lexicalScope and
  nestedSupertypePlus(lexicalScope).getAMethod() = ma.getMethod().getSourceDeclaration() and
  signature = ma.getMethod().getSignature()
}

/**
 * Return accessible methods in an outer class of `nested`.
 *
 * Accessible means that if a method is virtual then none of the nested
 * classes "on-route" can be static.
 */
Method methodInEnclosingType(NestedType nested, string signature) {
  (result.isStatic() or not nested.isStatic()) and
  result.getSignature() = signature and
  exists(RefType outer | outer = nested.getEnclosingType() |
    result = outer.getAMethod() or
    result = methodInEnclosingType(nested, signature)
  )
}

from MethodCall ma, Method m, NestedType nt, string signature
where
  callToInheritedMethod(nt, ma, signature) and
  m = methodInEnclosingType(nt, signature) and
  // There is actually scope for confusion.
  not nt.getASourceSupertype+() = m.getDeclaringType()
select ma, "A $@ is called instead of a $@.", ma.getMethod(), "method declared in a superclass", m,
  "method with the same signature in an enclosing class"
