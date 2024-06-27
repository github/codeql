/**
 * @name Inherited equals() in subclass with added fields
 * @description If a class overrides 'Object.equals', and a subclass defines additional fields
 *              to those it inherits but does not re-define 'equals', the results of 'equals'
 *              may be wrong.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/inherited-equals-with-added-fields
 * @tags reliability
 *       correctness
 */

import java

predicate okForEquals(Class c) {
  c.getAMethod() instanceof EqualsMethod
  or
  not exists(c.getAField()) and
  okForEquals(c.getASupertype())
}

/** Holds if method `em` implements a reference equality check. */
predicate checksReferenceEquality(EqualsMethod em) {
  // `java.lang.Object.equals` is the prototypical reference equality implementation.
  em.getDeclaringType() instanceof TypeObject
  or
  // Custom reference equality implementations observed in open-source projects.
  exists(SingletonBlock blk, EQExpr eq |
    blk = em.getBody() and
    eq.getAnOperand() instanceof ThisAccess and
    eq.getAnOperand().(VarAccess).getVariable() = em.getParameter(0) and
    (
      // `{ return (ojb==this); }`
      eq = blk.getStmt().(ReturnStmt).getResult()
      or
      // `{ if (ojb==this) return true; else return false; }`
      exists(IfStmt ifStmt | ifStmt = blk.getStmt() |
        eq = ifStmt.getCondition() and
        ifStmt.getThen().(ReturnStmt).getResult().(BooleanLiteral).getBooleanValue() = true and
        ifStmt.getElse().(ReturnStmt).getResult().(BooleanLiteral).getBooleanValue() = false
      )
    )
  )
  or
  // Check whether `em` delegates to another method checking reference equality.
  // More precisely, we check whether the body of `em` is of the form `return super.equals(o);`,
  // where `o` is the (only) parameter of `em`, and the invoked method is a reference equality check.
  exists(SuperMethodCall sup |
    sup = em.getBody().(SingletonBlock).getStmt().(ReturnStmt).getResult() and
    sup.getArgument(0) = em.getParameter(0).getAnAccess() and
    checksReferenceEquality(sup.getCallee())
  )
}

predicate unsupportedEquals(EqualsMethod em) {
  em.getBody().(SingletonBlock).getStmt() instanceof ThrowStmt
}

predicate overridesDelegateEquals(EqualsMethod em, Class c) {
  exists(Method override, Method delegate |
    // The `equals` method (declared in the supertype) contains
    // a call to a `delegate` method on the same type ...
    em.calls(delegate) and
    delegate.getDeclaringType() = em.getDeclaringType() and
    // ... and the `delegate` method is overridden in the subtype `c`
    // by a method that reads at least one added field.
    override.getDeclaringType() = c and
    exists(Method overridden | overridden.getSourceDeclaration() = delegate |
      override.overrides(overridden)
    ) and
    readsOwnField(override)
  )
}

predicate readsOwnField(Method m) { m.reads(m.getDeclaringType().getAField()) }

from Class c, InstanceField f, EqualsMethod em
where
  not exists(EqualsMethod m | m.getDeclaringType() = c) and
  okForEquals(c.getASupertype()) and
  exists(Method m | m.getSourceDeclaration() = em | c.inherits(m)) and
  exists(em.getBody()) and
  not checksReferenceEquality(em) and
  not unsupportedEquals(em) and
  not overridesDelegateEquals(em, c) and
  f.getDeclaringType() = c and
  c.fromSource() and
  not c instanceof EnumType and
  not f.isFinal()
select c, c.getName() + " inherits $@ but adds $@.", em.getSourceDeclaration(),
  em.getDeclaringType().getName() + "." + em.getName(), f, "the field " + f.getName()
