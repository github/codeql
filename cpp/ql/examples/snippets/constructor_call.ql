/**
 * @id cpp/examples/constructor-call
 * @name Call to constructor
 * @description Finds places where we call `new MyClass(...)`
 * @tags call
 *       constructor
 *       new
 */

import cpp

from NewExpr new, Constructor c
where
  c = new.getInitializer().(ConstructorCall).getTarget() and
  c.getName() = "MyClass"
select new
