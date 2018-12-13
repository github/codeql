/**
 * @name Double-checked locking is not thread-safe
 * @description A repeated check on a non-volatile field is not thread-safe, and
 *              could result in unexpected behavior.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-double-checked-locking
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-609
 */

import java
import DoubleCheckedLocking

from IfStmt if1, IfStmt if2, SynchronizedStmt sync, Field f
where
  doubleCheckedLocking(if1, if2, sync, f) and
  not f.isVolatile()
select sync, "Double-checked locking on the non-volatile field $@ is not thread-safe.", f,
  f.toString()
