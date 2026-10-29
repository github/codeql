import experimental.quantum.Language
import Crypto::KeyOpAlg as KeyOpAlg

/**
 * Holds when the given symmetric cipher algorithm is unapproved or weak.
 */
predicate isUnapprovedSymmetricCipher(Crypto::KeyOperationAlgorithmNode alg, string msg) {
  exists(KeyOpAlg::AlgorithmType algType |
    algType = alg.getAlgorithmType() and
    msg = "Use of unapproved symmetric cipher algorithm or API: " + algType.toString() + "." and
    algType != KeyOpAlg::TSymmetricCipher(KeyOpAlg::AES()) and
    algType instanceof KeyOpAlg::TSymmetricCipher
  )
  // NOTE: an org could decide to disallow very specific algorithms as well, shown below
  // (
  //   algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DES()) or
  //   algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::TRIPLE_DES()) or
  //   algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DOUBLE_DES()) or
  //   algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC2()) or
  //   algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC4()) or
  //   algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::IDEA()) or
  //   algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::BLOWFISH()) or
  //   algType = KeyOpAlg::TSymmetricCipher(KeyOpAlg::SKIPJACK())
  // )
}
