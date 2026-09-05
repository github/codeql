/**
 * @name All cryptographic classifications
 * @description Reports every cryptographic element classified as quantum-vulnerable, insecure, or secure
 *              using all predicates in the QuantumCryptoClassification library.
 * @id java/quantum/examples/demo/all-classifications
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import QuantumCryptoClassification

/**
 * Gets a short label for logical grouping of each finding category.
 */
string categoryLabel(string cat) {
  cat = "Algorithm" and result = "Algorithm"
  or
  cat = "KeyAgreement" and result = "KeyAgreement"
  or
  cat = "Curve" and result = "Curve"
  or
  cat = "Padding" and result = "Padding"
  or
  cat = "Mode" and result = "Mode"
  or
  cat = "Hash" and result = "Hash"
  or
  cat = "KeySize" and result = "KeySize"
}

from Crypto::NodeBase node, string category, string classification, string detail
where
  // ---- Key-operation algorithms (quantum-vulnerable / insecure / secure) ----
  exists(Crypto::KeyOperationAlgorithmNode alg |
    node = alg and
    category = "Algorithm" and
    classification = classifyAlgorithmType(alg.getAlgorithmType()) and
    classification != "other" and
    detail = alg.getAlgorithmName()
  )
  or
  // ---- Key-agreement algorithms (quantum-vulnerable) ----
  exists(Crypto::KeyAgreementAlgorithmNode kaAlg |
    node = kaAlg and
    category = "KeyAgreement" and
    classification = classifyKeyAgreementType(kaAlg.getKeyAgreementType()) and
    classification != "other" and
    detail = kaAlg.getAlgorithmName()
  )
  or
  // ---- Elliptic curves (quantum-vulnerable) ----
  exists(Crypto::EllipticCurveNode curve |
    node = curve and
    category = "Curve" and
    isQuantumVulnerableCurveType(curve.getEllipticCurveType()) and
    classification = "quantum-vulnerable" and
    detail = curve.getAlgorithmName() + " (" + curve.getEllipticCurveType().toString() + ")"
  )
  or
  // ---- Padding (quantum-vulnerable) ----
  exists(Crypto::PaddingAlgorithmNode pad |
    node = pad and
    category = "Padding" and
    isQuantumVulnerablePaddingType(pad.getPaddingType()) and
    classification = "quantum-vulnerable" and
    detail = pad.getPaddingType().toString()
  )
  or
  // ---- Block modes (insecure) ----
  exists(Crypto::ModeOfOperationAlgorithmNode mode |
    node = mode and
    category = "Mode" and
    isInsecureModeType(mode.getModeType()) and
    classification = "insecure" and
    detail = mode.getModeType().toString()
  )
  or
  // ---- Hash algorithms (insecure / secure) ----
  exists(Crypto::HashAlgorithmNode hash |
    node = hash and
    category = "Hash" and
    (
      isInsecureHashType(hash.getHashType()) and
      classification = "insecure" and
      detail = hash.getHashType().toString()
      or
      isSecureHashType(hash.getHashType()) and
      classification = "secure" and
      detail =
        hash.getHashType().toString() +
          any(string s |
            if exists(hash.getDigestLength())
            then s = " (" + hash.getDigestLength().toString() + "-bit)"
            else s = ""
          )
    )
  )
  or
  // ---- Key sizes with quantum-vulnerable algorithms ----
  exists(Crypto::KeyCreationOperationNode keygen, Crypto::AlgorithmNode alg, int keySize |
    node = keygen and
    category = "KeySize" and
    classification = "quantum-vulnerable" and
    alg = keygen.getAKnownAlgorithm() and
    keygen.getAKeySizeSource().asElement().(Literal).getValue().toInt() = keySize and
    (
      exists(Crypto::KeyOperationAlgorithmNode keyAlg |
        keyAlg = alg and isQuantumVulnerableAlgorithmType(keyAlg.getAlgorithmType())
      )
      or
      exists(Crypto::KeyAgreementAlgorithmNode kaAlg |
        kaAlg = alg and isQuantumVulnerableKeyAgreementType(kaAlg.getKeyAgreementType())
      )
    ) and
    detail = keySize.toString() + "-bit key for " + alg.getAlgorithmName()
  )
select node, "[" + classification + "] " + categoryLabel(category) + ": " + detail
