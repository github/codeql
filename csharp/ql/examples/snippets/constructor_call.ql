/**
 * @id cs/examples/constructor-call
 * @name Call to constructor
 * @description Finds places where we call 'new System.Exception(...)'.
 * @tags call
 *       constructor
 *       new
 */

import csharp

from ObjectCreation new
where new.getObjectType().hasQualifiedName("System.Exception")
select new
