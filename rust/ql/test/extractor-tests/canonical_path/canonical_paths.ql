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
