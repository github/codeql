/**
 * @name Use iteration count at least 100k to prevent brute force attacks
 * @description When deriving cryptographic keys from user-provided inputs such as password,
 * use sufficient iteration count (at least 100k).
 *
 * This query will alert if the iteration count is less than 10000 (i.e., a constant <100000 is observed)
 * or if the source for the iteration count is not known statically.
 * @kind problem
 * @id py/kdf-low-iteration-count
 * @problem.severity error
 * @precision high
 */

import python
import experimental.cryptography.Concepts
private import experimental.cryptography.utils.Utils as Utils

from KeyDerivationOperation op, string msg, DataFlow::Node iterConfSrc
where
  op.requiresIteration() and
  iterConfSrc = op.getIterationSizeSrc() and
  (
    exists(iterConfSrc.asExpr().(IntegerLiteral).getValue()) and
    iterConfSrc.asExpr().(IntegerLiteral).getValue() < 10000 and
    msg = "Iteration count is too low. "
    or
    not exists(iterConfSrc.asExpr().(IntegerLiteral).getValue()) and
    msg = "Iteration count is not a statically verifiable size. "
  )
select op, msg + "Iteration count must be a minimum of 10000. Iteration Config: $@",
  iterConfSrc.asExpr(), iterConfSrc.asExpr().toString()
