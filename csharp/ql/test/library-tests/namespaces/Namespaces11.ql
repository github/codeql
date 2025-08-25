/**
 * @name Test for namespaces
 */

import csharp

from UsingNamespaceDirective u
where
  u.getParentNamespaceDeclaration().getNamespace().hasFullyQualifiedName("", "S3") and
  u.getImportedNamespace().hasFullyQualifiedName("S1", "S2") and
  u.getFile().getBaseName() = "namespaces.cs"
select u
