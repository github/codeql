/**
 * @name Dereferenced expression may be null
 * @description Dereferencing an expression whose value may be 'null' may cause a
 *              'NullPointerException'.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/dereferenced-expr-may-be-null
 * @suites security-and-quality
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-476
 */

import java
import semmle.code.java.dataflow.Nullness

from Expr e
where dereference(e) and e = nullExpr()
select e, "This expression is dereferenced and may be null."
