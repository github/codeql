/**
 * @name An assert statement has a side-effect
 * @description Side-effects in assert statements result in differences between normal
 *              and optimized behavior.
 * @kind problem
 * @tags reliability
 *       maintainability
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/side-effect-in-assert
 */

import python

predicate func_with_side_effects(Expr e) {
    exists(string name |
        name = ((Attribute)e).getName() or name = ((Name)e).getId() |
        name = "print" or name = "write" or name = "append" or
        name = "pop" or name = "remove" or name = "discard" or
        name = "delete" or name = "close" or name = "open" or
        name = "exit"
    )
}

predicate probable_side_effect(Expr e) {
    // Only consider explicit yields, not artificial ones in comprehensions
    e instanceof Yield and not exists(Comp c | c.contains(e))
    or
    e instanceof YieldFrom
    or
    e instanceof Call and func_with_side_effects(((Call)e).getFunc())
}

from Assert a, Expr e
where probable_side_effect(e) and a.contains(e)
select a, "This 'assert' statement contains $@ which may have side effects.", e, "an expression"
