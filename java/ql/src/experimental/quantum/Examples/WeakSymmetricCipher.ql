/**
 * @name Weak symmetric ciphers
 * @description Finds uses of cryptographic symmetric cipher algorithms that are unapproved or otherwise weak.
 * @id java/quantum/weak-ciphers
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 *       quantum
 *       experimental
 */

import java
import experimental.quantum.Language
import Crypto::KeyOpAlg as KeyOpAlg

from Crypto::KeyOperationAlgorithmNode alg, KeyOpAlg::AlgorithmType algType
where
  algType = alg.getAlgorithmType() and
  (
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DES()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::TRIPLE_DES()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DOUBLE_DES()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC2()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC4()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::IDEA()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::BLOWFISH())
  )
select alg, "Use of unapproved symmetric cipher algorithm or API: " + algType.toString() + "."
