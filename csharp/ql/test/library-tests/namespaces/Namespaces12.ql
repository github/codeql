/**
 * @name Test for namespaces
 */

import csharp

from UsingNamespaceDirective u
where
  u.getFile().getBaseName() = "namespaces.cs" and
  u.getImportedNamespace().hasQualifiedName("System.Collections.Generic") and
  not exists(u.getParentNamespaceDeclaration())
select u
