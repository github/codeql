import rust
import codeql.rust.internal.PathResolution
import utils.test.PathResolutionInlineExpectationsTest

query predicate resolveDollarCrate(PathExt p, Crate c) {
  c = resolvePath(p) and
  p.isDollarCrate() and
  p.fromSource() and
  c.fromSource()
}
