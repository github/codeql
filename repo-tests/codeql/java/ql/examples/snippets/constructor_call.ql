/**
 * @id java/examples/constructor-call
 * @name Call to constructor
 * @description Finds places where we call `new com.example.Class(...)`
 * @tags call
 *       constructor
 *       new
 */

import java

from ClassInstanceExpr new
where new.getConstructedType().hasQualifiedName("com.example", "Class")
select new
