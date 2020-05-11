/**
 * @name Property in old-style class
 * @description Using property descriptors in old-style classes does not work from Python 2.1 onward.
 * @kind problem
 * @tags portability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/property-in-old-style-class
 */

import python

from PropertyObject prop, ClassObject cls
where cls.declaredAttribute(_) = prop and not cls.failedInference() and not cls.isNewStyle()
select prop,
  "Property " + prop.getName() + " will not work properly, as class " + cls.getName() +
    " is an old-style class."
