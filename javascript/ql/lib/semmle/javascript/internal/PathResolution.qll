private import javascript

signature module ResolvePathsSig {
  /**
   * Holds if `path` should be resolved to a file or folder, relative to `base`.
   */
  predicate shouldResolve(Container base, string path);

  /**
   * Gets an additional file or folder to consider a child of `base`.
   */
  default Container getAnAdditionalChild(Container base, string name) { none() }
}

/**
 * Provides a mechanism for resolving relative file paths.
 *
 * Absolute paths are not handled.
 */
module ResolvePaths<ResolvePathsSig Config> {
  private import Config

  private string getPathSegment(string path, int n) {
    shouldResolve(_, path) and
    result = path.replaceAll("\\", "/").splitAt("/", n)
  }

  private int getNumPathSegment(string path) {
    result = strictcount(int n | exists(getPathSegment(path, n)))
  }

  private Container resolve(Container base, string path, int n) {
    shouldResolve(base, path) and n = 0 and result = base
    or
    exists(Container cur, string segment |
      cur = resolve(base, path, n - 1) and
      segment = getPathSegment(path, n - 1)
    |
      result = cur.(Folder).getChildContainer(segment)
      or
      result = getAnAdditionalChild(cur, segment)
      or
      segment = [".", ""] and
      result = cur
      or
      segment = ".." and
      result = cur.getParentContainer()
    )
  }

  /**
   * Gets the file or folder that `path` resolves to when resolved from `base`.
   *
   * Only has results for the `base`, `path` pairs provided by `shouldResolve`
   * in the instantiation of this module.
   */
  Container resolve(Container base, string path) {
    result = resolve(base, path, getNumPathSegment(path))
  }
}

/** Provides a `getAnAdditionalChild` predicate for resolving files automatic file extensions. */
private module AutomaticFileExtensions {
  Container getAnAdditionalChild(Container base, string name) {
    result = base.(Folder).getJavaScriptFile(name)
    or
    // When importing a .js file, map to the original file that compiles to the .js file.
    exists(string stem |
      result = base.(Folder).getJavaScriptFile(stem) and
      name = stem + ".js"
    )
  }
}

module PathResolution {
  /**
   * Holds if `path` is a relative path, in the sense that it must be resolved relative to
   * its enclosing directory.
   */
  bindingset[path]
  private predicate isRelativePath(string path) { path.regexpMatch("\\.\\.?(?:[/\\\\].*)?") }

  //
  //  TSCONFIG.JSON
  //
  class TSConfig extends JsonObject {
    TSConfig() {
      this.getJsonFile().getBaseName().matches("%tsconfig%.json") and
      this.isTopLevel()
    }

    Folder getFolder() { result = this.getJsonFile().getParentContainer() }

    JsonObject getCompilerOptions() { result = this.getPropValue("compilerOptions") }

    /** Gets the string value in the `extends` property. */
    string getExtendsPath() { result = this.getPropStringValue("extends") }

    /** Gets the file referred to by the `extends` property. */
    File getExtendedFile() {
      result = TSConfigResolve::resolve(this.getFolder(), this.getExtendsPath())
    }

    /** Gets the `TSConfig` file referred to by the `extends` property. */
    TSConfig getExtendedTSConfig() { result.getJsonFile() = this.getExtendedFile() }

    /** Gets the string value in the `baseUrl` property. */
    string getBaseUrlPath() { result = this.getCompilerOptions().getPropStringValue("baseUrl") }

    /** Gets the folder referred to by the `baseUrl` property in this file, not taking `extends` into account. */
    Folder getOwnBaseUrlFolder() {
      result = TSConfigResolve::resolve(this.getFolder(), this.getBaseUrlPath())
    }

    /** Gets the effective baseUrl folder for this tsconfig file. */
    Folder getBaseUrlFolder() {
      result = this.getOwnBaseUrlFolder()
      or
      not exists(this.getOwnBaseUrlFolder()) and
      result = this.getExtendedTSConfig().getBaseUrlFolder()
    }

    /** Gets a path mentioned in the `include` property. */
    string getAnIncludePath() {
      result = this.getPropStringValue("include")
      or
      result = this.getPropValue("include").(JsonArray).getElementStringValue(_)
    }

    /**
     * Gets a file or folder mentioned in the `include` property.
     *
     * Does not include all the files within includes directories.
     */
    Container getAnIncludedBaseContainer() {
      result = TSConfigResolve::resolve(this.getFolder(), this.getAnIncludePath())
      or
      result = this.getExtendedTSConfig().getAnIncludedBaseContainer()
    }

    /**
     * Gets a file or folder inside the directory tree mentioned in the `include` property.
     */
    Container getAnAffectedFile() {
      result = this.getAnIncludedBaseContainer()
      or
      result = this.getAnAffectedFile().getAChildContainer()
    }

    JsonObject getPathMappings() { result = this.getCompilerOptions().getPropValue("paths") }

    predicate hasPathMapping(string pattern, string newPath) {
      this.getPathMappings().getPropStringValue(pattern) = newPath
      or
      // TODO: track priority
      this.getPathMappings().getPropValue(pattern).(JsonArray).getElementStringValue(_) = newPath
    }

    predicate hasExactPathMapping(string pattern, string newPath) {
      this.hasPathMapping(pattern, newPath) and
      not pattern.matches("%*%")
    }

    predicate hasPrefixPathMapping(string pattern, string newPath) {
      this.hasPathMapping(pattern + "*", newPath + "*")
    }
  }

  private module TSConfigResolveConfig implements ResolvePathsSig {
    predicate shouldResolve(Container base, string path) {
      exists(TSConfig cfg |
        base = cfg.getFolder() and
        path = [cfg.getExtendsPath(), cfg.getBaseUrlPath(), cfg.getAnIncludePath()]
      )
    }
  }

  private module TSConfigResolve = ResolvePaths<TSConfigResolveConfig>;

  private module ResolvePathMappingConfig implements ResolvePathsSig {
    additional predicate shouldResolve(TSConfig cfg, Container base, string path) {
      (cfg.hasExactPathMapping(_, path) or cfg.hasPrefixPathMapping(_, path)) and
      if isRelativePath(path)
      then base = cfg.getFolder() // relative paths are resolved relative to tsconfig.json
      else base = cfg.getBaseUrlFolder() // non-relative paths are resolved relative to the baseUrl
    }

    predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }
  }

  private module ResolvePathMapping = ResolvePaths<ResolvePathMappingConfig>;

  private Container resolvePathMapping(TSConfig cfg, string path) {
    exists(Container base |
      ResolvePathMappingConfig::shouldResolve(cfg, base, path) and
      result = ResolvePathMapping::resolve(base, path)
    )
  }

  pragma[nomagic]
  private TSConfig getTSConfigFromPathExpr(PathExpr expr) {
    result.getAnAffectedFile() = expr.getFile() and
    expr = any(Import imprt).getImportedPath()
  }

  //
  //  PACKAGE.JSON "exports" property
  //
  private JsonValue getAPartOfExportsSection(PackageJson pkg, string matchedPath) {
    result = pkg.getPropValue("exports") and
    matchedPath = ""
    or
    exists(string prop, string prevPath |
      result = getAPartOfExportsSection(pkg, prevPath).getPropValue(prop) and
      if prop.matches("./%") then matchedPath = prop.suffix(2) else matchedPath = prevPath
    )
  }

  private predicate packageHasExactExport(PackageJson pkg, string matchedPath, string path) {
    getAPartOfExportsSection(pkg, matchedPath).getStringValue() = path and
    not matchedPath.matches("%*%")
  }

  private predicate packageHasPrefixExport(PackageJson pkg, string matchedPath, string path) {
    getAPartOfExportsSection(pkg, matchedPath + "*").getStringValue() = path + "*"
  }

  private module ResolvePackageExportsConfig implements ResolvePathsSig {
    additional predicate shouldResolve(
      PackageJson pkg, string matchedPath, Container base, string path
    ) {
      (
        packageHasExactExport(pkg, matchedPath, path)
        or
        packageHasPrefixExport(pkg, matchedPath, path)
      ) and
      base = pkg.getJsonFile().getParentContainer()
    }

    predicate shouldResolve(Container base, string path) { shouldResolve(_, _, base, path) }
  }

  private module ResolvePackageExports = ResolvePaths<ResolvePackageExportsConfig>;

  private Container resolvePackageExactExport(PackageJson pkg, string matchedPath) {
    exists(string path |
      packageHasExactExport(pkg, matchedPath, path) and
      result = ResolvePackageExports::resolve(pkg.getJsonFile().getParentContainer(), path)
    )
  }

  private Container resolvePackagePrefixExport(PackageJson pkg, string matchedPath) {
    exists(string path |
      packageHasPrefixExport(pkg, matchedPath, path) and
      result = ResolvePackageExports::resolve(pkg.getJsonFile().getParentContainer(), path)
    )
  }

  /**
   * Gets the NPM package name from the beginning of the given import path, e.g.
   * gets `foo` from `foo/bar`, and `@example/foo` from `@example/foo/bar`.
   */
  pragma[nomagic]
  private string getPackagePrefixFromPathExpr(PathExpr expr) {
    result = expr.getValue().regexpFind("^(@[^/\\\\]+[/\\\\])?[^@./\\\\][^/\\\\]*", _, _)
  }

  pragma[nomagic]
  private predicate replacedPath1(PathExpr expr, Container base, string newPath) {
    // Handle tsconfig mappings such as `{ "paths": { "@/*": "./src/*" }}`
    exists(TSConfig config, string value, string mappedPath |
      config = getTSConfigFromPathExpr(expr).getExtendedTSConfig*() and
      value = expr.getValue()
    |
      config.hasExactPathMapping(value, mappedPath) and
      base = resolvePathMapping(config, mappedPath) and
      newPath = ""
      or
      exists(string pattern |
        config.hasPrefixPathMapping(pattern, mappedPath) and
        value = pattern + newPath and
        base = resolvePathMapping(config, mappedPath)
      )
    )
    or
    // Handle imports referring to a package by name, where we have a package.json
    // file for that package in the codebase.
    //
    // This part only handles the "exports" property of package.json. "main" and "modules" are
    // handled further down because their semantics are easier to handle there.
    exists(PackageJson pkg, string packageName, string remainder |
      packageName = getPackagePrefixFromPathExpr(expr) and
      pkg.getDeclaredPackageName() = packageName and
      remainder = expr.getValue().suffix(packageName.length()).regexpReplaceAll("^[/\\\\]", "")
    |
      // "exports": { ".": "./foo.js" }
      // "exports": { "./foo.js": "./foo/impl.js" }
      base = resolvePackageExactExport(pkg, remainder) and
      newPath = ""
      or
      // "exports": { "./*": "./foo/*" }
      exists(string prefix |
        base = resolvePackagePrefixExport(pkg, prefix) and
        remainder = prefix + newPath
      )
      or
      // Otherwise resolve relative to the enclosing folder.
      // If there is no "exports" property in the package.json this is matches what happens at runtime.
      // If there IS an "exports" property but none of its rules could be resolved, we use the same fallback as a way
      // to try and locate the source files corresponding to the build files mentioned in the "exports" property.
      // If there is a "main" or "module" property, this is later remapped to that file in `getFileFromFolderImport`
      // not exists(pkg.getPropValue("exports")) and
      not exists(resolvePackageExactExport(pkg, _)) and
      not exists(resolvePackagePrefixExport(pkg, _)) and
      base = pkg.getJsonFile().getParentContainer() and
      newPath = remainder
    )
  }

  pragma[nomagic]
  private predicate replacedPath(PathExpr expr, Container base, string newPath) {
    replacedPath1(expr, base, newPath)
    or
    // resolve from baseUrl
    not replacedPath1(expr, _, _) and
    (
      newPath = expr.getValue() and
      not isRelativePath(newPath) and
      base = getTSConfigFromPathExpr(expr).getBaseUrlFolder()
      or
      // TODO: is this needed?
      exists(PackageJson pkg, string packageName |
        packageName = getPackagePrefixFromPathExpr(expr) and
        pkg.getDeclaredPackageName() = packageName and
        newPath = expr.getValue().suffix(packageName.length()).regexpReplaceAll("^[/\\\\]", "") and
        base = pkg.getJsonFile().getParentContainer()
      )
    )
  }

  private module ResolvePathExprConfig implements ResolvePathsSig {
    additional predicate shouldResolve(PathExpr expr, Container base, string path) {
      expr = any(Import imprt).getImportedPath() and
      (
        replacedPath(expr, base, path)
        or
        path = expr.getValue() and
        isRelativePath(path) and
        base = expr.getFile().getParentContainer()
      )
    }

    predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }

    predicate getAnAdditionalChild = AutomaticFileExtensions::getAnAdditionalChild/2;
  }

  private module ResolvePathExpr = ResolvePaths<ResolvePathExprConfig>;

  private Container resolvePathExpr1(PathExpr expr) {
    exists(Container base, string path |
      ResolvePathExprConfig::shouldResolve(expr, base, path) and
      result = ResolvePathExpr::resolve(base, path)
    )
  }

  /** Resolves `main` and `module` paths in a package.json file */
  private module ResolvePackageJsonPaths implements ResolvePathsSig {
    additional predicate shouldResolve(PackageJson pkg, Container base, string path, string kind) {
      base = pkg.getJsonFile().getParentContainer() and
      (
        kind = ["main", "module"] and
        path = pkg.getPropStringValue(kind)
        or
        kind = "files" and
        path = pkg.getPropValue("files").(JsonArray).getElementStringValue(_)
      )
    }

    predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path, _) }

    Container getAnAdditionalChild(Container base, string name) {
      result = AutomaticFileExtensions::getAnAdditionalChild(base, name)
      or
      // When resolving an output-like folder that doesn't exist, try resolving from 'src'
      exists(Folder folder | base = folder |
        folder = any(PackageJson pkg).getJsonFile().getParentContainer() and
        name = getABuildOutputFolderName() and
        not exists(folder.getChildContainer(name)) and
        result = folder.getChildContainer(getASrcFolderName())
      )
    }
  }

  private module ResolvePackageMain = ResolvePaths<ResolvePackageJsonPaths>;

  private Container resolvePackageMain(PackageJson pkg) {
    exists(Container base, string path |
      ResolvePackageJsonPaths::shouldResolve(pkg, base, path, ["main", "module"]) and
      result = ResolvePackageMain::resolve(base, path)
    )
  }

  /**
   * Gets a folder name that is a common source folder name.
   */
  private string getASrcFolderName() { result = ["ts", "js", "src", "lib"] }

  /**
   * Gets a folder name that is a common build output folder name.
   */
  private string getABuildOutputFolderName() { result = ["dist", "build", "out", "lib"] }

  private File guessPackageJsonMain1(PackageJson pkg) {
    not exists(resolvePackageMain(pkg)) and
    exists(Folder folder, Folder subfolder |
      folder = pkg.getJsonFile().getParentContainer() and
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

  private Container resolveAPackageFile(PackageJson pkg) {
    exists(Container base, string path |
      ResolvePackageJsonPaths::shouldResolve(pkg, base, path, "files") and
      result = ResolvePackageMain::resolve(base, path)
    )
  }

  private File guessPackageJsonMain2(PackageJson pkg) {
    not exists(resolvePackageMain(pkg)) and
    not exists(guessPackageJsonMain1(pkg)) and
    result = resolveAPackageFile(pkg)
  }

  private File getFileFromFolderImport(Folder folder) {
    result = folder.getJavaScriptFile("index")
    or
    // Note that unlike "exports" paths, "main" and "module" also take effect when the package
    // is imported via a relative path, e.g. `require("..")` targeting a folder with a package.json file.
    exists(PackageJson pkg | pkg.getJsonFile().getParentContainer() = folder |
      result = resolvePackageMain(pkg)
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
    final private class FinalPathExpr = PathExpr;

    class PathExprToDebug extends FinalPathExpr {
      PathExprToDebug() { this.getValue() = "~/core/handlers/RequestHandler" }
    }

    query PathExprToDebug pathExprs() { any() }

    query TSConfig getTSConfigFromPathExpr_(PathExprToDebug expr) {
      result = getTSConfigFromPathExpr(expr)
    }

    query string getPackagePrefixFromPathExpr_(PathExprToDebug expr) {
      result = getPackagePrefixFromPathExpr(expr)
    }

    query predicate replacedPath1_(PathExprToDebug expr, Container base, string newPath) {
      replacedPath1(expr, base, newPath)
    }

    query predicate replacedPath_(PathExprToDebug expr, Container base, string newPath) {
      replacedPath(expr, base, newPath)
    }

    query Container resolvePathExpr1_(PathExprToDebug expr) { result = resolvePathExpr1(expr) }

    query File resolvePathExpr_(PathExprToDebug expr) { result = resolvePathExpr(expr) }

    // Some predicates that are usually small enough that they don't need restriction
    query predicate resolvePackageMain_ = resolvePackageMain/1;

    query predicate guessPackageJsonMain1_ = guessPackageJsonMain1/1;

    query predicate guessPackageJsonMain2_ = guessPackageJsonMain2/1;

    query predicate getFileFromFolderImport_ = getFileFromFolderImport/1;
  }
}
