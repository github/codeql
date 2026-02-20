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
private import semmle.python.dataflow.new.internal.DataFlowDispatch

from Function prop, Class cls
where
  prop.getScope() = cls and
  prop.getADecorator().(Name).getId() = "property" and
  not DuckTyping::isNewStyle(cls)
select prop,
  "Property " + prop.getName() + " will not work properly, as class " + cls.getName() +
    " is an old-style class."
