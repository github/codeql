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
    exists(PathExpr p, string rawAlgorithmName |
      this.asExpr().getExpr().(CallExpr).getFunction() = p and
      p.getResolvedCrateOrigin().matches("%/RustCrypto%") and
      p.getPath().getText() = ["new", "new_from_slice", "new_from_slices", "new_with_eff_key_len"] and
      (
        rawAlgorithmName = p.getPath().getQualifier().(Path).getText() or // todo: remove infix cast when codegenerator has been fixed
        rawAlgorithmName =
          p.getPath()
              .getQualifier()
              .getPart()
              .getGenericArgList()
              .getGenericArg(0)
              .(TypeArg)
              .getTypeRepr()
              .(PathTypeRepr)
              .getPath()
              .getPart()
              .getNameRef()
              .getText()
      ) and
      algorithmName = simplifyAlgorithmName(rawAlgorithmName)
    )
  }

  override DataFlow::Node getInitialization() { result = this }

  override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(algorithmName) }

  override DataFlow::Node getAnInput() { none() }

  override Cryptography::BlockMode getBlockMode() { result = "" }
}
