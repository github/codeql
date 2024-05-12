/**
 * @name Small KDF salt length.
 * @description KDF salts should be a minimum of 128 bits (16 bytes).
 *
 * This alerts if a constant traces to to a salt length sink less than 128-bits or
 * if the value that traces to a salt length sink is not known statically.
 * @kind problem
 * @id py/kdf-small-salt-size
 * @problem.severity error
 * @precision high
 */

import python
import experimental.cryptography.Concepts
private import experimental.cryptography.utils.Utils as Utils

from KeyDerivationOperation op, DataFlow::Node randConfSrc, API::CallNode call, string msg
where
  op.requiresSalt() and
  API::moduleImport("os").getMember("urandom").getACall() = call and
  call = op.getSaltConfigSrc() and
  randConfSrc = Utils::getUltimateSrcFromApiNode(call.getParameter(0, "size")) and
  (
    not exists(randConfSrc.asExpr().(IntegerLiteral).getValue()) and
    msg = "Salt config is not a statically verifiable size. "
    or
    randConfSrc.asExpr().(IntegerLiteral).getValue() < 16 and
    msg = "Salt config is insufficiently large. "
  )
select op,
  msg + "Salt size must be a minimum of 16 (bytes). os.urandom Config: $@, Size Config: $@", call,
  call.toString(), randConfSrc, randConfSrc.toString()
