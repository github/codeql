import rust
import codeql.rust.internal.PathResolution
import utils.test.PathResolutionInlineExpectationsTest
import TestUtils

query predicate mod(Module m) { toBeTested(m) }

final private class ItemNodeFinal = ItemNode;

class ItemNodeLoc extends ItemNodeFinal {
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(string file |
      this.getLocation().hasLocationInfo(file, startline, startcolumn, endline, endcolumn) and
      filepath =
        file.regexpReplaceAll("^/.*/.rustup/toolchains/[^/]+/", "/RUSTUP_HOME/toolchain/")
            .regexpReplaceAll("^/.*/tools/builtins/", "/BUILTINS/")
    )
  }
}

query predicate resolvePath(Path p, ItemNodeLoc i) {
  toBeTested(p) and
  not p.isFromMacroExpansion() and
  i = resolvePath(p)
}
