/**
 * @name 'new[]' array freed with 'delete'
 * @description An array allocated with 'new[]' is being freed using 'delete'. Behavior in such cases is undefined and should be avoided. Use 'delete[]' when freeing arrays allocated with 'new[]'.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/new-array-delete-mismatch
 * @tags reliability
 */

import NewDelete

from Expr alloc, Expr free, Expr freed
where
  allocReaches(freed, alloc, "new[]") and
  freeExprOrIndirect(free, freed, "delete")
select free, "This memory may have been allocated with '$@', not 'new'.", alloc, "new[]"
