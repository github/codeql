import rust
import TestUtils

query predicate canonicalPaths(Addressable i, string answer) {
  toBeTested(i) and
  (
    answer = i.getCanonicalPath().toString()
    or
    not i.hasCanonicalPath() and answer = "None"
  )
}

query predicate resolvedPaths(Resolvable i, string answer) {
  toBeTested(i) and
  (
    answer = i.getResolvedCanonicalPath().toString()
    or
    not i.hasResolvedCanonicalPath() and answer = "None"
  )
}

query predicate resolve(Resolvable i, Addressable j) {
  toBeTested(i) and
  toBeTested(j) and
  i.getResolvedCanonicalPath() = j.getCanonicalPath()
}
