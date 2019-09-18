/**
 * @name '__slots__' in old-style class
 * @description Overriding the class dictionary by declaring '__slots__' is not supported by old-style
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

from ClassObject c
where not c.isNewStyle() and c.declaresAttribute("__slots__") and not c.failedInference()
select c, "Using __slots__ in an old style class just creates a class attribute called '__slots__'"
