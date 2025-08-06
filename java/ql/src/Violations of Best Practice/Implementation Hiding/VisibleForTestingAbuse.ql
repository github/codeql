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
 * Holds if a nested class is within a static context
 */
predicate withinStaticContext(NestedClass c) {
  c.isStatic() or
  c.(AnonymousClass).getClassInstanceExpr().getEnclosingCallable().isStatic() // JLS 15.9.2
}

/**
 * Gets the enclosing instance type for a non-static inner class
 */
RefType enclosingInstanceType(Class inner) {
  not withinStaticContext(inner) and
  result = inner.(NestedClass).getEnclosingType()
}

/**
 * A class that encloses one or more inner classes
 */
class OuterClass extends Class {
  OuterClass() { this = enclosingInstanceType+(_) }
}

/**
 * Holds if an innerclass is accessed outside of its outerclass
 * and also outside of its fellow inner parallel classes
 */
predicate isWithinDirectOuterClassOrSiblingInner(
  Callable classInstanceEnclosing, RefType typeBeingConstructed
) {
  exists(NestedClass inner, OuterClass outer |
    outer = enclosingInstanceType(inner) and
    typeBeingConstructed = inner and
    // where the inner is called from the outer class
    classInstanceEnclosing.getDeclaringType() = outer
  )
  or
  // and inner is called from the a parallel inner
  exists(NestedClass inner, OuterClass outer, NestedClass otherinner |
    typeBeingConstructed = inner and
    outer = enclosingInstanceType(otherinner) and
    outer = enclosingInstanceType(inner) and
    classInstanceEnclosing.getDeclaringType() = otherinner
  )
}

from Annotatable annotated, Annotation annotation, Expr e
where
  annotation.getType().hasName("VisibleForTesting") and
  annotated.getAnAnnotation() = annotation and
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
    // class instantiation
    exists(ClassInstanceExpr c |
      c = e and
      c.getConstructedType() = annotated and
      // depending on the visiblity of the class, using the annotation to abuse the visibility may/may not be occurring
      // if public report when its used outside its package because package protected should have been enough (package only permitted)
      (
        c.getConstructedType().isPublic() and
        not isWithinPackage(c, c.getConstructedType())
        or
        // if its package protected report when its used outside its outer class bc it should have been private (outer class only permitted)
        c.getConstructedType().hasNoModifier() and
        // and the class is an innerclass, because otherwise recommending a lower accessibility makes no sense (only inner classes can be private)
        exists(enclosingInstanceType(c.getConstructedType())) and
        not isWithinDirectOuterClassOrSiblingInner(c.getEnclosingCallable(), c.getConstructedType())
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
  ) and
  // not in a test where use is appropriate
  not e.getEnclosingCallable() instanceof LikelyTestMethod and
  // also omit our own ql unit test where it is acceptable
  not e.getEnclosingCallable()
      .getFile()
      .getAbsolutePath()
      .matches("%java/ql/test/query-tests/%Test.java")
select e, "Access of $@ annotated with VisibleForTesting found in production code.", annotated,
  "element"
