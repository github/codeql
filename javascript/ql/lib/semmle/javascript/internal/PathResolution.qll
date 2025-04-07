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

pragma[inline]
private Container getChild(Container parent, string name) {
  result = parent.getFile(name)
  or
  result = parent.getFolder(name)
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
      result = getChild(cur, segment)
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

module PathResolution {
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

    private predicate isPrimaryTSConfig() {
      this.getJsonFile().getBaseName() = "tsconfig.json"
      or
      // Fallback in case we can't find the primary tsconfig file
      not exists(this.getFolder().getFile("tsconfig.json")) and
      not this = any(TSConfig tsc).getExtendedTSConfig()
    }

    /**
     * Gets a file or folder inside the directory tree mentioned in the `include` property.
     */
    Container getAnAffectedFile() {
      this.isPrimaryTSConfig() and
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

  bindingset[path]
  private predicate isRelativePath(string path) { path.regexpMatch("\\.\\.?(?:[/\\\\].*)?") }

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

  private JsonValue getAPartOfExportsSection(PackageJson pkg, string matchedPath) {
    result = pkg.getPropValue("exports") and
    matchedPath = pkg.getDeclaredPackageName()
    or
    exists(string prop, string prevPath |
      result = getAPartOfExportsSection(pkg, prevPath).getPropValue(prop) and
      if prop.matches("./%")
      then matchedPath = prevPath + prop.suffix(1)
      else matchedPath = prevPath
    )
  }

  private module ResolvePackageExportsConfig implements ResolvePathsSig {
    additional predicate shouldResolve(
      PackageJson pkg, string exportedPath, Container base, string path
    ) {
      base = pkg.getJsonFile().getParentContainer() and
      path = getAPartOfExportsSection(pkg, exportedPath).getStringValue()
    }

    predicate shouldResolve(Container base, string path) { shouldResolve(_, _, base, path) }
  }

  private module ResolvePackageExports = ResolvePaths<ResolvePackageExportsConfig>;

  private Container resolvePackageExports(PackageJson pkg, string matchedPath) {
    exists(Container base, string path |
      ResolvePackageExportsConfig::shouldResolve(pkg, matchedPath, base, path) and
      result = ResolvePackageExports::resolve(base, path)
    )
  }

  pragma[nomagic]
  private string getPackagePrefixFromPathExpr(PathExpr expr) {
    result = expr.getValue().regexpFind("^(@[^/\\\\]+[/\\\\])?[^@./\\\\][^/\\\\]*", _, _)
  }

  pragma[nomagic]
  private predicate replacedPath1(PathExpr expr, Container base, string newPath) {
    // Import path matching a "paths" passing in tsconfig.json
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
        value = pattern + any(string s) and
        base = resolvePathMapping(config, mappedPath) and
        newPath = value.suffix(pattern.length())
      )
    )
    or
    // Import path matching a path within a package, matched by an "exports" mapping in package.json
    base = resolvePackageExports(_, expr.getValue()) and
    newPath = ""
    or
    // Import path matching a non-empty path within a package, where the package has no explicit "exports"
    exists(PackageJson pkg, string packageName |
      packageName = getPackagePrefixFromPathExpr(expr) and
      pkg.getDeclaredPackageName() = packageName and
      not exists(pkg.getPropValue("exports")) and
      newPath = expr.getValue().suffix(packageName.length()) and
      base = pkg.getJsonFile().getParentContainer()
    )
  }

  pragma[nomagic]
  private predicate replacedPath(PathExpr expr, Container base, string newPath) {
    replacedPath1(expr, base, newPath)
    or
    // resolve from baseUrl
    not replacedPath1(expr, _, _) and
    newPath = expr.getValue() and
    newPath.charAt(0) != "." and
    base = getTSConfigFromPathExpr(expr).getBaseUrlFolder()
  }

  private module ResolvePathExprConfig implements ResolvePathsSig {
    additional predicate shouldResolve(PathExpr expr, Container base, string path) {
      expr = any(Import imprt).getImportedPath() and
      (
        replacedPath(expr, base, path)
        or
        not replacedPath(expr, _, _) and
        isRelativePath(expr.getValue()) and
        base = expr.getFile().getParentContainer() and
        path = expr.getValue()
      )
    }

    predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }

    private predicate extensionCompilesTo(string original, string compilesTo) {
      original = "ts" and
      compilesTo = "js"
      or
      original = "tsx" and
      compilesTo = ["jsx", "js"]
    }

    Container getAnAdditionalChild(Container base, string name) {
      result = base.(Folder).getJavaScriptFile(name)
      or
      exists(string stem, string addedExt |
        result = base.(Folder).getJavaScriptFile(stem) and
        extensionCompilesTo(result.getExtension(), addedExt) and
        name = result.getStem() + "." + addedExt and
        not exists(base.(Folder).getFile(name))
      )
    }
  }

  private module ResolvePathExpr = ResolvePaths<ResolvePathExprConfig>;

  private Container resolvePathExpr1(PathExpr expr) {
    exists(Container base, string path |
      ResolvePathExprConfig::shouldResolve(expr, base, path) and
      result = ResolvePathExpr::resolve(base, path)
    )
  }

  /** Resolves `main` and `module` paths in a package.json file */
  private module ResolvePackageMainConfig implements ResolvePathsSig {
    additional predicate shouldResolve(PackageJson pkg, Container base, string path) {
      base = pkg.getJsonFile().getParentContainer() and
      path = pkg.getPropStringValue(["main", "module"])
    }

    predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }
  }

  private module ResolvePackageMain = ResolvePaths<ResolvePackageMainConfig>;

  private Container resolvePackageMain(PackageJson pkg) {
    exists(Container base, string path |
      ResolvePackageMainConfig::shouldResolve(pkg, base, path) and
      result = ResolvePackageMain::resolve(base, path)
    )
  }

  private File getFileFromFolderImport(Folder folder) {
    result = folder.getJavaScriptFile("index")
    or
    // Note that unlike "exports" paths, "main" and "module" also take effect when the package
    // is imported via a relative path, e.g. `require("..")` targeting a folder with a package.json file.
    exists(PackageJson pkg |
      pkg.getJsonFile().getParentContainer() = folder and
      result = resolvePackageMain(pkg)
    )
  }

  File resolvePathExpr(PathExpr expr) {
    result = resolvePathExpr1(expr)
    or
    result = getFileFromFolderImport(resolvePathExpr1(expr))
  }
}
