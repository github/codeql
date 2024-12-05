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
    exists(CallExpr ce |
      this.asExpr().getExpr() = ce and
      ce.getFunction().(PathExpr).getResolvedCrateOrigin().matches("%reqwest") and
      ce.getFunction().(PathExpr).getResolvedPath() = ["crate::get", "crate::blocking::get"]
    )
  }
}
