/**
 * @id cs/examples/throw-exception
 * @name Throw exception of given type
 * @description Finds places where we throw 'System.IO.IOException' or one of its subtypes.
 * @tags throw
 *       exception
 */

import csharp

from ThrowStmt throw
where
  throw.getThrownExceptionType().getBaseClass*().hasFullyQualifiedName("System.IO", "IOException")
select throw
