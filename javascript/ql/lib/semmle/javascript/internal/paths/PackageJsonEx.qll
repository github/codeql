private import javascript
private import semmle.javascript.internal.paths.PathResolver
private import semmle.javascript.internal.paths.PathExprResolver

class PackageJsonEx extends PackageJson {
  private JsonValue getAPartOfExportsSection(string pattern) {
    result = this.getPropValue("exports") and
    pattern = ""
    or
    exists(string prop, string prevPath |
      result = this.getAPartOfExportsSection(prevPath).getPropValue(prop) and
      if prop.matches("./%") then pattern = prop.suffix(2) else pattern = prevPath
    )
  }

  predicate hasPathMapping(string pattern, string newPath) {
    this.getAPartOfExportsSection(pattern).getStringValue() = newPath
  }

  predicate hasExactPathMapping(string pattern, string newPath) {
    this.getAPartOfExportsSection(pattern).getStringValue() = newPath and
    not pattern.matches("%*%")
  }

  predicate hasPrefixPathMapping(string pattern, string newPath) {
    this.hasPathMapping(pattern + "*", newPath + "*")
  }

  predicate hasExactPathMappingTo(string pattern, Container target) {
    exists(string newPath |
      this.hasExactPathMapping(pattern, newPath) and
      target = Resolver::resolve(this.getFolder(), newPath)
    )
  }

  predicate hasPrefixPathMappingTo(string pattern, Container target) {
    exists(string newPath |
      this.hasPrefixPathMapping(pattern, newPath) and
      target = Resolver::resolve(this.getFolder(), newPath)
    )
  }

  string getMainPath() { result = this.getPropStringValue(["main", "module"]) }

  Container getMainFile() { result = Resolver::resolve(this.getFolder(), this.getMainPath()) }

  string getAPathInFilesArray() {
    result = this.getPropValue("files").(JsonArray).getElementStringValue(_)
  }

  Container getAFileInFilesArray() {
    result = Resolver::resolve(this.getFolder(), this.getAPathInFilesArray())
  }
}

private module ResolverConfig implements PathResolverSig {
  additional predicate shouldResolve(PackageJsonEx pkg, Container base, string path) {
    base = pkg.getJsonFile().getParentContainer() and
    (
      pkg.hasExactPathMapping(_, path)
      or
      pkg.hasPrefixPathMapping(_, path)
      or
      path = pkg.getMainPath()
      or
      path = pkg.getAPathInFilesArray()
    )
  }

  predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }

  predicate getAnAdditionalChild = JSPaths::getAnAdditionalChild/2;
}

private module Resolver = PathResolver<ResolverConfig>;
