/**
 * Provides modeling for the `RustCrypto` family of crates (`cipher`, `digest` etc).
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow

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
    // `cipher::KeyIvInit::new`, `cipher::KeyIvInit::new_from_slices` or `rc2::Rc2::new_with_eff_key_len`.
    exists(PathExpr e |
      e = this.asExpr().getExpr().(CallExpr).getFunction() and
      exists(TraitImplItemCanonicalPath path, string rawAlgorithmName |
        path = e.getResolvedCanonicalPath() and
        path.getTraitPath().getBase().hasStandardPath("crypto-common", ["KeyInit", "KeyIvInit"]) and
        path.getName() = ["new", "new_from_slice", "new_from_slices"] and
        path.getTypePath()
            .(ConcreteTypeCanonicalPath)
            .getPath()
            .getBase()
            .hasStandardPath(_, rawAlgorithmName) and
        algorithmName = simplifyAlgorithmName(rawAlgorithmName)
      )
      or
      e.resolvesToStandardPath("rc2::Rc2", "new_with_eff_key_len") and
      algorithmName = "Rc2"
    )
  }

  override DataFlow::Node getInitialization() { result = this }

  override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(algorithmName) }

  override DataFlow::Node getAnInput() { none() }

  override Cryptography::BlockMode getBlockMode() { result = "" }
}
