/**
 * Provides modeling for the `RustCrypto` family of crates (`cipher`, `digest` etc).
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow

/**
 * An operation that initializes a cipher through the `cipher::KeyInit` or
 * `cipher::KeyIvInit` trait, for example `Des::new` or `cbc::Encryptor<des::Des>::new`.
 */
class StreamCipherInit extends Cryptography::CryptographicOperation::Range, DataFlow::Node {
  string algorithmName;

  StreamCipherInit() {
    // a call to `cipher::KeyInit::new`, `cipher::KeyInit::new_from_slice`,
    // `cipher::KeyIvInit::new` or `cipher::KeyIvInit::new_from_slices`.
    exists(Path p |
      this.asExpr().getExpr().(CallExpr).getFunction().(PathExpr).getPath() = p and
      p.getResolvedCrateOrigin().matches("%/RustCrypto%") and
      p.getPart().getNameRef().getText() =
        ["new", "new_from_slice", "new_from_slices"] and
      algorithmName = p.getQualifier().getPart().getNameRef().getText()
    )
  }

  override DataFlow::Node getInitialization() { result = this }

  override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(algorithmName) }

  override DataFlow::Node getAnInput() { none() }

  override Cryptography::BlockMode getBlockMode() { result = "" }
}
