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
    exists(@var_decl vd | var_decls(vd, e, _, _, loc))
    or
    exists(@fun_decl fd | fun_decls(fd, e, _, _, loc))
    or
    exists(@type_decl td | type_decls(td, e, loc))
    or
    exists(@namespace_decl nd | namespace_decls(nd, e, loc, _))
  |
    result = getLocationFilePath(loc)
  )
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
