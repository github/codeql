/**
 * Defines entity discard predicates for Go overlay analysis.
 */
overlay[local]
module;

/**
 * A local predicate that always holds for the overlay variant and never holds for the base variant.
 * This is used to define local predicates that behave differently for the base and overlay variant.
 */
private predicate isOverlay() { databaseMetadata("isOverlay", "true") }

/** Gets the file containing the given `locatable`. */
private @file getFile(@locatable locatable) {
  exists(@location_default location | has_location(locatable, location) |
    locations_default(location, result, _, _, _, _)
  )
}

/** Holds if the `locatable` is in the `file` and is part of the overlay base database. */
private predicate discardableLocatable(@file file, @locatable locatable) {
  not isOverlay() and
  file = getFile(locatable)
}

/**
 * Holds if the given `locatable` should be discarded, because it is part of the overlay base and is
 * in a file that was also extracted as part of the overlay database.
 */
overlay[discard_entity]
private predicate discardLocatable(@locatable locatable) {
  exists(@file file, string path | files(file, path) |
    discardableLocatable(file, locatable) and overlayChangedFiles(path)
  )
}
