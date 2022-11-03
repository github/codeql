/**
 * @name Dereferenced variable may be null
 * @description Dereferencing a variable whose value may be 'null' may cause a
 *              'NullReferenceException'.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id cs/dereferenced-value-may-be-null
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-476
 */

import csharp
import semmle.code.csharp.dataflow.Nullness
import PathGraph

from
  Dereference d, PathNode source, PathNode sink, Ssa::SourceVariable v, string msg, Element reason
where d.isFirstMaybeNull(v.getAnSsaDefinition(), source, sink, msg, reason)
select d, source, sink, "Variable $@ may be null here " + msg + ".", v, v.toString(), reason, "this"
