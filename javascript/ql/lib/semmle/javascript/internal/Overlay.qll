private import javascript
private import OverlayXml

/** Holds if the database is an overlay. */
overlay[local?]
private predicate isOverlay() { databaseMetadata("isOverlay", "true") }

overlay[local?]
private string getFileFromEntity(@locatable node) {
  exists(@location loc |
    hasLocation(node, loc)
    or
    json_locations(node, loc)
    or
    yaml_locations(node, loc)
  |
    result = getFileFromLocation(loc)
  )
}

/** Holds if `file` was changed or deleted in the overlay. */
overlay[local?]
private predicate discardFile(string file) { isOverlay() and overlayChangedFiles(file) }

/** Holds if `node` is in the `file` and is part of the overlay base database. */
overlay[local?]
private predicate discardableEntity(string file, @locatable node) {
  not isOverlay() and file = getFileFromEntity(node)
}

/** Holds if `node` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
overlay[discard_entity]
private predicate discardEntity(@locatable node) {
  exists(string file | discardableEntity(file, node) and discardFile(file))
}

overlay[local?]
private string getFileFromLocation(@location loc) {
  exists(@file file |
    locations_default(loc, file, _, _, _, _) and
    files(file, result)
  )
}

/** Holds if `loc` is in the `file` and is part of the overlay base database. */
overlay[local?]
private predicate discardableLocation(string file, @location node) {
  not isOverlay() and file = getFileFromLocation(node)
}

/** Holds if `loc` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
overlay[discard_entity]
private predicate discardLocation(@location loc) {
  exists(string file | discardableLocation(file, loc) and discardFile(file))
}
