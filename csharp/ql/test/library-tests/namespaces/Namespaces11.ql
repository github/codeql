/**
 * @name Test for namespaces
 */

import csharp

from UsingNamespaceDirective u
where
  u.getParentNamespaceDeclaration().getNamespace().hasQualifiedName("S3") and
  u.getImportedNamespace().hasQualifiedName("S1.S2") and
  u.getFile().getBaseName() = "namespaces.cs"
select u
