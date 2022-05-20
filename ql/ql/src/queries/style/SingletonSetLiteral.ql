/**
 * @name Singleton set literal
 * @description A singleton set literal can be replaced by its member.
 * @kind problem
 * @problem.severity warning
 * @id ql/singleton-set-literal
 * @tags maintainability
 * @precision very-high
 */

import ql

from Set setlit
where exists(unique(Expr e | e = setlit.getElement(_)))
select setlit, "Singleton set literal can be replaced by its member."
