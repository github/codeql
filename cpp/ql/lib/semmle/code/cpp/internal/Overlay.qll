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

/** Gets the file path for a location. */
overlay[local]
private string getLocationFilePath(@location_default loc) {
  exists(@file file | locations_default(loc, file, _, _, _, _) | files(file, result))
}

/**
 * Gets the file path for an element in the base variant.
 */
overlay[local]
private string getElementPathInBase(@element e) {
  not isOverlay() and
  exists(@location_default loc |
    // Direct location (declarations)
    var_decls(e, _, _, _, loc)
    or
    // Indirect location (entities)
    exists(@var_decl vd | var_decls(vd, e, _, _, _) | var_decls(vd, _, _, _, loc))
  |
    result = getLocationFilePath(loc)
  )
}

/**
 * Discard any element from the base that is in a changed file.
 */
overlay[discard_entity]
private predicate discardElement(@element e) { overlayChangedFiles(getElementPathInBase(e)) }
