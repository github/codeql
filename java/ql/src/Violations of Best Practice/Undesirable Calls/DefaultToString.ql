/**
 * @name Use of default toString()
 * @description Calling the default implementation of 'toString' returns a value that is unlikely to
 *              be what you expect.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/call-to-object-tostring
 * @tags reliability
 *       maintainability
 */

import java
import semmle.code.java.StringFormat

predicate explicitToStringCall(Expr e) {
  exists(MethodAccess ma, Method toString | toString = ma.getMethod() |
    e = ma.getQualifier() and
    toString.getName() = "toString" and
    toString.getNumberOfParameters() = 0 and
    not toString.isStatic()
  )
}

predicate directlyDeclaresToString(Class c) {
  exists(Method m | m.getDeclaringType() = c |
    m.getName() = "toString" and
    m.getNumberOfParameters() = 0
  )
}

predicate inheritsObjectToString(Class t) {
  not directlyDeclaresToString(t.getSourceDeclaration()) and
  (
    t.getASupertype().hasQualifiedName("java.lang", "Object")
    or
    not t.getASupertype().hasQualifiedName("java.lang", "Object") and
    inheritsObjectToString(t.getASupertype())
  )
}

Class getAnImplementation(RefType parent) {
  result = parent.getASubtype*() and
  not result.isAbstract()
}

predicate bad(RefType t) {
  forex(Class sub | sub = getAnImplementation(t) | inheritsObjectToString(sub)) and
  not t instanceof Array and
  not t instanceof GenericType and
  not t instanceof BoundedType and
  t.fromSource()
}

from Expr e, RefType sourceType
where
  (implicitToStringCall(e) or explicitToStringCall(e)) and
  sourceType = e.getType().(RefType).getSourceDeclaration() and
  bad(sourceType) and
  not sourceType.isAbstract() and
  sourceType.fromSource()
select e,
  "Default toString(): " + e.getType().getName() +
    " inherits toString() from Object, and so is not suitable for printing."
