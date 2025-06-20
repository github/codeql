/**
 * @name Path resolution inconsistencies
 * @description Lists the path resolution inconsistencies in the database.  This query is intended for internal use.
 * @kind table
 * @id rust/diagnostics/path-resolution-consistency
 */

private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.PathResolutionConsistency as PathResolutionConsistency
private import codeql.rust.elements.Locatable
private import codeql.Locations
import PathResolutionConsistency

class SourceLocatable extends Locatable {
  Location getLocation() {
    if super.getLocation().fromSource()
    then result = super.getLocation()
    else result instanceof EmptyLocation
  }
}

query predicate multipleCallTargets(SourceLocatable a, SourceLocatable b) {
  PathResolutionConsistency::multipleCallTargets(a, b)
}

query predicate multiplePathResolutions(SourceLocatable a, SourceLocatable b) {
  PathResolutionConsistency::multiplePathResolutions(a, b)
}

query predicate multipleCanonicalPaths(SourceLocatable i, SourceLocatable c, string path) {
  PathResolutionConsistency::multipleCanonicalPaths(i, c, path)
}
