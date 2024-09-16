/**
 * @name Missing Elements
 * @description List all elements in the source code directory that weren't extracted due to unimplemented features or parse errors.
 * @id rust/diagnostics/missing-elements
 */

import rust

/**
 * Gets a location for an `Unimplemented` node.
 */
Location getUnimplementedLocation(Unimplemented node) {
  result = node.(Locatable).getLocation()
  or
  not node instanceof Locatable and
  result instanceof EmptyLocation
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
    c =
      strictcount(Unimplemented n |
        exists(getUnimplementedLocation(n).getFile().getRelativePath()) and
        getUnimplementedLocation(n).toString() = location
      ) and
    msg = "Not yet implemented" + multipleString(c) + "."
  )
}

query predicate listMissingExpr(string location, string msg) {
  // gaps in the AST due to parse errors
  exists(int c |
    c =
      strictcount(MissingExpr e |
        exists(e.getFile().getRelativePath()) and e.getLocation().toString() = location
      ) and
    msg = "Missing expression" + multipleString(c) + "."
  )
}

query predicate listMissingPat(string location, string msg) {
  // gaps in the AST due to parse errors
  exists(int c |
    c =
      strictcount(MissingPat p |
        exists(p.getFile().getRelativePath()) and p.getLocation().toString() = location
      ) and
    msg = "Missing pattern" + multipleString(c) + "."
  )
}
