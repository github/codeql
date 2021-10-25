/**
 * @name Serialization methods do not match required signature
 * @description A serialized class that implements 'readObject' or 'writeObject' but does not use
 *              the correct signatures causes the default serialization mechanism to be used.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/wrong-object-serialization-signature
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java

from Method m, TypeSerializable serializable
where
  m.getDeclaringType().hasSupertype+(serializable) and
  m.getNumberOfParameters() = 1 and
  m.getAParameter().getType().(RefType).hasQualifiedName("java.io", "ObjectOutputStream") and
  (m.hasName("readObject") or m.hasName("writeObject")) and
  not m.isPrivate()
select m, "readObject and writeObject should be private methods."
