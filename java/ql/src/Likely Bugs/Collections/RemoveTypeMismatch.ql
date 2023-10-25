/**
 * @name Type mismatch on container modification
 * @description Calling container modification methods such as 'Collection.remove'
 *              or 'Map.remove' with an object of a type that is incompatible with
 *              the corresponding container element type is unlikely to have any effect.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/type-mismatch-modification
 * @tags reliability
 *       correctness
 *       logic
 */

import java
import semmle.code.java.Collections

predicate containerModification(string package, string type, int p, string signature, int i) {
  package = "java.util" and
  type = "Collection" and
  p = 0 and
  signature = "remove(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Deque" and
  p = 0 and
  signature = "removeFirstOccurrence(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Deque" and
  p = 0 and
  signature = "removeLastOccurrence(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Dictionary" and
  p = 0 and
  signature = "remove(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Map" and
  p = 0 and
  signature = "remove(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Map" and
  p = 0 and
  signature = "remove(java.lang.Object,java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Map" and
  p = 1 and
  signature = "remove(java.lang.Object,java.lang.Object)" and
  i = 1
  or
  package = "java.util" and
  type = "Vector" and
  p = 0 and
  signature = "removeElement(java.lang.Object)" and
  i = 0
}

class MismatchedContainerModification extends MethodCall {
  MismatchedContainerModification() {
    exists(string package, string type, int i |
      containerModification(package, type, _, this.getCallee().getSignature(), i)
    |
      this.getCallee()
          .getDeclaringType()
          .getASourceSupertype*()
          .getSourceDeclaration()
          .hasQualifiedName(package, type) and
      this.getCallee().getParameter(i).getType() instanceof TypeObject
    )
  }

  /**
   * Holds if `result` is one of the element types of the container accessed by this call
   * and the argument at index `i` of this call is expected to have type `result`.
   */
  RefType getReceiverElementType(int i) {
    exists(RefType t, GenericType g, string package, string type, int p |
      containerModification(package, type, p, this.getCallee().getSignature(), i)
    |
      t = this.getCallee().getDeclaringType() and
      t.getASourceSupertype*().getSourceDeclaration() = g and
      g.hasQualifiedName(package, type) and
      indirectlyInstantiates(t, g, p, result)
    )
  }

  /**
   * Gets the type of the argument at index `i` of this method access,
   * boxed if it is a primitive.
   */
  RefType getArgumentType(int i) {
    exists(Type argtp | argtp = this.getArgument(i).getType() |
      result = argtp or result = argtp.(PrimitiveType).getBoxedType()
    )
  }
}

from MismatchedContainerModification ma, RefType elementtype, RefType argtype, int idx
where
  elementtype = ma.getReceiverElementType(idx).getSourceDeclaration() and
  argtype = ma.getArgumentType(idx) and
  notHaveIntersection(elementtype, argtype)
select ma.getArgument(idx),
  "Actual argument type '" + argtype.getName() + "'" +
    " is incompatible with expected argument type '" + elementtype.getName() + "'."
