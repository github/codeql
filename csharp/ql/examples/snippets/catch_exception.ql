/**
 * @id cs/examples/catch-exception
 * @name Catch exception
 * @description Finds places where we catch exceptions of type 'System.IO.IOException'.
 * @tags catch
 *       try
 *       exception
 */

import csharp

from CatchClause catch
where catch.getCaughtExceptionType().hasFullyQualifiedName("System.IO", "IOException")
select catch
