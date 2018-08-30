/**
 * @name Synchronization on boxed types or strings
 * @description Synchronizing on boxed types or strings may lead to
 *              deadlock since an instance of that type is likely to
 *              be shared between many parts of the program.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/sync-on-boxed-types
 * @tags reliability
 *       correctness
 *       concurrency
 *       language-features
 *       external/cwe/cwe-662
 */

import java

from SynchronizedStmt synch, Type type
where
  synch.getExpr().getType() = type and
  (type instanceof BoxedType or type instanceof TypeString)
select synch.getExpr(), "Do not synchronize on objects of type " + type + "."
