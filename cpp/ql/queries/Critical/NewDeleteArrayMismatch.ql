/**
 * @name 'new' object freed with 'delete[]'
 * @description An object that was allocated with 'new' is being freed using 'delete[]'. Behavior in such cases is undefined and should be avoided. Use 'delete' instead.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/new-delete-array-mismatch
 * @tags reliability
 */

import NewDelete

from Expr alloc, Expr free, Expr freed
where
  allocReaches(freed, alloc, "new") and
  freeExprOrIndirect(free, freed, "delete[]")
select free, "This memory may have been allocated with '$@', not 'new[]'.", alloc, "new"
