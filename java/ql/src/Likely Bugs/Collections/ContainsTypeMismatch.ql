/**
 * @name Type mismatch on container access
 * @description Calling container access methods such as 'Collection.contains'
 *              or 'Map.get' with an object of a type that is incompatible with
 *              the corresponding container element type is unlikely to return 'true'.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/type-mismatch-access
 * @tags reliability
 *       correctness
 *       logic
 */

import java
import semmle.code.java.Collections

predicate containerAccess(string package, string type, int p, string signature, int i) {
  package = "java.util" and
  type = "Collection" and
  p = 0 and
  signature = "contains(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Dictionary" and
  p = 0 and
  signature = "get(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Hashtable" and
  p = 1 and
  signature = "contains(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "List" and
  p = 0 and
  signature = "indexOf(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "List" and
  p = 0 and
  signature = "lastIndexOf(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Map" and
  p = 0 and
  signature = "get(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Map" and
  p = 0 and
  signature = "getOrDefault(java.lang.Object,java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Map" and
  p = 0 and
  signature = "containsKey(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Map" and
  p = 1 and
  signature = "containsValue(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Stack" and
  p = 0 and
  signature = "search(java.lang.Object)" and
  i = 0
  or
  package = "java.util" and
  type = "Vector" and
  p = 0 and
  signature = "indexOf(java.lang.Object,int)" and
  i = 0
  or
  package = "java.util" and
  type = "Vector" and
  p = 0 and
  signature = "lastIndexOf(java.lang.Object,int)" and
  i = 0
  or
  package = "java.util.concurrent" and
  type = "ConcurrentHashMap" and
  p = 1 and
  signature = "contains(java.lang.Object)" and
  i = 0
}

class MismatchedContainerAccess extends MethodAccess {
  MismatchedContainerAccess() {
    exists(string package, string type, int i |
      containerAccess(package, type, _, this.getCallee().getSignature(), i)
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
      containerAccess(package, type, p, this.getCallee().getSignature(), i)
    |
      t = this.getCallee().getDeclaringType() and
      t.getAnAncestor().getSourceDeclaration() = g and
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

from MismatchedContainerAccess ma, RefType typearg, RefType argtype, int idx
where
  typearg = ma.getReceiverElementType(idx).getSourceDeclaration() and
  argtype = ma.getArgumentType(idx) and
  not haveIntersection(typearg, argtype)
select ma.getArgument(idx),
  "Actual argument type '" + argtype.getName() + "'" +
    " is incompatible with expected argument type '" + typearg.getName() + "'."
