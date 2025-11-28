/**
 * Defines entity discard predicates for C++ overlay analysis.
 */

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
  // @var_decl has a direct location in the var_decls relation
  exists(@location_default loc | var_decls(e, _, _, _, loc) | result = getLocationFilePath(loc))
  //TODO: add other kinds of elements with single locations
}

/**
 * Gets the file path for an element with potentially multiple locations.
 */
overlay[local]
private string getMultiLocationFilePath(@element e) {
  // @variable gets its location(s) from its @var_decl(s)
  exists(@var_decl vd, @location_default loc | var_decls(vd, e, _, _, loc) |
    result = getLocationFilePath(loc)
  )
  //TODO: add other kinds of elements with multiple locations
}

/**
 * A local helper predicate that holds in the base variant and never in the
 * overlay variant.
 */
overlay[local]
private predicate holdsInBase() { not isOverlay() }

/**
 * Discards an element from the base variant if:
 * - It has a single location in a changed file, or
 * - All of its locations are in changed files.
 */
overlay[discard_entity]
private predicate discardElement(@element e) {
  holdsInBase() and
  (
    overlayChangedFiles(getSingleLocationFilePath(e))
    or
    forex(string path | path = getMultiLocationFilePath(e) | overlayChangedFiles(path))
  )
}
