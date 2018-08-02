/**
 * @name Dereferenced variable is always null
 * @description Finds uses of a variable that may cause a NullPointerException
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/dereferenced-value-is-always-null
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-476
 */

import csharp
import semmle.code.csharp.dataflow.Nullness

from VariableAccess access, LocalVariable var
where access = unguardedNullDereference(var)
select access, "Variable $@ is always null here.", var, var.getName()
