private import javascript
private import semmle.javascript.internal.paths.PathResolver
private import semmle.javascript.internal.paths.TSConfig
private import semmle.javascript.internal.paths.PackageJsonEx

final private class FinalPathExpr = PathExpr;

private class RelevantPathExpr extends FinalPathExpr {
  RelevantPathExpr() { this = any(Import imprt).getImportedPath() }
}

/**
 * Gets the TSConfig file relevant for resolving `expr`.
 */
pragma[nomagic]
private TSConfig getTSConfigFromPathExpr(RelevantPathExpr expr) {
  result.getAnAffectedFile() = expr.getFile()
}

/**
 * Holds if `path` is relative, in the sense that it should be resolved relative to its enclosing folder.
 */
bindingset[path]
predicate isRelativePath(string path) { path.regexpMatch("\\.\\.?(?:[/\\\\].*)?") }

/**
 * Gets the NPM package name from the beginning of the given import path, e.g.
 * gets `foo` from `foo/bar`, and `@example/foo` from `@example/foo/bar`.
 */
pragma[nomagic]
private string getPackagePrefixFromPathExpr(RelevantPathExpr expr) {
  result = expr.getValue().regexpFind("^(@[^/\\\\]+[/\\\\])?[^@./\\\\][^/\\\\]*", _, _)
}

/**
 * Gets a folder name that is a common source folder name.
 */
string getASrcFolderName() { result = ["ts", "js", "src", "lib"] }

/**
 * Gets a folder name that is a common build output folder name.
 */
string getABuildOutputFolderName() { result = ["dist", "build", "out", "lib"] }

module JSPaths {
  /**
   * Gets an additional child of `base` to include when resolving JS paths.
   *
   * This accounts for two things:
   * - automatic file extensions (e.g `./foo` may resolve to `./foo.js`)
   * - mapping compiled-generated files back to their original source files
   */
  Container getAnAdditionalChild(Container base, string name) {
    // Automatically fill in file extensions
    result = base.(Folder).getJavaScriptFile(name)
    or
    // When importing a .js file, map to the original file that compiles to the .js file.
    exists(string stem |
      result = base.(Folder).getJavaScriptFile(stem) and
      name = stem + ".js"
    )
    or
    // Redirect './bar' to 'foo' given a tsconfig like:
    //
    //   { include: ["foo"], compilerOptions: { outDir: "./bar" }}
    //
    exists(TSConfig tsconfig |
      name =
        tsconfig.getCompilerOptions().getPropStringValue("outDir").regexpReplaceAll("^\\./", "") and
      base = tsconfig.getFolder() and
      result = tsconfig.getAnIncludedBaseContainer()
    )
    or
    // Heuristic version of the above based on commonly used source and build folder names
    exists(Folder folder | base = folder |
      folder = any(PackageJson pkg).getFolder() and
      name = getABuildOutputFolderName() and
      not exists(folder.getChildContainer(name)) and
      (
        result = folder.getChildContainer(getASrcFolderName())
        or
        result = folder
      )
    )
  }
}

/**
 * Gets an access to `__dirname`.
 */
private VarAccess dirname() { result.getName() = "__dirname" }

/** Holds if `add` is a relevant path expression of form `__dirname + expr`. */
private predicate prefixedByDirname(PathExpr expr) {
  expr = dirname()
  or
  prefixedByDirname(expr.(AddExpr).getLeftOperand())
  or
  prefixedByDirname(expr.(CallExpr).getArgument(0))
}

/**
 * Holds if `expr` matches a path mapping, and should thus be resolved as `newPath` relative to `base`.
 */
pragma[nomagic]
private predicate resolveViaPathMapping(RelevantPathExpr expr, Container base, string newPath) {
  // Handle tsconfig mappings such as `{ "paths": { "@/*": "./src/*" }}`
  exists(TSConfig config, string value |
    config = getTSConfigFromPathExpr(expr).getExtendedTSConfig*() and
    value = expr.getValue()
  |
    config.hasExactPathMappingTo(value, base) and
    newPath = ""
    or
    exists(string pattern |
      config.hasPrefixPathMappingTo(pattern, base) and
      value = pattern + newPath
    )
  )
  or
  // Handle imports referring to a package by name, where we have a package.json
  // file for that package in the codebase.
  //
  // This part only handles the "exports" property of package.json. "main" and "modules" are
  // handled further down because their semantics are easier to handle there.
  exists(PackageJsonEx pkg, string packageName, string remainder |
    packageName = getPackagePrefixFromPathExpr(expr) and
    pkg.getDeclaredPackageName() = packageName and
    remainder = expr.getValue().suffix(packageName.length()).regexpReplaceAll("^[/\\\\]", "")
  |
    // "exports": { ".": "./foo.js" }
    // "exports": { "./foo.js": "./foo/impl.js" }
    pkg.hasExactPathMappingTo(remainder, base) and
    newPath = ""
    or
    // "exports": { "./*": "./foo/*" }
    exists(string prefix |
      pkg.hasPrefixPathMappingTo(prefix, base) and
      remainder = prefix + newPath
    )
  )
}

/**
 * Holds if `expr` should be resolved as `path` relative to `base`.
 */
pragma[nomagic]
private predicate shouldResolve(RelevantPathExpr expr, Container base, string path) {
  // Relative paths are resolved from their enclosing folder
  path = expr.getValue() and
  isRelativePath(path) and
  base = expr.getFile().getParentContainer()
  or
  // Paths prefixed by __dirname should be resolved from the root dir, because __dirname
  // currently has a getValue() that returns its absolute path.
  prefixedByDirname(expr) and
  not exists(base.getParentContainer()) and // get root dir
  path = expr.getValue()
  or
  resolveViaPathMapping(expr, base, path)
  or
  // Resolve from baseUrl of relevant tsconfig.json file
  path = expr.getValue() and
  not isRelativePath(path) and
  base = getTSConfigFromPathExpr(expr).getBaseUrlFolder()
  or
  // If the path starts with the name of a package, but did not match any path mapping,
  // resolve relative to the enclosing directory of that package.
  // Note that `getFileFromFolderImport` may subsequently redirect this to the package's "main",
  // so we don't have to deal with that here.
  exists(PackageJson pkg, string packageName |
    packageName = getPackagePrefixFromPathExpr(expr) and
    pkg.getDeclaredPackageName() = packageName and
    path = expr.getValue().suffix(packageName.length()).regexpReplaceAll("^[/\\\\]", "") and
    base = pkg.getJsonFile().getParentContainer()
  )
}

private module ResolverConfig implements PathResolverSig {
  predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }

  predicate getAnAdditionalChild = JSPaths::getAnAdditionalChild/2;
}

private module Resolver = PathResolver<ResolverConfig>;

private Container resolvePathExpr1(RelevantPathExpr expr) {
  exists(Container base, string path |
    shouldResolve(expr, base, path) and
    result = Resolver::resolve(base, path)
  )
}

private File guessPackageJsonMain1(PackageJsonEx pkg) {
  not exists(pkg.getMainFile()) and
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
    ) and
    result = subfolder.getJavaScriptFile("index")
  )
}

private File guessPackageJsonMain2(PackageJsonEx pkg) {
  not exists(pkg.getMainFile()) and
  not exists(guessPackageJsonMain1(pkg)) and
  result = pkg.getAFileInFilesArray()
}

private File getFileFromFolderImport(Folder folder) {
  result = folder.getJavaScriptFile("index")
  or
  // Note that unlike "exports" paths, "main" and "module" also take effect when the package
  // is imported via a relative path, e.g. `require("..")` targeting a folder with a package.json file.
  exists(PackageJsonEx pkg | pkg.getFolder() = folder |
    result = pkg.getMainFile()
    or
    result = guessPackageJsonMain1(pkg)
    or
    result = guessPackageJsonMain2(pkg)
  )
}

File resolvePathExpr(PathExpr expr) {
  result = resolvePathExpr1(expr)
  or
  result = getFileFromFolderImport(resolvePathExpr1(expr))
}

module Debug {
  class PathExprToDebug extends RelevantPathExpr {
    PathExprToDebug() { this.getValue() = "ai" }
  }

  query PathExprToDebug pathExprs() { any() }

  query TSConfig getTSConfigFromPathExpr_(PathExprToDebug expr) {
    result = getTSConfigFromPathExpr(expr)
  }

  query string getPackagePrefixFromPathExpr_(PathExprToDebug expr) {
    result = getPackagePrefixFromPathExpr(expr)
  }

  query predicate resolveViaPathMapping_(PathExprToDebug expr, Container base, string newPath) {
    resolveViaPathMapping(expr, base, newPath)
  }

  query predicate shouldResolve_(PathExprToDebug expr, Container base, string newPath) {
    shouldResolve(expr, base, newPath)
  }

  query Container resolvePathExpr1_(PathExprToDebug expr) { result = resolvePathExpr1(expr) }

  query File resolvePathExpr_(PathExprToDebug expr) { result = resolvePathExpr(expr) }

  // Some predicates that are usually small enough that they don't need restriction
  query File getPackageMainFile(PackageJsonEx pkg) { result = pkg.getMainFile() }

  query predicate guessPackageJsonMain1_ = guessPackageJsonMain1/1;

  query predicate guessPackageJsonMain2_ = guessPackageJsonMain2/1;

  query predicate getFileFromFolderImport_ = getFileFromFolderImport/1;
}
