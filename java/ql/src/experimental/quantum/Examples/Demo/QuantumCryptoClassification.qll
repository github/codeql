/**
 * Shared predicates for classifying cryptographic algorithms, modes, padding,
 * hashes, curves, and key sizes into quantum-vulnerable, insecure, and
 * secure/quantum-proof categories.
 */

import experimental.quantum.Language
import Crypto::KeyOpAlg as KeyOpAlg

/**
 * Holds when the key operation algorithm type is quantum-vulnerable.
 * Covers RSA (asymmetric cipher), DSA, ECDSA, and EdDSA (signatures).
 */
predicate isQuantumVulnerableAlgorithmType(KeyOpAlg::AlgorithmType t) {
  t = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA())
  or
  t = KeyOpAlg::TSignature(KeyOpAlg::DSA())
  or
  t = KeyOpAlg::TSignature(KeyOpAlg::ECDSA())
  or
  t = KeyOpAlg::TSignature(KeyOpAlg::EDDSA())
}

/**
 * Holds when the key agreement type is quantum-vulnerable.
 * Covers DH, EDH, ECDH, and ECMQV.
 */
predicate isQuantumVulnerableKeyAgreementType(Crypto::TKeyAgreementType t) {
  t = Crypto::DH()
  or
  t = Crypto::EDH()
  or
  t = Crypto::ECDH()
  or
  t = Crypto::ECMQV()
}

/**
 * Holds when the elliptic curve type is quantum-vulnerable.
 * All classical elliptic curves are broken by quantum computers.
 */
predicate isQuantumVulnerableCurveType(Crypto::EllipticCurveType t) {
  t = Crypto::NIST()
  or
  t = Crypto::SEC()
  or
  t = Crypto::CURVE25519()
  or
  t = Crypto::CURVE448()
  or
  t = Crypto::BRAINPOOL()
  or
  t = Crypto::PRIME()
  or
  t = Crypto::SM2()
  or
  t = Crypto::ES()
  or
  t = Crypto::C2()
}

/**
 * Holds when the padding scheme type is quantum-vulnerable
 * (used only with asymmetric algorithms that are quantum-vulnerable).
 */
predicate isQuantumVulnerablePaddingType(KeyOpAlg::PaddingSchemeType t) {
  t = KeyOpAlg::PKCS1_V1_5()
  or
  t = KeyOpAlg::PSS()
  or
  t = KeyOpAlg::OAEP()
}

/**
 * Holds when the symmetric cipher type is classically insecure
 * (broken regardless of quantum computing).
 */
predicate isInsecureCipherType(KeyOpAlg::TSymmetricCipherType t) {
  t = KeyOpAlg::DES()
  or
  t = KeyOpAlg::DOUBLE_DES()
  or
  t = KeyOpAlg::TRIPLE_DES()
  or
  t = KeyOpAlg::IDEA()
  or
  t = KeyOpAlg::BLOWFISH()
  or
  t = KeyOpAlg::SEED()
}

/**
 * Holds when the mode of operation is insecure.
 */
predicate isInsecureModeType(KeyOpAlg::ModeOfOperationType t) {
  t = KeyOpAlg::ECB()
  or
  t = KeyOpAlg::LRW()
  or
  t = KeyOpAlg::CFB()
  or
  t = KeyOpAlg::OFB()
}

/**
 * Holds when the hash type is classically insecure.
 */
predicate isInsecureHashType(Crypto::HashType t) { t = Crypto::SHA1() }

/**
 * Holds when the symmetric cipher type is considered secure and quantum-proof.
 */
predicate isSecureCipherType(KeyOpAlg::TSymmetricCipherType t) {
  t = KeyOpAlg::AES()
  or
  t = KeyOpAlg::TWOFISH()
  or
  t = KeyOpAlg::ARIA()
  or
  t = KeyOpAlg::CAMELLIA()
  or
  t = KeyOpAlg::CHACHA20()
  or
  t = KeyOpAlg::SALSA20()
}

/**
 * Holds when the hash type is considered secure and quantum-proof.
 */
predicate isSecureHashType(Crypto::HashType t) {
  t = Crypto::SHA2()
  or
  t = Crypto::SHA3()
}

/**
 * Gets a classification label for a key operation algorithm type.
 */
string classifyAlgorithmType(KeyOpAlg::AlgorithmType t) {
  isQuantumVulnerableAlgorithmType(t) and result = "quantum-vulnerable"
  or
  exists(KeyOpAlg::TSymmetricCipherType st | t = KeyOpAlg::TSymmetricCipher(st) |
    isInsecureCipherType(st) and result = "insecure"
    or
    isSecureCipherType(st) and result = "secure"
    or
    not isInsecureCipherType(st) and not isSecureCipherType(st) and result = "other"
  )
  or
  not isQuantumVulnerableAlgorithmType(t) and
  not t instanceof KeyOpAlg::TSymmetricCipher and
  result = "other"
}

/**
 * Gets a classification label for a key agreement type.
 */
string classifyKeyAgreementType(Crypto::TKeyAgreementType t) {
  isQuantumVulnerableKeyAgreementType(t) and result = "quantum-vulnerable"
  or
  not isQuantumVulnerableKeyAgreementType(t) and result = "other"
}
