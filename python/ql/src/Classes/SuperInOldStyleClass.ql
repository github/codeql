/**
 * @name 'super' in old style class
 * @description Using super() to access inherited methods is not supported by old-style classes.
 * @kind problem
 * @tags portability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/super-in-old-style
 */

import python

predicate uses_of_super_in_old_style_class(Call s) {
  exists(Function f, ClassObject c |
    s.getScope() = f and
    f.getScope() = c.getPyClass() and
    not c.failedInference() and
    not c.isNewStyle() and
    s.getFunc().(Name).getId() = "super"
  )
}

from Call c
where uses_of_super_in_old_style_class(c)
select c, "super() will not work in old-style classes"
