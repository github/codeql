/**
 * @id cs/examples/null-argument
 * @name Add null to collection
 * @description Finds places where we add 'null' to a collection.
 * @tags null
 *       parameter
 *       argument
 *       collection
 *       add
 */

import csharp

from MethodCall call, Method add
where
  call.getTarget() = add.getAnUltimateImplementor*() and
  add.hasName("Add") and
  add.getDeclaringType()
      .getUnboundDeclaration()
      .hasFullyQualifiedName("System.Collections.Generic", "ICollection`1") and
  call.getAnArgument() instanceof NullLiteral
select call
