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
 * An element with a single location. Discard if in a changed file.
 */
overlay[local]
abstract private class Discardable extends @element {
  abstract string getFilePath();

  predicate existsInBase() { not isOverlay() }

  string toString() { none() }
}

overlay[discard_entity]
private predicate discardable(@element e) {
  e = any(Discardable d | d.existsInBase() and overlayChangedFiles(d.getFilePath()))
}

/**
 * An element with potentially multiple locations, e.g., variables, functions and types.
 * Discard only if all locations are in changed files.
 */
overlay[local]
abstract private class MultiDiscardable extends @element {
  abstract string getFilePath();

  predicate existsInBase() { not isOverlay() }

  string toString() { none() }
}

overlay[discard_entity]
private predicate multiDiscardable(@element e) {
  e =
    any(MultiDiscardable d |
      d.existsInBase() and
      forall(string path | path = d.getFilePath() | overlayChangedFiles(path))
    )
}

overlay[local]
private class DiscardableVarDecl extends Discardable instanceof @var_decl {
  override string getFilePath() {
    exists(@location_default loc | var_decls(this, _, _, _, loc) |
      result = getLocationFilePath(loc)
    )
  }
}

overlay[local]
private class DiscardableVariable extends MultiDiscardable instanceof @variable {
  override string getFilePath() {
    exists(@var_decl vd, @location_default loc | var_decls(vd, this, _, _, loc) |
      result = getLocationFilePath(loc)
    )
  }
}
