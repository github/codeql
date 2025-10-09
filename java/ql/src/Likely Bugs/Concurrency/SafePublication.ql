/**
 * @name Safe publication
 * @description A field of a thread-safe class is not safely published.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/safe-publication
 * @tags quality
 *       reliability
 *       concurrency
 */

import java
import semmle.code.java.ConflictingAccess

/**
 * Holds if `v` should be the default value for the field `f`.
 * That is, `v` is an initial (or constructor) assignment of `f`.
 */
predicate shouldBeDefaultValueFor(Field f, Expr v) {
  v = f.getAnAssignedValue() and
  (
    v = f.getInitializer()
    or
    v.getEnclosingCallable() = f.getDeclaringType().getAConstructor()
  )
}

/**
 * Gets the default value for the field `f`.
 * See https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html
 * for the default values of the primitive types.
 * The default value for non-primitive types is null.
 */
bindingset[result]
Expr getDefaultValue(Field f) {
  f.getType().hasName("byte") and result.(IntegerLiteral).getIntValue() = 0
  or
  f.getType().hasName("short") and result.(IntegerLiteral).getIntValue() = 0
  or
  f.getType().hasName("int") and result.(IntegerLiteral).getIntValue() = 0
  or
  f.getType().hasName("long") and
  (
    result.(LongLiteral).getValue() = "0" or
    result.(IntegerLiteral).getValue() = "0"
  )
  or
  f.getType().hasName("float") and result.(FloatLiteral).getValue() = "0.0"
  or
  f.getType().hasName("double") and result.(DoubleLiteral).getValue() = "0.0"
  or
  f.getType().hasName("char") and result.(CharacterLiteral).getCodePointValue() = 0
  or
  f.getType().hasName("boolean") and result.(BooleanLiteral).getBooleanValue() = false
  or
  not f.getType().getName() in [
      "byte", "short", "int", "long", "float", "double", "char", "boolean"
    ] and
  result instanceof NullLiteral
}

/**
 * Holds if all constructor or initial assignments (if any) are to the default value.
 * That is, assignments by the declaration:
 *   int x = 0; OK
 *   int x = 3; not OK
 * or inside a constructor:
 *   public c(a) {
 *     x = 0; OK
 *     x = 3; not OK
 *     x = a; not OK
 *   }
 */
predicate isAssignedDefaultValue(Field f) {
  forall(Expr v | shouldBeDefaultValueFor(f, v) | v = getDefaultValue(f))
}

predicate isSafelyPublished(Field f) {
  f.isFinal() or // NOTE: For non-primitive types, 'final' alone does not guarantee safe publication unless the object is immutable or safely constructed. Consider reviewing the handling of non-primitive fields for safe publication.
  f.isStatic() or
  f.isVolatile() or
  isThreadSafeType(f.getType()) or
  isThreadSafeType(f.getInitializer().getType()) or
  isAssignedDefaultValue(f)
}

from Field f, ClassAnnotatedAsThreadSafe c
where
  f = c.getAField() and
  not isSafelyPublished(f)
select f, "The class $@ is marked as thread-safe, but this field is not safely published.", c,
  c.getName()
