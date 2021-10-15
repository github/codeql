/**
 * @name Test for namespaces
 */

import csharp

from Namespace n
where
  n.hasQualifiedName("Empty") and
  not exists(n.getATypeDeclaration())
select n
