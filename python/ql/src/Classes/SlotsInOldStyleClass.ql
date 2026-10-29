/**
 * @name `__slots__` in old-style class
 * @description Overriding the class dictionary by declaring `__slots__` is not supported by old-style
 *              classes.
 * @kind problem
 * @problem.severity error
 * @tags portability
 *       correctness
 * @sub-severity low
 * @precision very-high
 * @id py/slots-in-old-style-class
 */

import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch

from Class c
where
  not DuckTyping::isNewStyle(c) and
  DuckTyping::declaresAttribute(c, "__slots__")
select c,
  "Using '__slots__' in an old style class just creates a class attribute called '__slots__'."
