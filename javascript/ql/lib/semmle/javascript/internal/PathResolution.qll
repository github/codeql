private import javascript
private import semmle.javascript.internal.paths.PathResolver
private import semmle.javascript.internal.paths.TSConfig

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

  /**
   * Holds if `expr` should be resolved, because it is used in an import.
   */
  private predicate isRelevantPathExpr(PathExpr expr) { expr = any(Import imprt).getImportedPath() }

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

  //
  //  TSCONFIG.JSON
  //
  private module ResolvePathMappingConfig implements PathResolverSig {
    additional predicate shouldResolve(TSConfig cfg, Container base, string path) {
      (cfg.hasExactPathMapping(_, path) or cfg.hasPrefixPathMapping(_, path)) and
      if isRelativePath(path)
      then base = cfg.getFolder() // relative paths are resolved relative to tsconfig.json
      else base = cfg.getBaseUrlFolder() // non-relative paths are resolved relative to the baseUrl
    }

    predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }
  }

  private module ResolvePathMapping = PathResolver<ResolvePathMappingConfig>;

  private Container resolvePathMapping(TSConfig cfg, string path) {
    exists(Container base |
      ResolvePathMappingConfig::shouldResolve(cfg, base, path) and
      result = ResolvePathMapping::resolve(base, path)
    )
  }

  pragma[nomagic]
  private TSConfig getTSConfigFromPathExpr(PathExpr expr) {
    result.getAnAffectedFile() = expr.getFile() and
    isRelevantPathExpr(expr)
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

  private module PackageExportsResolverConfig implements PathResolverSig {
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

    Container getAnAdditionalChild(Container base, string name) {
      result = AutomaticFileExtensions::getAnAdditionalChild(base, name)
      or
      result = ReverseBuildDir::getAnAdditionalChild(base, name)
    }
  }

  private module PackageExportsResolver = PathResolver<PackageExportsResolverConfig>;

  private Container resolvePackageExactExport(PackageJson pkg, string matchedPath) {
    exists(string path |
      packageHasExactExport(pkg, matchedPath, path) and
      result = PackageExportsResolver::resolve(pkg.getJsonFile().getParentContainer(), path)
    )
  }

  private Container resolvePackagePrefixExport(PackageJson pkg, string matchedPath) {
    exists(string path |
      packageHasPrefixExport(pkg, matchedPath, path) and
      result = PackageExportsResolver::resolve(pkg.getJsonFile().getParentContainer(), path)
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

  private module PathExprResolverConfig implements PathResolverSig {
    additional predicate shouldResolve(PathExpr expr, Container base, string path) {
      isRelevantPathExpr(expr) and
      (
        replacedPath(expr, base, path)
        or
        path = expr.getValue() and
        (
          isRelativePath(path) and
          base = expr.getFile().getParentContainer()
          or
          prefixedByDirname(expr) and
          not exists(base.getParentContainer()) // resolve from root dir
        )
      )
    }

    predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }

    Container getAnAdditionalChild(Container base, string name) {
      result = AutomaticFileExtensions::getAnAdditionalChild(base, name)
      or
      result = ReverseBuildDir::getAnAdditionalChild(base, name)
    }
  }

  private module PathExprResolver = PathResolver<PathExprResolverConfig>;

  private Container resolvePathExpr1(PathExpr expr) {
    exists(Container base, string path |
      PathExprResolverConfig::shouldResolve(expr, base, path) and
      result = PathExprResolver::resolve(base, path)
    )
  }

  /** Resolves `main` and `module` paths in a package.json file */
  private module ResolvePackageJsonPaths implements PathResolverSig {
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
      result = ReverseBuildDir::getAnAdditionalChild(base, name)
    }
  }

  private module ResolvePackageMain = PathResolver<ResolvePackageJsonPaths>;

  private Container resolvePackageMain(PackageJson pkg) {
    exists(Container base, string path |
      ResolvePackageJsonPaths::shouldResolve(pkg, base, path, ["main", "module"]) and
      result = ResolvePackageMain::resolve(base, path)
    )
  }

  /**
   * Provides a `getAnAdditionalChild` predicate for mapping files inside a build directory
   * back to their corresponding source files.
   */
  private module ReverseBuildDir {
    Container getAnAdditionalChild(Container base, string name) {
      // Redirect './bar' to 'foo' given a tsconfig like:
      //   { include: ["foo"], compilerOptions: { outDir: "./bar" }}
      exists(TSConfig tsconfig |
        name =
          tsconfig.getCompilerOptions().getPropStringValue("outDir").regexpReplaceAll("^\\./", "") and
        base = tsconfig.getFolder() and
        result = tsconfig.getAnIncludedBaseContainer()
      )
      or
      // Heuristic version of the above based on commonly used source and build folder names
      exists(Folder folder | base = folder |
        folder = any(PackageJson pkg).getJsonFile().getParentContainer() and
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
      result = resolvePackageMain(pkg).(Folder).getJavaScriptFile("index")
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
      PathExprToDebug() { this.getValue() = "ai" }
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
