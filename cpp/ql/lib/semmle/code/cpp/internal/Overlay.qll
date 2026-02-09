/**
 * Defines entity discard predicates for C++ overlay analysis.
 */

private import OverlayXml

/**
 * Holds always for the overlay variant and never for the base variant.
 * This local predicate is used to define local predicates that behave
 * differently for the base and overlay variant.
 */
overlay[local]
predicate isOverlay() { databaseMetadata("isOverlay", "true") }

overlay[local]
private string getLocationFilePath(@location_default loc) {
  exists(@file file | locations_default(loc, file, _, _, _, _) | files(file, result))
}

/**
 * Gets the file path for an element with a single location.
 */
overlay[local]
private string getSingleLocationFilePath(@element e) {
  exists(@location_default loc |
    var_decls(e, _, _, _, loc)
    or
    fun_decls(e, _, _, _, loc)
    or
    type_decls(e, _, loc)
    or
    namespace_decls(e, _, loc, _)
    or
    macroinvocations(e, _, loc, _)
    or
    preprocdirects(e, _, loc)
  |
    result = getLocationFilePath(loc)
  )
}

/**
 * Gets the file path for an element with potentially multiple locations.
 */
overlay[local]
private string getMultiLocationFilePath(@element e) {
  exists(@location_default loc |
    var_decls(_, e, _, _, loc)
    or
    fun_decls(_, e, _, _, loc)
    or
    type_decls(_, e, loc)
    or
    namespace_decls(_, e, loc, _)
  |
    result = getLocationFilePath(loc)
  )
}

/**
 * A local helper predicate that holds in the base variant and never in the
 * overlay variant.
 */
overlay[local]
private predicate isBase() { not isOverlay() }

/**
 * Holds if `path` was extracted in the overlay database.
 */
overlay[local]
private predicate overlayHasFile(string path) {
  isOverlay() and
  files(_, path) and
  path != ""
}

/**
 * Discards an element from the base variant if:
 * - It has a single location in a file extracted in the overlay, or
 * - All of its locations are in files extracted in the overlay.
 */
overlay[discard_entity]
private predicate discardElement(@element e) {
  isBase() and
  (
    overlayHasFile(getSingleLocationFilePath(e))
    or
    forex(string path | path = getMultiLocationFilePath(e) | overlayHasFile(path))
  )
}
