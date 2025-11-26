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

overlay[local]
private class DiscardableEntityBase extends @element {
  /** Gets the path to the file in which this element occurs. */
  abstract string getFilePath();

  /** Holds if this element exists in the base variant. */
  predicate existsInBase() { not isOverlay() }

  /** Gets a textual representation of this discardable element. */
  string toString() { none() }
}

/**
 * Discard an entity from the base if all its locations are in changed files.
 * Entities with at least one location in an unchanged file are kept.
 */
overlay[discard_entity]
private predicate discardEntity(@element e) {
  e =
    any(DiscardableEntityBase de |
      de.existsInBase() and
      overlayChangedFiles(de.getFilePath()) and
      // Only discard if ALL file paths are in changed files
      forall(string path | path = de.getFilePath() | overlayChangedFiles(path))
    )
}

/** A discardable variable declaration entry. */
overlay[local]
private class DiscardableVarDecl extends DiscardableEntityBase instanceof @var_decl {
  override string getFilePath() {
    exists(@location_default loc | var_decls(this, _, _, _, loc) |
      result = getLocationFilePath(loc)
    )
  }
}

/** A discardable variable. */
overlay[local]
private class DiscardableVariable extends DiscardableEntityBase instanceof @variable {
  override string getFilePath() {
    exists(@var_decl vd, @location_default loc | var_decls(vd, this, _, _, loc) |
      result = getLocationFilePath(loc)
    )
  }
}
