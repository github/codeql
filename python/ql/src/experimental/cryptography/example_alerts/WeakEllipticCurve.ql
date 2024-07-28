/**
 * @name Weak elliptic curve
 * @description Finds uses of cryptography algorithms that are unapproved or otherwise weak.
 * @id py/weak-elliptic-curve
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 */

import python
import experimental.cryptography.Concepts

from EllipticCurveAlgorithm op, string msg, string name
where
  (
    name = op.getCurveName() and
    name = unknownAlgorithm() and
    msg = "Use of unrecognized curve algorithm."
    or
    name != unknownAlgorithm() and
    name = op.getCurveName() and
    not name =
      [
        "SECP256R1", "PRIME256V1", //P-256
        "SECP384R1", //P-384
        "SECP521R1", //P-521
        "ED25519", "X25519"
      ] and
    msg = "Use of weak curve algorithm " + name + "."
  )
select op, msg
