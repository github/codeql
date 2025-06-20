overlay[local?]
module;

import java

/**
 * A local predicate that always holds for the overlay variant and
 * never holds for the base variant. This is used to define local
 * predicates that behave differently for the base and overlay variant.
 */
overlay[local]
predicate isOverlay() { databaseMetadata("isOverlay", "true") }

/** Gets the raw file for a locatable. */
overlay[local]
string getRawFile(@locatable el) {
  exists(@location loc, @file file |
    hasLocation(el, loc) and
    locations_default(loc, file, _, _, _, _) and
    files(file, result)
  )
}

/** Gets the raw file for a location. */
overlay[local]
string getRawFileForLoc(@location l) {
  exists(@file f | locations_default(l, f, _, _, _, _) and files(f, result))
}

/** Holds for files fully extracted in the overlay. */
overlay[local]
predicate extractedInOverlay(string file) {
  isOverlay() and
  // The incremental Java extractor extracts skeletons without method
  // bodies for dependencies. To approximate fully extracted files in
  // the overlay, we restrict attention to files that contain an expression
  // with an enclosing callable.
  exists(@expr e | callableEnclosingExpr(e, _) and file = getRawFile(e))
}
