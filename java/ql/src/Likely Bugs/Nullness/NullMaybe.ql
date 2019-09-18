/**
 * @name Dereferenced variable may be null
 * @description Dereferencing a variable whose value may be 'null' may cause a
 *              'NullPointerException'.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/dereferenced-value-may-be-null
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-476
 *       non-local
 */

import java
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.Nullness

from VarAccess access, SsaSourceVariable var, string msg, Expr reason
where
  nullDeref(var, access, msg, reason) and
  // Exclude definite nulls here, as these are covered by `NullAlways.ql`.
  not alwaysNullDeref(var, access)
select access, "Variable $@ may be null here " + msg + ".", var.getVariable(),
  var.getVariable().getName(), reason, "this"
