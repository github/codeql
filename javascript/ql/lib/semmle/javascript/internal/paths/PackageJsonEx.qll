private import javascript
private import semmle.javascript.internal.paths.JSPaths

/**
 * A `package.json` file. The class is an extension of the `PackageJson` class with some internal path-resolution predicates.
 */
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

  File getMainFile() {
    exists(Container main | main = Resolver::resolve(this.getFolder(), this.getMainPath()) |
      result = main
      or
      result = main.(Folder).getJavaScriptFileOrTypings("index")
    )
  }

  File getMainFileOrBestGuess() {
    result = this.getMainFile()
    or
    result = guessPackageJsonMain1(this)
    or
    result = guessPackageJsonMain2(this)
  }

  string getAPathInFilesArray() {
    result = this.getPropValue("files").(JsonArray).getElementStringValue(_)
  }

  Container getAFileInFilesArray() {
    result = Resolver::resolve(this.getFolder(), this.getAPathInFilesArray())
  }

  override File getTypingsFile() {
    result = Resolver::resolve(this.getFolder(), this.getTypings())
    or
    not exists(this.getTypings()) and
    exists(File mainFile |
      mainFile = this.getMainFileOrBestGuess() and
      result =
        mainFile
            .getParentContainer()
            .getFile(mainFile.getStem().regexpReplaceAll("\\.d$", "") + ".d.ts")
    )
  }
}

private module ResolverConfig implements Folder::ResolveSig {
  additional predicate shouldResolve(PackageJsonEx pkg, Container base, string path) {
    base = pkg.getFolder() and
    (
      pkg.hasExactPathMapping(_, path)
      or
      pkg.hasPrefixPathMapping(_, path)
      or
      path = pkg.getMainPath()
      or
      path = pkg.getAPathInFilesArray()
      or
      path = pkg.getTypings()
    )
  }

  predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }

  predicate getAnAdditionalChild = JSPaths::getAnAdditionalChild/2;

  predicate isOptionalPathComponent(string segment) {
    // Try to omit paths can might refer to a build format, .e.g `dist/cjs/foo.cjs` -> `src/foo.ts`
    segment = ["cjs", "mjs", "js"]
  }

  bindingset[segment]
  string rewritePathSegment(string segment) {
    // Try removing anything after the first dot, such as foo.min.js -> foo (the extension is then filled in by getAdditionalChild)
    result = segment.regexpReplaceAll("\\..*", "")
  }
}

private module Resolver = Folder::Resolve<ResolverConfig>;

/**
 * Removes the scope from a package name, e.g. `@foo/bar` -> `bar`.
 */
bindingset[name]
private string stripPackageScope(string name) { result = name.regexpReplaceAll("^@[^/]+/", "") }

private predicate isImplementationFile(File f) { not f.getBaseName().matches("%.d.ts") }

File guessPackageJsonMain1(PackageJsonEx pkg) {
  not isImplementationFile(pkg.getMainFile()) and
  exists(Folder folder, Folder subfolder |
    folder = pkg.getFolder() and
    (
      subfolder = folder or
      subfolder = folder.getChildContainer(getASrcFolderName()) or
      subfolder =
        folder
            .getChildContainer(getASrcFolderName())
            .(Folder)
            .getChildContainer(getASrcFolderName())
    )
  |
    result = subfolder.getJavaScriptFileOrTypings("index")
    or
    result = subfolder.getJavaScriptFileOrTypings(stripPackageScope(pkg.getDeclaredPackageName()))
  )
}

File guessPackageJsonMain2(PackageJsonEx pkg) {
  not isImplementationFile(pkg.getMainFile()) and
  not isImplementationFile(guessPackageJsonMain1(pkg)) and
  result = pkg.getAFileInFilesArray()
}
