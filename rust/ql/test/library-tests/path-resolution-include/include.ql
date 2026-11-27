import rust
import codeql.rust.internal.PathResolution
import utils.test.PathResolutionInlineExpectationsTest
import TestUtils

query predicate resolvePath(PathExt p, ItemNode i) {
  toBeTested(p) and
  p.fromSource() and
  not p.isFromMacroExpansion() and
  i = resolvePath(p)
}

query predicate includedModule(string name, string file) {
  exists(Module m, SourceFile f |
    m.isInMacroExpansion() and
    fileImport(m, f) and
    name = m.getName().getText() and
    file = f.getFile().getRelativePath()
  )
}

query predicate includeTokens(string text) {
  exists(MacroCall call |
    toBeTested(call) and
    call.fromSource() and
    not call.isInMacroExpansion() and
    call.getPath().getText() = "include" and
    text = call.getTokenTree().getText()
  )
}

query predicate nestedIncludePath(string folder, string outer, string inner, string combined) {
  (
    folder = "/repo/including" and
    outer = "../foo\\bar.rs" and
    inner = "nested\\more.rs"
    or
    folder = "/repo" and
    outer = "/outer.rs" and
    inner = "nested.rs"
    or
    folder = "/repo" and
    outer = "foo/bar.rs" and
    inner = "/shared/nested.rs"
    or
    folder = "/repo" and
    outer = "foo/bar.rs" and
    inner = "C:/relative.rs"
    or
    folder = "C:/repo" and
    outer = "foo\\bar.rs" and
    inner = "d:\\shared\\nested.rs"
    or
    folder = "C:/repo" and
    outer = "C:\\outer.rs" and
    inner = "nested\\more.rs"
    or
    folder = "C:/repo" and
    outer = "foo/bar.rs" and
    inner = "\\shared\\nested.rs"
    or
    folder = "C:/repo" and
    outer = "d:\\other\\outer.rs" and
    inner = "\\root\\inner.rs"
    or
    folder = "C:/repo" and
    outer = "\\\\FileServer\\share\\dir\\outer.rs" and
    inner = "\\root\\inner.rs"
    or
    folder = "//FileServer/share/repo" and
    outer = "dir\\outer.rs" and
    inner = "\\root\\inner.rs"
  ) and
  combined = IncludePaths::combine(folder, outer, inner)
}

query predicate includeAppendPath(
  string sourceFolder, string path, string folder, string relativePath
) {
  (
    sourceFolder = "/repo" and path = "/shared/../bar.rs"
    or
    sourceFolder = "/repo" and path = "//shared/bar.rs"
    or
    sourceFolder = "/repo" and path = "C:/relative.rs"
    or
    sourceFolder = "C:/repo" and path = "d:\\shared\\bar.rs"
    or
    sourceFolder = "C:/repo" and path = "\\shared\\bar.rs"
    or
    sourceFolder = "C:/repo" and path = "\\\\FileServer\\share\\bar.rs"
    or
    sourceFolder = "//FileServer/share/repo" and path = "\\shared\\bar.rs"
    or
    sourceFolder = "C:/repo" and path = "C:relative.rs"
  ) and
  IncludePaths::getAppendBaseAndPath(sourceFolder, path, folder, relativePath)
}
