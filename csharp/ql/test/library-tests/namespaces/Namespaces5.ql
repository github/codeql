/**
 * @name Test for namespaces
 */

import csharp

from Namespace n
where
  n.hasFullyQualifiedName("", "Empty") and
  not exists(n.getATypeDeclaration())
select n
