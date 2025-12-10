overlay[local]
module;

/**
 * A local predicate that always holds for the overlay variant and never holds for the base variant.
 * This is used to define local predicates that behave differently for the base and overlay variant.
 */
private predicate isOverlay() { databaseMetadata("isOverlay", "true") }

private string getXmlFile(@xmllocatable locatable) {
  exists(@location_default location, @file file | xmllocations(locatable, location) |
    locations_default(location, file, _, _, _, _) and
    files(file, result)
  )
}

private string getXmlFileInBase(@xmllocatable locatable) {
  not isOverlay() and
  result = getXmlFile(locatable)
}

/**
 * Holds if the given `file` was extracted as part of the overlay and was extracted by the HTML/XML
 * extractor.
 */
private predicate overlayXmlExtracted(string file) {
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
  exists(string file | file = getXmlFileInBase(locatable) |
    overlayChangedFiles(file)
    or
    // The HTML/XML extractor is currently not incremental and may extract more files than those
    // included in overlayChangedFiles.
    overlayXmlExtracted(file)
  )
}
