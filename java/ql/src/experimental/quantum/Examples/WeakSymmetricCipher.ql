/**
 * @name Weak symmetric ciphers
 * @description Finds uses of cryptographic symmetric cipher algorithms that are unapproved or otherwise weak.
 * @id java/quantum/examples/weak-ciphers
 * @kind problem
 * @problem.severity error
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
  // NOTE: an org may disallow all but AES we could similarly look for
  // algType != KeyOpAlg::TSymmetricCipher(KeyOpAlg::AES())
  // This is a more comprehensive check than looking for all weak ciphers
  (
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DES()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::TRIPLE_DES()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DOUBLE_DES()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC2()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC4()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::IDEA()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::BLOWFISH()) or
    algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::SKIPJACK())
  )
select alg, "Use of unapproved symmetric cipher algorithm or API: " + algType.toString() + "."
