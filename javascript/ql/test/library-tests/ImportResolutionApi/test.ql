import javascript

class ImportSourceByRegExp extends ImportResolution::ScopedPathMapping {
  ImportSourceByRegExp() { getParentContainer().getBaseName() = "packages" }

  override predicate replaceByRegExp(string regexp, string replacement) {
    regexp = "@/(.*)" and
    replacement = "src/$1"
  }
}

class ImportSourceByPrefix extends ImportResolution::ScopedPathMapping {
  ImportSourceByPrefix() { getParentContainer().getBaseName() = "packages" }

  override predicate replaceByPrefix(string prefix, string replacement) {
    prefix = "SOURCE" and
    replacement = "src/"
  }
}

class ImportExact extends ImportResolution::ScopedPathMapping {
  ImportExact() { getParentContainer().getBaseName() = "packages" }

  override predicate replaceByPrefix(string prefix, string replacement) {
    prefix = "EXACT" and
    replacement = "exact-imported.js"
  }
}

class ImportOverride extends ImportResolution::ScopedPathMapping {
  ImportOverride() { getRelativePath() = any(string s) + "packages/pack2/src/components/special" }

  override predicate replaceByPrefix(string prefix, string replacement, Folder root) {
    prefix = "EXACT" and
    replacement = "special.js" and
    root.getBaseName() = "pack2"
  }
}

query Module getImportedModule(Import imprt, string rawPath) {
  result = imprt.getImportedModule() and
  rawPath = imprt.getImportedPath().(Expr).getStringValue() // to make the test output easier to read
}
