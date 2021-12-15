/**
 * @name Use of weak cryptographic key
 * @description Use of a cryptographic key that is too small may allow the encryption to be broken.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id py/weak-crypto-key
 * @tags security
 *       external/cwe/cwe-326
 */

import python
import semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.filters.Tests

from Cryptography::PublicKey::KeyGeneration keyGen, int keySize, DataFlow::Node origin
where
  keySize = keyGen.getKeySizeWithOrigin(origin) and
  keySize < keyGen.minimumSecureKeySize() and
  not origin.getScope().getScope*() instanceof TestScope
select keyGen,
  "Creation of an " + keyGen.getName() + " key uses $@ bits, which is below " +
    keyGen.minimumSecureKeySize() + " and considered breakable.", origin, keySize.toString()
