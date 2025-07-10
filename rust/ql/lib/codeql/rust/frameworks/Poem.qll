/**
 * Provides modeling for the `Poem` library.
 */

private import rust
private import codeql.rust.Concepts

/**
 * Parameters of a handler function
 */
private class PoemHandlerParam extends RemoteSource::Range {
  PoemHandlerParam() {
    exists(TupleStructPat param |
      this.asPat().getPat() = param.getAField() and
      param.getStruct().getCanonicalPath() = ["poem::web::query::Query", "poem::web::path::Path"]
    )
  }
}
