/**
 * @name Missing Elements
 * @description List all elements that weren't extracted due to unimplemented features or parse errors.
 * @id rust/diagnostics/missing-elements
 */

import rust

/**
 * Gets `l.toString()`, but with any locations outside of the source location prefix cleaned up.
 */
bindingset[l]
string cleanLocationString(Location l) {
  if exists(l.getFile().getRelativePath()) or l instanceof EmptyLocation
  then result = l.toString()
  else l.getFile().getParentContainer().getAbsolutePath() + result = l.toString() // remove the directory from the string
}

/**
 * Gets a string along the lines of " (x2)", corresponding to the number `i`. For `i = 1`, the result is the empty string.
 */
bindingset[i]
string multipleString(int i) {
  i = 1 and result = ""
  or
  i > 1 and result = " (x" + i.toString() + ")"
}

query predicate listUnimplemented(string location, string msg) {
  // something that is not extracted yet
  exists(int c |
    c = strictcount(Unimplemented n | cleanLocationString(n.getLocation()) = location) and
    msg = "Not yet implemented" + multipleString(c) + "."
  )
}

query predicate listMissingExpr(string location, string msg) {
  // gaps in the AST due to parse errors
  exists(int c |
    c = strictcount(MissingExpr e | cleanLocationString(e.getLocation()) = location) and
    msg = "Missing expression" + multipleString(c) + "."
  )
}

query predicate listMissingPat(string location, string msg) {
  // gaps in the AST due to parse errors
  exists(int c |
    c = strictcount(MissingPat p | cleanLocationString(p.getLocation()) = location) and
    msg = "Missing pattern" + multipleString(c) + "."
  )
}
