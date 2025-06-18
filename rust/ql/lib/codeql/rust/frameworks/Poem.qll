/**
 * Provides modeling for the `Poem` library.
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.internal.TypeInference
private import codeql.rust.internal.Type

/**
 * Parameters of a handler function
 */
private class PoemHandlerParam extends RemoteSource::Range {
  PoemHandlerParam() {
    exists(TupleStructPat param, Type t |
      this.asPat().getPat() = param.getAField() and
      t = inferType(param) and
      param.getStruct().getCanonicalPath() = ["poem::web::query::Query", "poem::web::path::Path"]
    )
  }
}
