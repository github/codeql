/**
 * @name Test for namespaces
 */

import csharp

from UsingNamespaceDirective u
where
  u.getFile().getBaseName() = "namespaces.cs" and
  u.getImportedNamespace().hasFullyQualifiedName("System.Collections", "Generic") and
  not exists(u.getParentNamespaceDeclaration())
select u
