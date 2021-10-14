/**
 * @name Dereferenced variable is always null
 * @description Dereferencing a variable whose value is 'null' causes a 'NullPointerException'.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/dereferenced-value-is-always-null
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-476
 */

import java
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.Nullness

from VarAccess access, SsaSourceVariable var
where alwaysNullDeref(var, access)
select access, "Variable $@ is always null here.", var.getVariable(), var.getVariable().getName()
