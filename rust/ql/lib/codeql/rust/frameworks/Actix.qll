/**
 * Provides modeling for the `Actix` library.
 */

 private import rust
 private import codeql.rust.Concepts
 private import codeql.rust.dataflow.DataFlow
 
 /**
  * Parameters of a handler function
  */
 private class ActixHandlerParam extends RemoteSource::Range {
   ActixHandlerParam() {
     exists(TupleStructPat param |
       param.getResolvedPath() = ["crate::types::query::Query"]
     |
       this.asPat().getPat() = param.getAField()
     )
   }
 }