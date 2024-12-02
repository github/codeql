import rust
import TestUtils

query predicate canonicalPaths(Item i, string origin, string path) {
  toBeTested(i) and
  (
    origin = i.getCrateOrigin()
    or
    not i.hasCrateOrigin() and origin = "None"
  ) and
  (
    path = i.getExtendedCanonicalPath()
    or
    not i.hasExtendedCanonicalPath() and path = "None"
  )
}

query predicate resolvedPaths(Resolvable e, string origin, string path) {
  toBeTested(e) and
  (
    origin = e.getResolvedCrateOrigin()
    or
    not e.hasResolvedCrateOrigin() and origin = "None"
  ) and
  (
    path = e.getResolvedPath()
    or
    not e.hasResolvedPath() and path = "None"
  )
}
