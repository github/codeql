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

query predicate standardPaths(Addressable i, string answer) {
  toBeTested(i) and
  exists(string namespace, string name |
    i.hasStandardPath(namespace, name) and answer = namespace + "::" + name
    or
    exists(string type |
      i.hasStandardPath(namespace, type, name) and answer = namespace + "::" + type + "::" + name
    )
  )
}

query predicate resolve(Resolvable i, Addressable j) {
  toBeTested(i) and
  toBeTested(j) and
  i.getResolvedCanonicalPath() = j.getCanonicalPath()
}
