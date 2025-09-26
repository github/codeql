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
    (hasLocation(el, loc) or xmllocations(el, loc)) and
    locations_default(loc, file, _, _, _, _) and
    files(file, result)
  )
}

/** Gets the raw file for a location. */
overlay[local]
string getRawFileForLoc(@location l) {
  exists(@file f | locations_default(l, f, _, _, _, _) and files(f, result))
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
  overlayChangedFiles(el.(DiscardableLocatable).getRawFileInBase())
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
    overlayChangedFiles(drl.getRawFileInBase()) and
    not drl.existsInOverlay()
  )
}

/** Gets the raw file for a configLocatable. */
overlay[local]
private string getRawFileForConfig(@configLocatable el) {
  exists(@location loc, @file file |
    configLocations(el, loc) and
    locations_default(loc, file, _, _, _, _) and
    files(file, result)
  )
}

overlay[local]
private string baseConfigLocatable(@configLocatable el) {
  not isOverlay() and result = getRawFileForConfig(el)
}

overlay[local]
private predicate overlayConfigExtracted(string file) {
  isOverlay() and
  exists(@configLocatable el | file = getRawFileForConfig(el))
}

overlay[discard_entity]
private predicate discardBaseConfigLocatable(@configLocatable el) {
  overlayChangedFiles(baseConfigLocatable(el))
  or
  // The config extractor is currently not incremental and may extract more
  // property files than those included in overlayChangedFiles.
  overlayConfigExtracted(baseConfigLocatable(el))
}

/**
 * An `@xmllocatable` that should be discarded in the base variant if its file is
 * extracted in the overlay variant.
 */
overlay[local]
abstract class DiscardableXmlLocatable extends @xmllocatable {
  /** Gets the raw file for an xmllocatable in base. */
  string getRawFileInBase() { not isOverlay() and result = getRawFile(this) }

  /** Gets a textual representation of this discardable xmllocatable. */
  string toString() { none() }
}

overlay[local]
private predicate overlayXmlExtracted(string file) {
  isOverlay() and
  exists(@xmllocatable el | not files(el, _) and not xmlNs(el, _, _, _) and file = getRawFile(el))
}

overlay[discard_entity]
private predicate discardXmlLocatable(@xmllocatable el) {
  overlayChangedFiles(el.(DiscardableXmlLocatable).getRawFileInBase())
  or
  // The XML extractor is currently not incremental and may extract more
  // XML files than those included in overlayChangedFiles.
  overlayXmlExtracted(el.(DiscardableXmlLocatable).getRawFileInBase())
}
