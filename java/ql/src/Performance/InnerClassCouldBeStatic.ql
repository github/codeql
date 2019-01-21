/**
 * @name Inner class could be static
 * @description A non-static nested class keeps a reference to the enclosing object,
 *              which makes the nested class bigger and may cause a memory leak.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/non-static-nested-class
 * @tags efficiency
 *       maintainability
 */

import java

/**
 * Is the field `f` inherited by the class `c`? This is a slightly imprecise,
 * since package-protected fields are not inherited by classes in different
 * packages, but it's enough for the purposes of this check.
 */
predicate inherits(Class c, Field f) {
  f = c.getAField()
  or
  not f.isPrivate() and c.getASupertype+().getAField() = f
}

/**
 * An access to a method or field that uses an enclosing instance
 * of the type containing it.
 */
class EnclosingInstanceAccess extends Expr {
  EnclosingInstanceAccess() { exists(enclosingInstanceAccess(this)) }

  RefType getAnAccessedType() { result = enclosingInstanceAccess(this) }
}

RefType enclosingInstanceAccess(Expr expr) {
  exists(RefType enclosing | enclosing = expr.getEnclosingCallable().getDeclaringType() |
    // A direct qualified `this` access that doesn't refer to the containing
    // class must refer to an enclosing instance instead.
    result = expr.(ThisAccess).getType() and result != enclosing
    or
    // A qualified `super` access qualified with a type that isn't the enclosing type.
    result = expr.(SuperAccess).getQualifier().(TypeAccess).getType() and result != enclosing
    or
    // An unqualified `new` expression constructing a
    // non-static type that needs an enclosing instance.
    exists(ClassInstanceExpr new, InnerClass t |
      new = expr and t = new.getType().(RefType).getSourceDeclaration()
    |
      result = t and
      not exists(new.getQualifier()) and
      not t.getEnclosingType*() = enclosing
    )
    or
    // An unqualified `new` expression constructing another instance of the
    // class it is itself located in, calling a constructor that uses an
    // enclosing instance.
    exists(ClassInstanceExpr new, Constructor ctor, Expr e2 |
      new = expr and
      not exists(new.getQualifier()) and
      ctor = new.getConstructor() and
      enclosing.getEnclosingType*().(InnerClass) = ctor.getDeclaringType() and
      ctor = e2.getEnclosingCallable() and
      result = enclosingInstanceAccess(e2)
    )
    or
    // An unqualified method or field access to a member that isn't inherited
    // must refer to an enclosing instance.
    exists(FieldAccess fa | fa = expr |
      result = fa.getField().getDeclaringType() and
      not exists(fa.getQualifier()) and
      not fa.getVariable().(Field).isStatic() and
      not inherits(enclosing, fa.getVariable())
    )
    or
    exists(MethodAccess ma | ma = expr |
      result = ma.getMethod().getDeclaringType() and
      not exists(ma.getQualifier()) and
      not ma.getMethod().isStatic() and
      not exists(Method m | m.getSourceDeclaration() = ma.getMethod() | enclosing.inherits(m))
    )
  )
}

/**
 * A nested class `c` could be static precisely when
 *
 *  - it only accesses members of enclosing instances in its constructor
 *    (this includes field initializers);
 *  - it is not anonymous;
 *  - it is not a local class;
 *  - if its supertype or enclosing type is also nested, that type could be made static;
 *  - any classes nested within `c` only access members of enclosing instances of `c` in their constructors,
 *    and only extend classes that could be made static.
 *
 * Note that classes that are already static clearly "could" be static.
 */
predicate potentiallyStatic(InnerClass c) {
  not exists(EnclosingInstanceAccess a, Method m |
    m = a.getEnclosingCallable() and
    m.getDeclaringType() = c
  ) and
  not c instanceof AnonymousClass and
  not c instanceof LocalClass and
  forall(
    InnerClass other // If nested and non-static, ...
  |
    // ... all supertypes (which are from source), ...
    other = c.getASourceSupertype() and other.fromSource()
    or
    // ... and the enclosing type, ...
    other = c.getEnclosingType()
  |
    // ... must be (potentially) static.
    potentiallyStatic(other)
  ) and
  // No nested classes of `c` access an enclosing instance of `c` except in their constructors, i.e.
  // for all accesses to a non-static member of an enclosing instance ...
  forall(EnclosingInstanceAccess a, Method m |
    // ... that occur in a method of a nested class of `c` ...
    m = a.getEnclosingCallable() and m.getDeclaringType().getEnclosingType+() = c
  |
    // ... the access must be to a member of a type enclosed in `c` or `c` itself.
    a.getAnAccessedType().getEnclosingType*() = c
  ) and
  // Any supertype of a class nested in `c` must be potentially static.
  forall(InnerClass nested | nested.getEnclosingType+() = c |
    forall(InnerClass superOfNested | superOfNested = nested.getASourceSupertype+() |
      potentiallyStatic(superOfNested)
    )
  )
}

/**
 * A problematic class, meaning a class that could be static but isn't.
 */
class ProblematicClass extends InnerClass {
  ProblematicClass() { potentiallyStatic(this) }

  /**
   * Check for accesses to the enclosing instance in a constructor or field
   * initializer.
   */
  predicate usesEnclosingInstanceInConstructor() {
    exists(EnclosingInstanceAccess a | a.getEnclosingCallable() = this.getAConstructor())
  }
}

from ProblematicClass c, string msg
where
  c.fromSource() and
  if c.usesEnclosingInstanceInConstructor()
  then msg = " could be made static, since the enclosing instance is used only in its constructor."
  else msg = " should be made static, since the enclosing instance is not used."
select c, c.getName() + msg
