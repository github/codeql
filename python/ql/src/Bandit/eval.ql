/**
 * @name Use of possibly insecure function
 * @description Use of possibly insecure function - consider using safer ast.literal_eval.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b307-eval
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision high
 * @id py/bandit/eval
 */

import python


from Expr e
where e.(Call).toString() = "eval()"
  and exists(e.getLocation().getFile().getRelativePath())
select e, "Use of possibly insecure function - consider using safer ast.literal_eval."