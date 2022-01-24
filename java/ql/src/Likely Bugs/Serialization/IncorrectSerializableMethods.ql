/**
 * @name Serialization methods do not match required signature
 * @description A serialized class that implements 'readObject', 'readObjectNoData' or 'writeObject' but
 *              does not use the correct signatures causes the default serialization mechanism to be used.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/wrong-object-serialization-signature
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java

from Method m, TypeSerializable serializable, string reason
where
  m.fromSource() and
  m.getDeclaringType().hasSupertype+(serializable) and
  (
    m.hasStringSignature("readObject(ObjectInputStream)") or
    m.hasStringSignature("readObjectNoData()") or
    m.hasStringSignature("writeObject(ObjectOutputStream)")
  ) and
  (
    not m.isPrivate() and reason = "Method must be private"
    or
    m.isStatic() and reason = "Method must not be static"
    or
    not m.getReturnType() instanceof VoidType and reason = "Return type must be void"
  )
select m, "Not recognized by Java serialization framework: " + reason
