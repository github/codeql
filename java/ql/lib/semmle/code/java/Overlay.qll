/**
 * Defines entity discard predicates for Java overlay analysis.
 */
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
  // numlines is used to restrict attention to fully extracted files and
  // ignore skeleton extracted files in the overlay
  exists(@locatable l | numlines(l, _, _, _) and file = getRawFile(l))
}

/**
 * A `@locatable` that should be discarded in the base variant if its file is
 * extracted in the overlay variant.
 */
overlay[local]
abstract class DiscardableLocatable extends @locatable {
  /** Gets the raw file for a locatable in base. */
  string getRawFileInBase() { not isOverlay() and result = getRawFile(this) }

  /** Gets a textual representation of this discardable locatable. */
  string toString() { none() }
}

overlay[discard_entity]
private predicate discardLocatable(@locatable el) {
  extractedInOverlay(el.(DiscardableLocatable).getRawFileInBase())
}

/**
 * A `@locatable` that should be discarded in the base variant if its file is
 * extracted in the overlay variant and it is itself not extracted in the
 * overlay, that is, it is deleted in the overlay.
 */
overlay[local]
abstract class DiscardableReferableLocatable extends @locatable {
  /** Gets the raw file for a locatable in base. */
  string getRawFileInBase() { not isOverlay() and result = getRawFile(this) }

  /** Holds if the locatable exists in the overlay. */
  predicate existsInOverlay() { isOverlay() and exists(this) }

  /** Gets a textual representation of this discardable locatable. */
  string toString() { none() }
}

overlay[discard_entity]
private predicate discardReferableLocatable(@locatable el) {
  exists(DiscardableReferableLocatable drl | drl = el |
    extractedInOverlay(drl.getRawFileInBase()) and
    not drl.existsInOverlay()
  )
}
