/**
 * @id py/examples/extend-class
 * @name Class subclasses
 * @description Finds classes that subclass MyClass
 * @tags class
 *       extends
 *       implements
 *       overrides
 *       subtype
 *       supertype
 */

import python

from ClassObject sub, ClassObject base
where
  base.getName() = "MyClass" and
  sub.getABaseType() = base
select sub
