/**
 * @name Use of a weak cryptographic key
 * @description Using a weak cryptographic key can allow an attacker to compromise security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id js/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import javascript

from CryptographicKeyCreation key, int size, string msg, string algo
where
  size = key.getSize() and
  (
    algo = key.getAlgorithm() + " "
    or
    not exists(key.getAlgorithm()) and algo = ""
  ) and
  (
    size < 128 and
    key.isSymmetricKey() and
    msg =
      "Creation of an symmetric " + algo + "key uses " + size +
        " bits, which is below 128 and considered breakable."
    or
    size < 2048 and
    not key.isSymmetricKey() and
    msg =
      "Creation of an asymmetric " + algo + "key uses " + size +
        " bits, which is below 2048 and considered breakable."
  )
select key, msg
