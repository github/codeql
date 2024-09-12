/**
 * @name Missing Elements
 * @description List all elements that weren't extracted due to unimplemented features or parse errors.
 * @kind diagnostic
 * @id rust/diagnostics/missing-elements
 */

import rust

query predicate listUnimplemented(AstNode n, string msg) {
  // not extracted yet
  n instanceof Unimplemented and
  msg = "Not yet implemented."
}

query predicate listMissingExpr(Expr e, string msg) {
  // gaps in the AST due to parse errors
  e instanceof MissingExpr and
  msg = "Missing expression."
}

query predicate listMissingPat(Pat p, string msg) {
  // gaps in the AST due to parse errors
  p instanceof MissingPat and
  msg = "Missing pattern."
}
