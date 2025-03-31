/**
 * Provides modeling for the `Poem` library.
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow

/**
 * Parameters of a handler function
 */
private class PoemHandlerParam extends RemoteSource::Range {
  PoemHandlerParam() {
    exists(TupleStructPat param |
      param.getResolvedPath() = ["crate::web::query::Query", "crate::web::path::Path"]
    |
      this.asPat().getPat() = param.getAField()
    )
  }
}
