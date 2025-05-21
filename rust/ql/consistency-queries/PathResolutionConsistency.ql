/**
 * @name Path resolution inconsistencies
 * @description Lists the path resolution inconsistencies in the database.  This query is intended for internal use.
 * @kind table
 * @id rust/diagnostics/path-resolution-consistency
 */

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

query predicate multipleMethodCallTargets(SourceLocatable a, SourceLocatable b) {
  PathResolutionConsistency::multipleMethodCallTargets(a, b)
}

query predicate multiplePathResolutions(SourceLocatable a, SourceLocatable b) {
  PathResolutionConsistency::multiplePathResolutions(a, b)
}
