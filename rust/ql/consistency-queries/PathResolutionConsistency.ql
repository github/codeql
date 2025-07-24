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

class SourceLocatable extends Locatable {
  SourceLocatable() { this.fromSource() }
}

query predicate multipleCallTargets(SourceLocatable a) {
  PathResolutionConsistency::multipleCallTargets(a, _)
}

query predicate multiplePathResolutions(SourceLocatable a) {
  PathResolutionConsistency::multiplePathResolutions(a, _)
}

query predicate multipleCanonicalPaths(SourceLocatable i, SourceLocatable c, string path) {
  PathResolutionConsistency::multipleCanonicalPaths(i, c, path)
}
