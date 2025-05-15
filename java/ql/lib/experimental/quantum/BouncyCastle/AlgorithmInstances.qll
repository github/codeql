import java
import experimental.quantum.Language
import AlgorithmInstances.SignatureAlgorithmInstances

SignatureAlgorithmInstance getSignatureAlgorithmInstanceFromType(Type t) {
  t.getName() = "Ed25519Signer" and result instanceof Ed25519AlgorithmInstance
  or
  t.getName() = "Ed448Signer" and result instanceof Ed448AlgorithmInstance
}

