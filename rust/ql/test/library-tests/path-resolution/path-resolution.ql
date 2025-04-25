import rust
import codeql.rust.internal.PathResolution
import utils.test.PathResolutionInlineExpectationsTest
import TestUtils

query predicate mod(Module m) { toBeTested(m) }

class ItemNodeLoc extends Locatable instanceof ItemNode {
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(string file |
      super.getLocation().hasLocationInfo(file, startline, startcolumn, endline, endcolumn) and
      filepath = file.regexpReplaceAll("^/.*/.rustup/toolchains/[^/]+/", "/RUSTUP_HOME/toolchain/")
    )
  }
}

query predicate resolvePath(Path p, ItemNodeLoc i) {
  toBeTested(p) and not p.isInMacroExpansion() and i = resolvePath(p)
}
