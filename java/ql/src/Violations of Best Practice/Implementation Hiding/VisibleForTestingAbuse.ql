/**
 * @id java/visible-for-testing-abuse
 * @name Accessing any method, field or class annotated with `@VisibleForTesting` from production code is discouraged
 * @description Accessing any method, field or class annotated with `@VisibleForTesting` from
 *              production code goes against the intention of the annotation and may indicate
 *              programmer error.
 * @kind problem
 * @precision high
 * @problem.severity warning
 * @tags quality
 *       maintainability
 *       readability
 */

import java

/**
 * Holds if a `Callable` is within the same type hierarchy as `RefType`
 * (including through lambdas, inner classes, and outer classes)
 */
predicate isWithinType(Callable c, RefType t) {
  // Either the callable is in the target type, or they share a common enclosing type
  exists(RefType commonType |
    (c.getDeclaringType() = commonType or c.getDeclaringType().getEnclosingType*() = commonType) and
    (t = commonType or t.getEnclosingType*() = commonType)
  )
}

/**
 * Holds if a `Callable` is within same package as the `RefType`
 */
predicate isWithinPackage(Expr e, RefType t) {
  e.getCompilationUnit().getPackage() = t.getPackage()
}

/**
 * Holds if a callable or any of its enclosing callables is annotated with @VisibleForTesting
 */
predicate isWithinVisibleForTestingContext(Callable c) {
  c.getAnAnnotation().getType().hasName("VisibleForTesting")
  or
  isWithinVisibleForTestingContext(c.getEnclosingCallable())
}

from Annotatable annotated, Expr e
where
  annotated.getAnAnnotation().getType().hasName("VisibleForTesting") and
  (
    // field access
    exists(FieldAccess v |
      v = e and
      v.getField() = annotated and
      // depending on the visiblity of the field, using the annotation to abuse the visibility may/may not be occurring
      (
        // if its package protected report when its used outside its class bc it should have been private (class only permitted)
        v.getField().isPackageProtected() and
        not isWithinType(v.getEnclosingCallable(), v.getField().getDeclaringType())
        or
        // if public or protected report when its used outside its package because package protected should have been enough (package only permitted)
        (v.getField().isPublic() or v.getField().isProtected()) and
        not isWithinPackage(v, v.getField().getDeclaringType())
      )
    )
    or
    // method access
    exists(MethodCall c |
      c = e and
      c.getMethod() = annotated and
      // depending on the visiblity of the method, using the annotation to abuse the visibility may/may not be occurring
      (
        // if its package protected report when its used outside its class bc it should have been private (class only permitted)
        c.getMethod().isPackageProtected() and
        not isWithinType(c.getEnclosingCallable(), c.getMethod().getDeclaringType())
        or
        // if public or protected report when its used outside its package because package protected should have been enough (package only permitted)
        (c.getMethod().isPublic() or c.getMethod().isProtected()) and
        not isWithinPackage(c, c.getMethod().getDeclaringType())
      )
    )
    or
    // Class instantiation - report if used outside appropriate scope
    exists(ClassInstanceExpr c |
      c = e and
      c.getConstructedType() = annotated and
      (
        c.getConstructedType().isPublic() and not isWithinPackage(c, c.getConstructedType())
        or
        c.getConstructedType().hasNoModifier() and
        c.getConstructedType() instanceof NestedClass and
        not isWithinType(c.getEnclosingCallable(), c.getConstructedType())
      )
    )
  ) and
  // not in a test where use is appropriate
  not e.getEnclosingCallable() instanceof LikelyTestMethod and
  // not when the accessing method or any enclosing method is @VisibleForTesting (test-to-test communication)
  not isWithinVisibleForTestingContext(e.getEnclosingCallable()) and
  // also omit our own ql unit test where it is acceptable
  not e.getEnclosingCallable()
      .getFile()
      .getAbsolutePath()
      .matches("%java/ql/test/query-tests/%Test.java")
select e, "Access of $@ annotated with VisibleForTesting found in production code.", annotated,
  "element"
