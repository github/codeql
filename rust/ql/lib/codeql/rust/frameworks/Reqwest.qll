/**
 * Provides modeling for the `reqwest` library.
 */

private import rust
private import codeql.rust.Concepts

/**
 * A call to `reqwest::get` or `reqwest::blocking::get`.
 */
private class ReqwestGet extends RemoteSource::Range {
  ReqwestGet() {
    this.asExpr().getExpr().(CallExpr).getExpr().(PathExpr).getPath().getResolvedPath() =
      ["crate::get", "crate::blocking::get"]
  }
}
