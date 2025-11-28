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

/** Holds if `e` exists in the base variant. */
overlay[local]
private predicate existsInBase(@element e) {
  not isOverlay() and
  (exists(getSingleLocationFilePath(e)) or exists(getMultiLocationFilePath(e)))
}

/**
 * Discard an element with a single location if it is in a changed file.
 */
overlay[discard_entity]
private predicate discardSingleLocationElement(@element e) {
  existsInBase(e) and
  overlayChangedFiles(getSingleLocationFilePath(e))
}

/**
 * Discard an element with multiple locations only if all its locations are in changed files.
 */
overlay[discard_entity]
private predicate discardMultiLocationElement(@element e) {
  existsInBase(e) and
  exists(getMultiLocationFilePath(e)) and
  forall(string path | path = getMultiLocationFilePath(e) | overlayChangedFiles(path))
}
