/**
 * @name Weak symmetric ciphers
 * @description Finds uses of cryptographic symmetric cipher algorithms that are unapproved or otherwise weak.
 * @id java/quantum/slices/weak-ciphers
 * @kind problem
 * @problem.severity error
 * @security.severity low
 * @precision high
 * @tags external/cwe/cwe-327
 */

import java
import experimental.quantum.Language

from Crypto::KeyOperationAlgorithmNode alg, string name, string msg
where
  name = alg.getAlgorithmName() and
  name in ["DES", "TripleDES", "DoubleDES", "RC2", "RC4", "IDEA", "Blowfish"] and
  msg = "Use of unapproved symmetric cipher algorithm or API: " + name + "."
select alg, msg