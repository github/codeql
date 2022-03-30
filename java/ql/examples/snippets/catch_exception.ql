/**
 * @id java/examples/catch-exception
 * @name Catch exception
 * @description Finds places where we catch exceptions of type com.example.AnException
 * @tags catch
 *       try
 *       exception
 */

import java

from CatchClause catch
where catch.getACaughtType().hasQualifiedName("com.example", "AnException")
select catch
