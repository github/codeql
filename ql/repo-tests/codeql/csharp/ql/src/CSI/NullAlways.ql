/**
 * @name Dereferenced variable is always null
 * @description Dereferencing a variable whose value is 'null' causes a 'NullReferenceException'.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id cs/dereferenced-value-is-always-null
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-476
 */

import csharp
import semmle.code.csharp.dataflow.Nullness

from Dereference d, Ssa::SourceVariable v
where d.isFirstAlwaysNull(v)
select d, "Variable $@ is always null here.", v, v.toString()
