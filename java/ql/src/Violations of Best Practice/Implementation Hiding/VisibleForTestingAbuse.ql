/**
 * @id java/visible-for-testing-abuse
 * @name Use of VisibleForTesting in production code
 * @description Accessing methods, fields or classes annotated with `@VisibleForTesting` from
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
 * (including through lambdas, inner classes, and outer classes).
 */
predicate isWithinType(Callable c, RefType t) {
  // Either the callable is in the target type, or they share a common enclosing type
  c.getDeclaringType().getEnclosingType*() = t.getEnclosingType*()
}

/**
 * Holds if `e` is within the same package as `t`.
 */
predicate isWithinPackage(Expr e, RefType t) {
  e.getCompilationUnit().getPackage() = t.getPackage()
}

/**
 * Holds if a callable or any of its enclosing callables is annotated with @VisibleForTesting.
 */
predicate isWithinVisibleForTestingContext(Callable c) {
  c.getAnAnnotation().getType().hasName("VisibleForTesting")
  or
  isWithinVisibleForTestingContext(c.getEnclosingCallable())
}

/**
 * Holds if `e` is within a test method context, including lambda expressions
 * within test methods and nested lambdas.
 */
private predicate isWithinTest(Expr e) {
  e.getEnclosingCallable() instanceof LikelyTestMethod
  or
  exists(Method lambda, LambdaExpr lambdaExpr |
    lambda = lambdaExpr.asMethod() and
    lambda.getEnclosingCallable*() instanceof LikelyTestMethod and
    e.getEnclosingCallable() = lambda
  )
}

from Annotatable annotated, Expr e
where
  annotated.getAnAnnotation().getType().hasName("VisibleForTesting") and
  (
    // field access
    e =
      any(FieldAccess v |
        v.getField() = annotated and
        // depending on the visibility of the field, using the annotation to abuse the visibility may/may not be occurring
        (
          // if its package protected report when its used outside its class because it should have been private (class only permitted)
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
    e =
      any(MethodCall c |
        c.getMethod() = annotated and
        // depending on the visibility of the method, using the annotation to abuse the visibility may/may not be occurring
        (
          // if its package protected report when its used outside its class because it should have been private (class only permitted)
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
    e =
      any(ClassInstanceExpr c |
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
  not isWithinTest(e) and
  // not when the accessing method or any enclosing method is @VisibleForTesting (test-to-test communication)
  not isWithinVisibleForTestingContext(e.getEnclosingCallable()) and
  // not when used in annotation contexts
  not e.getParent*() instanceof Annotation
select e, "Access of $@ annotated with VisibleForTesting found in production code.", annotated,
  "element"
