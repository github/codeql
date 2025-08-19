/**
 * Provides modeling for the `RustCrypto` family of crates (`cipher`, `digest` etc).
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.internal.TypeInference
private import codeql.rust.internal.Type

bindingset[algorithmName]
private string simplifyAlgorithmName(string algorithmName) {
  // the cipher library gives triple-DES names like "TdesEee2" and "TdesEde2"
  if algorithmName.matches("Tdes%") then result = "3des" else result = algorithmName
}

/**
 * An operation that initializes a cipher through the `cipher::KeyInit` or
 * `cipher::KeyIvInit` trait, for example `Des::new` or `cbc::Encryptor<des::Des>::new`.
 */
class StreamCipherInit extends Cryptography::CryptographicOperation::Range {
  string algorithmName;

  StreamCipherInit() {
    // a call to `cipher::KeyInit::new`, `cipher::KeyInit::new_from_slice`,
    // `cipher::KeyIvInit::new`, `cipher::KeyIvInit::new_from_slices`, `rc2::Rc2::new_with_eff_key_len` or similar.
    exists(CallExprBase ce, string rawAlgorithmName |
      ce = this.asExpr().getExpr() and
      ce.getStaticTarget().getName().getText() =
        ["new", "new_from_slice", "new_with_eff_key_len", "new_from_slices"] and
      // extract the algorithm name from the type of `ce` or its receiver.
      exists(Type t, TypePath tp |
        t = inferType([ce, ce.(MethodCallExpr).getReceiver()], tp) and
        rawAlgorithmName =
          t.(StructType).asItemNode().(Addressable).getCanonicalPath().splitAt("::")
      ) and
      algorithmName = simplifyAlgorithmName(rawAlgorithmName) and
      // only match a known cryptographic algorithm
      any(Cryptography::CryptographicAlgorithm alg).matchesName(algorithmName)
    )
  }

  override DataFlow::Node getInitialization() { result = this }

  override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(algorithmName) }

  override DataFlow::Node getAnInput() { none() }

  override Cryptography::BlockMode getBlockMode() { result = "" }
}
