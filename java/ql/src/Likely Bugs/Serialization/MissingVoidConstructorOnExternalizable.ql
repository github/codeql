/**
 * @name Externalizable but no public no-argument constructor
 * @description A class that implements 'Externalizable' but does not have a public no-argument
 *              constructor causes an 'InvalidClassException' to be thrown.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/missing-no-arg-constructor-on-externalizable
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java

from Class extern, Interface externalizable
where
  externalizable.hasQualifiedName("java.io", "Externalizable") and
  extern.hasSupertype+(externalizable) and
  not extern.isAbstract() and
  not exists(Constructor c | c = extern.getAConstructor() |
    c.hasNoParameters() and
    c.isPublic()
  )
select extern, "This class is Externalizable but has no public no-argument constructor."
