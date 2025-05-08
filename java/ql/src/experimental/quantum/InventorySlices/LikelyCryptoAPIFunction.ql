/**
 * @name Detects functions that take in crypto configuration parameters but calls are not detected in source.
 * @id java/crypto_inventory_slices/likely_crypto_api_function
 * @kind problem
 */

import java
import experimental.quantum.Language

from Callable f, Parameter p, Crypto::OperationNode op
where
  op.asElement().(Expr).getEnclosingCallable() = f and
  op.getAnAlgorithmOrGenericSource().asElement() = p
select f,
  "Likely crypto API function: Operation $@ configured by parameter $@ with no known configuring call",
  op, op.toString(), p, p.toString()
