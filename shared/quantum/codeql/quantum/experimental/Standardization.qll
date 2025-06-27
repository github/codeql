/**
 * The `KeyOpAlg` module defines key operation algorithms types (e.g., symmetric ciphers, signatures, etc.)
 * and provides mapping of those types to string names and structural properties.
 */
module Types {
  module KeyOpAlg {
    /**
     * An algorithm used in key operations.
     */
    newtype TAlgorithm =
      TSymmetricCipher(TSymmetricCipherType t) or
      TAsymmetricCipher(TAsymmetricCipherType t) or
      TSignature(TSignatureAlgorithmType t) or
      TKeyEncapsulation(TKemAlgorithmType t) or
      TUnknownKeyOperationAlgorithmType()

    // Parameterized algorithm types
    newtype TSymmetricCipherType =
      AES() or
      ARIA() or
      BLOWFISH() or
      CAMELLIA() or
      CAST5() or
      CHACHA20() or
      DES() or
      DESX() or
      GOST() or
      IDEA() or
      KUZNYECHIK() or
      MAGMA() or
      TRIPLE_DES() or
      DOUBLE_DES() or
      RC2() or
      RC4() or
      RC5() or
      SEED() or
      SM4() or
      OtherSymmetricCipherType()

    newtype TAsymmetricCipherType =
      RSA() or
      OtherAsymmetricCipherType()

    newtype TSignatureAlgorithmType =
      DSA() or
      ECDSA() or
      EDDSA() or // e.g., ED25519 or ED448
      OtherSignatureAlgorithmType()

    newtype TKemAlgorithmType =
      KYBER() or
      FRODO_KEM() or
      OtherKemAlgorithmType()

    newtype TCipherStructureType =
      Block() or
      Stream() or
      UnknownCipherStructureType()

    class CipherStructureType extends TCipherStructureType {
      string toString() {
        result = "Block" and this = Block()
        or
        result = "Stream" and this = Stream()
        or
        result = "Unknown" and this = UnknownCipherStructureType()
      }
    }

    private predicate symmetric_cipher_to_name_and_structure(
      TSymmetricCipherType type, string name, CipherStructureType s
    ) {
      type = AES() and name = "AES" and s = Block()
      or
      type = ARIA() and name = "ARIA" and s = Block()
      or
      type = BLOWFISH() and name = "Blowfish" and s = Block()
      or
      type = CAMELLIA() and name = "Camellia" and s = Block()
      or
      type = CAST5() and name = "CAST5" and s = Block()
      or
      type = CHACHA20() and name = "ChaCha20" and s = Stream()
      or
      type = DES() and name = "DES" and s = Block()
      or
      type = DESX() and name = "DESX" and s = Block()
      or
      type = GOST() and name = "GOST" and s = Block()
      or
      type = IDEA() and name = "IDEA" and s = Block()
      or
      type = KUZNYECHIK() and name = "Kuznyechik" and s = Block()
      or
      type = MAGMA() and name = "Magma" and s = Block()
      or
      type = TRIPLE_DES() and name = "TripleDES" and s = Block()
      or
      type = DOUBLE_DES() and name = "DoubleDES" and s = Block()
      or
      type = RC2() and name = "RC2" and s = Block()
      or
      type = RC4() and name = "RC4" and s = Stream()
      or
      type = RC5() and name = "RC5" and s = Block()
      or
      type = SEED() and name = "SEED" and s = Block()
      or
      type = SM4() and name = "SM4" and s = Block()
      or
      type = OtherSymmetricCipherType() and
      name = "UnknownSymmetricCipher" and
      s = UnknownCipherStructureType()
    }

    class AlgorithmType extends TAlgorithm {
      string toString() {
        // Symmetric cipher algorithm
        symmetric_cipher_to_name_and_structure(this.(SymmetricCipherAlgorithmType).getType(),
          result, _)
        or
        // Asymmetric cipher algorithms
        this = TAsymmetricCipher(RSA()) and result = "RSA"
        or
        this = TAsymmetricCipher(OtherAsymmetricCipherType()) and result = "UnknownAsymmetricCipher"
        or
        // Signature algorithms
        this = TSignature(DSA()) and result = "DSA"
        or
        this = TSignature(ECDSA()) and result = "ECDSA"
        or
        this = TSignature(EDDSA()) and result = "EDSA"
        or
        this = TSignature(OtherSignatureAlgorithmType()) and result = "UnknownSignature"
        or
        // Key Encapsulation Mechanisms
        this = TKeyEncapsulation(KYBER()) and result = "Kyber"
        or
        this = TKeyEncapsulation(FRODO_KEM()) and result = "FrodoKEM"
        or
        this = TKeyEncapsulation(OtherKemAlgorithmType()) and result = "UnknownKEM"
        or
        // Unknown
        this = TUnknownKeyOperationAlgorithmType() and result = "Unknown"
      }

      int getImplicitKeySize() {
        this = TSymmetricCipher(DES()) and result = 56
        or
        this = TSymmetricCipher(DESX()) and result = 184
        or
        this = TSymmetricCipher(DOUBLE_DES()) and result = 112
        or
        this = TSymmetricCipher(TRIPLE_DES()) and result = 168
        or
        this = TSymmetricCipher(CHACHA20()) and result = 256
        or
        this = TSymmetricCipher(IDEA()) and result = 128
        or
        this = TSymmetricCipher(KUZNYECHIK()) and result = 256
        or
        this = TSymmetricCipher(MAGMA()) and result = 256
        or
        this = TSymmetricCipher(SM4()) and result = 128
        or
        this = TSymmetricCipher(SEED()) and result = 128
      }
    }

    class SymmetricCipherAlgorithmType extends AlgorithmType, TSymmetricCipher {
      TSymmetricCipherType type;

      SymmetricCipherAlgorithmType() { this = TSymmetricCipher(type) }

      TSymmetricCipherType getType() { result = type }

      TCipherStructureType getStructureType() {
        symmetric_cipher_to_name_and_structure(type, _, result)
      }
    }

    class AsymmetricCipherAlgorithmType extends AlgorithmType, TAsymmetricCipher {
      TAsymmetricCipherType type;

      AsymmetricCipherAlgorithmType() { this = TAsymmetricCipher(type) }

      TAsymmetricCipherType getType() { result = type }
    }

    newtype TModeOfOperationType =
      ECB() or // Not secure, widely used
      CBC() or // Vulnerable to padding oracle attacks
      CFB() or
      GCM() or // Widely used AEAD mode (TLS 1.3, SSH, IPsec)
      CTR() or // Fast stream-like encryption (SSH, disk encryption)
      XTS() or // Standard for full-disk encryption (BitLocker, LUKS, FileVault)
      CCM() or // Used in lightweight cryptography (IoT, WPA2)
      SIV() or // Misuse-resistant encryption, used in secure storage
      OCB() or // Efficient AEAD mode
      OFB() or
      OtherMode()

    class ModeOfOperationType extends TModeOfOperationType {
      string toString() {
        this = ECB() and result = "ECB"
        or
        this = CBC() and result = "CBC"
        or
        this = GCM() and result = "GCM"
        or
        this = CTR() and result = "CTR"
        or
        this = XTS() and result = "XTS"
        or
        this = CCM() and result = "CCM"
        or
        this = SIV() and result = "SIV"
        or
        this = OCB() and result = "OCB"
        or
        this = CFB() and result = "CFB"
        or
        this = OFB() and result = "OFB"
      }
    }

    newtype TPaddingSchemeType =
      PKCS1_V1_5() or // RSA encryption/signing padding
      PSS() or
      PKCS7() or // Standard block cipher padding (PKCS5 for 8-byte blocks)
      ANSI_X9_23() or // Zero-padding except last byte = padding length
      NoPadding() or // Explicit no-padding
      OAEP() or // RSA OAEP padding
      OtherPadding()

    class PaddingSchemeType extends TPaddingSchemeType {
      string toString() {
        this = ANSI_X9_23() and result = "ANSI_X9_23"
        or
        this = NoPadding() and result = "NoPadding"
        or
        this = OAEP() and result = "OAEP"
        or
        this = PKCS1_V1_5() and result = "PKCS1_v1_5"
        or
        this = PKCS7() and result = "PKCS7"
        or
        this = PSS() and result = "PSS"
        or
        this = OtherPadding() and result = "UnknownPadding"
      }
    }
  }

  newtype THashType =
    BLAKE2B() or
    BLAKE2S() or
    GOST_HASH() or
    MD2() or
    MD4() or
    MD5() or
    MDC2() or
    POLY1305() or
    SHA1() or
    SHA2() or
    SHA3() or
    SHAKE() or
    SM3() or
    RIPEMD160() or
    WHIRLPOOL() or
    OtherHashType()

  class HashType extends THashType {
    final string toString() {
      this = BLAKE2B() and result = "BLAKE2B"
      or
      this = BLAKE2S() and result = "BLAKE2S"
      or
      this = RIPEMD160() and result = "RIPEMD160"
      or
      this = MD2() and result = "MD2"
      or
      this = MD4() and result = "MD4"
      or
      this = MD5() and result = "MD5"
      or
      this = POLY1305() and result = "POLY1305"
      or
      this = SHA1() and result = "SHA1"
      or
      this = SHA2() and result = "SHA2"
      or
      this = SHA3() and result = "SHA3"
      or
      this = SHAKE() and result = "SHAKE"
      or
      this = SM3() and result = "SM3"
      or
      this = WHIRLPOOL() and result = "WHIRLPOOL"
      or
      this = OtherHashType() and result = "UnknownHash"
    }
  }

  newtype TMacType =
    HMAC() or
    CMAC() or
    OtherMacType()

  class MacType extends TMacType {
    string toString() {
      this = HMAC() and result = "HMAC"
      or
      this = CMAC() and result = "CMAC"
      or
      this = OtherMacType() and result = "UnknownMacType"
    }
  }

  // Key agreement algorithms
  newtype TKeyAgreementType =
    DH() or // Diffie-Hellman
    EDH() or // Ephemeral Diffie-Hellman
    ECDH() or // Elliptic Curve Diffie-Hellman
    // NOTE: for now ESDH is considered simply EDH
    //ESDH() or // Ephemeral-Static Diffie-Hellman
    // Note: x25519 and x448 are applications of ECDH
    OtherKeyAgreementType()

  class KeyAgreementType extends TKeyAgreementType {
    string toString() {
      this = DH() and result = "DH"
      or
      this = EDH() and result = "EDH"
      or
      this = ECDH() and result = "ECDH"
      or
      this = OtherKeyAgreementType() and result = "UnknownKeyAgreementType"
    }
  }

  /**
   * Elliptic curve algorithms
   */
  newtype TEllipticCurveFamilyType =
    NIST() or
    SEC() or
    NUMS() or
    PRIME() or
    BRAINPOOL() or
    CURVE25519() or
    CURVE448() or
    C2() or
    SM2() or
    ES() or
    OtherEllipticCurveType()

  class EllipticCurveFamilyType extends TEllipticCurveFamilyType {
    string toString() {
      this = NIST() and result = "NIST"
      or
      this = SEC() and result = "SEC"
      or
      this = NUMS() and result = "NUMS"
      or
      this = PRIME() and result = "PRIME"
      or
      this = BRAINPOOL() and result = "BRAINPOOL"
      or
      this = CURVE25519() and result = "CURVE25519"
      or
      this = CURVE448() and result = "CURVE448"
      or
      this = C2() and result = "C2"
      or
      this = SM2() and result = "SM2"
      or
      this = ES() and result = "ES"
      or
      this = OtherEllipticCurveType() and result = "UnknownEllipticCurveType"
    }
  }

  private predicate isBrainpoolCurve(string curveName, int keySize) {
    // ALL BRAINPOOL CURVES
    keySize in [160, 192, 224, 256, 320, 384, 512] and
    (
      curveName = "BRAINPOOLP" + keySize + "R1"
      or
      curveName = "BRAINPOOLP" + keySize + "T1"
    )
  }

  private predicate isSecCurve(string curveName, int keySize) {
    // ALL SEC CURVES
    keySize in [112, 113, 128, 131, 160, 163, 192, 193, 224, 233, 239, 256, 283, 384, 409, 521, 571] and
    exists(string suff | suff in ["R1", "R2", "K1"] |
      curveName = "SECT" + keySize + suff or
      curveName = "SECP" + keySize + suff
    )
  }

  private predicate isC2Curve(string curveName, int keySize) {
    // ALL C2 CURVES
    keySize in [163, 176, 191, 208, 239, 272, 304, 359, 368, 431] and
    exists(string pre, string suff |
      pre in ["PNB", "ONB", "TNB"] and suff in ["V1", "V2", "V3", "V4", "V5", "W1", "R1"]
    |
      curveName = "C2" + pre + keySize + suff
    )
  }

  private predicate isPrimeCurve(string curveName, int keySize) {
    // ALL PRIME CURVES
    keySize in [192, 239, 256] and
    exists(string suff | suff in ["V1", "V2", "V3"] | curveName = "PRIME" + keySize + suff)
  }

  private predicate isNumsCurve(string curveName, int keySize) {
    // ALL NUMS CURVES
    keySize in [256, 384, 512] and
    exists(string suff | suff = "T1" | curveName = "NUMSP" + keySize + suff)
  }

  /**
   * Holds if `name` corresponds to a known elliptic curve.
   *
   * Note: As an exception, this predicate may be used for library modeling, as curve names are largely standardized.
   *
   * When modeling, verify that this predicate offers sufficient coverage for the library and handle edge-cases.
   */
  bindingset[curveName]
  predicate isEllipticCurveAlgorithmName(string curveName) {
    ellipticCurveNameToKnownKeySizeAndFamilyMapping(curveName, _, _)
  }

  /**
   * Relates elliptic curve names to their key size and family.
   *
   * Note: As an exception, this predicate may be used for library modeling, as curve names are largely standardized.
   *
   * When modeling, verify that this predicate offers sufficient coverage for the library and handle edge-cases.
   */
  bindingset[rawName]
  predicate ellipticCurveNameToKnownKeySizeAndFamilyMapping(
    string rawName, int keySize, TEllipticCurveFamilyType curveFamily
  ) {
    exists(string curveName | curveName = rawName.toUpperCase() |
      isSecCurve(curveName, keySize) and curveFamily = SEC()
      or
      isBrainpoolCurve(curveName, keySize) and curveFamily = BRAINPOOL()
      or
      isC2Curve(curveName, keySize) and curveFamily = C2()
      or
      isPrimeCurve(curveName, keySize) and curveFamily = PRIME()
      or
      isNumsCurve(curveName, keySize) and curveFamily = NUMS()
      or
      curveName = "ES256" and keySize = 256 and curveFamily = ES()
      or
      curveName = "CURVE25519" and keySize = 255 and curveFamily = CURVE25519()
      or
      curveName = "CURVE448" and keySize = 448 and curveFamily = CURVE448()
      or
      // TODO: separate these into key agreement logic or sign/verify (ECDSA / ECDH)
      // or
      // curveName = "X25519" and keySize = 255 and curveFamily = CURVE25519()
      // or
      // curveName = "ED25519" and keySize = 255 and curveFamily = CURVE25519()
      // or
      // curveName = "ED448" and keySize = 448 and curveFamily = CURVE448()
      // or
      // curveName = "X448" and keySize = 448 and curveFamily = CURVE448()
      curveName = "SM2" and keySize in [256, 512] and curveFamily = SM2()
    )
  }
}
