/**
 * @name Dereferenced variable may be null
 * @description Finds uses of a variable that may cause a NullPointerException
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/dereferenced-value-may-be-null
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-476
 */

import csharp
import semmle.code.csharp.dataflow.Nullness

from VariableAccess access, LocalVariable var
where access = unguardedMaybeNullDereference(var)
// do not flag definite nulls here; these are already flagged by NullAlways.ql
and not access = unguardedNullDereference(var)
select access, "Variable $@ may be null here.", var, var.getName()
