/**
 * @id java/examples/throw-exception
 * @name Throw exception of type
 * @description Finds places where we throw com.example.AnException or one of its subtypes
 * @tags throw
 *       exception
 */

import java

from ThrowStmt throw
where throw.getThrownExceptionType().getAnAncestor().hasQualifiedName("com.example", "AnException")
select throw, "Don't throw com.example.AnException"
