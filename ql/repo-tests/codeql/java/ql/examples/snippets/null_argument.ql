/**
 * @id java/examples/null-argument
 * @name Add null to collection
 * @description Finds places where we add null to a collection
 * @tags null
 *       parameter
 *       argument
 *       collection
 *       add
 */

import java

from MethodAccess call, Method add
where
  call.getMethod().overrides*(add) and
  add.hasName("add") and
  add.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.util", "Collection") and
  call.getAnArgument() instanceof NullLiteral
select call
