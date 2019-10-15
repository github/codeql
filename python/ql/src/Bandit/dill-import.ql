/**
 * @name Security implications associated with dill module.
 * @description Consider possible security implications associated with dill module.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b403-import-pickle
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/dill-import
 */

import python

from ImportExpr i
where i.getName().toString() = "dill"
select i, "Consider possible security implications associated with dill module."

