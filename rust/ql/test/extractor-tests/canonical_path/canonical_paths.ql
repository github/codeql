import rust
import TestUtils

query predicate canonicalPaths(Addressable i, string answer, string cls) {
  toBeTested(i) and
  (
    exists(CanonicalPath p |
      p = i.getCanonicalPath() and answer = p.toString() and cls = p.getPrimaryQlClasses()
    )
    or
    not i.hasCanonicalPath() and answer = "None" and cls = ""
  )
}

query predicate resolvedPaths(Resolvable i, string answer, string cls) {
  toBeTested(i) and
  (
    exists(CanonicalPath p |
      p = i.getResolvedCanonicalPath() and answer = p.toString() and cls = p.getPrimaryQlClasses()
    )
    or
    not i.hasResolvedCanonicalPath() and answer = "None" and cls = ""
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
