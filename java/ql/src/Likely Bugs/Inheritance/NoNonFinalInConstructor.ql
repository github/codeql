/**
 * @name Non-final method invocation in constructor
 * @description If a constructor calls a method that is overridden in a subclass, the result can be
 *              unpredictable.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/non-final-call-in-constructor
 * @tags reliability
 *       correctness
 *       logic
 */

import java

private predicate writtenInOneCallable(Field f) { strictcount(Callable m | m.writes(f)) = 1 }

private FieldWrite fieldWriteOnlyIn(Callable m, Field f) {
  result.getField() = f and
  m.writes(f) and
  writtenInOneCallable(f)
}

private FieldRead nonFinalFieldRead(Callable m, Field f) {
  result.getField() = f and
  result.getEnclosingCallable() = m and
  not f.isFinal()
}

private MethodCall unqualifiedCallToNonAbstractMethod(Constructor c, Method m) {
  result.getEnclosingCallable() = c and
  (
    not exists(result.getQualifier()) or
    result.getQualifier().(ThisAccess).getType() = c.getDeclaringType()
  ) and
  m = result.getMethod() and
  not m.isAbstract()
}

from
  Constructor c, MethodCall ma, Method m, Method n, Field f, FieldRead fa, Constructor d,
  FieldWrite fw
where
  // Method access in a constructor
  // which is an access to the object being initialized, ...
  ma = unqualifiedCallToNonAbstractMethod(c, m) and
  // ... there exists an overriding method in a subtype,
  n.overrides+(m) and
  n.getDeclaringType().getAStrictAncestor() = c.getDeclaringType() and
  // ... the method is in a supertype of c,
  m.getDeclaringType() = c.getDeclaringType().getAnAncestor() and
  // ... `n` reads a non-final field `f`,
  fa = nonFinalFieldRead(n, f) and
  // ... which is declared in a subtype of `c`,
  f.getDeclaringType().getAStrictAncestor() = c.getDeclaringType() and
  // ... `f` is written only in the subtype constructor, and
  fw = fieldWriteOnlyIn(d, f) and
  // ... the subtype constructor calls (possibly indirectly) the offending super constructor.
  d.callsConstructor+(c)
select ma, "One $@ $@ a $@ that is only $@ in the $@, so it is uninitialized in this $@.", n,
  "overriding implementation", fa, "reads", f, "subclass field", fw, "initialized", d,
  "subclass constructor", c, "super constructor"
