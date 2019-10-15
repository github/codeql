/**
 * @name  The input method in Python 2 will evaluate and run the resulting string
 * @description The input method in Python 2 will read from standard input, evaluate and run the resulting string as python source code.
 * 				This is similar, though in many ways worse, then using eval. On Python 2, use raw_input instead, input is safe in Python 3.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b322-input
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/input
 */

import python

from Expr e
where e.(Call).toString() = "input()"
select e, "The input method in Python 2 will read from standard input, evaluate and run the resulting string as python source code. "