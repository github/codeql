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
  file = getFile(locatable) and
  // Avoid discarding @file entities, since they are shared between base and overlay.
  not locatable instanceof @file
}

/**
 * Holds if the given `path` is for a file in the base database whose entities should be discarded.
 */
bindingset[path]
private predicate discardableFile(string path) {
  isOverlay() and
  (
    overlayChangedFiles(path)
    or
    // The extractor unconditionally extracts files outside of the source directory (these are
    // typically cgo-processed source files), so all entities in such files should be discarded.
    not exists(string srcLoc | sourceLocationPrefix(srcLoc) |
      path.substring(0, srcLoc.length()) = srcLoc
    )
  )
}

/**
 * Holds if the given `locatable` should be discarded, because it is part of the overlay base and is
 * in a file that was also extracted as part of the overlay database.
 */
overlay[discard_entity]
private predicate discardLocatable(@locatable locatable) {
  exists(@file file, string path | files(file, path) |
    discardableLocatable(file, locatable) and discardableFile(path)
  )
}

private @file getXmlFile(@xmllocatable locatable) {
  exists(@location_default location | xmllocations(locatable, location) |
    locations_default(location, result, _, _, _, _)
  )
}

private @file getXmlFileInBase(@xmllocatable locatable) {
  not isOverlay() and
  result = getXmlFile(locatable)
}

/**
 * Holds if the given `file` was extracted as part of the overlay and was extracted by the HTML/XML
 * extractor.
 */
private predicate overlayXmlExtracted(@file file) {
  isOverlay() and
  exists(@xmllocatable locatable |
    not files(locatable, _) and not xmlNs(locatable, _, _, _) and file = getXmlFile(locatable)
  )
}

/**
 * Holds if the given XML `locatable` should be discarded, because it is part of the overlay base
 * and is in a file that was also extracted as part of the overlay database.
 */
overlay[discard_entity]
private predicate discardXmlLocatable(@xmllocatable locatable) {
  exists(@file file | file = getXmlFileInBase(locatable) |
    exists(string path | files(file, path) | overlayChangedFiles(path))
    or
    // The HTML/XML extractor is currently not incremental and may extract more files than those
    // included in overlayChangedFiles.
    overlayXmlExtracted(file)
  )
}
