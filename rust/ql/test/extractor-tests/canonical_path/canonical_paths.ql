import rust
import TestUtils
private import codeql.rust.internal.PathResolution
private import codeql.rust.frameworks.stdlib.Builtins

query predicate canonicalPath(Addressable a, string path) {
  (
    toBeTested(a)
    or
    // test that we also generate canonical paths for builtins
    a =
      any(ImplItemNode i |
        i.resolveSelfTy() instanceof Str and
        not i.(Impl).hasTrait()
      ).getAnAssocItem() and
    a.(Function).getName().getText() = "trim"
  ) and
  path = a.getCanonicalPath(_)
}

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
