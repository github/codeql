private import javascript
private import semmle.javascript.internal.paths.PathExprResolver
private import semmle.javascript.internal.paths.PathResolver

class TSConfig extends JsonObject {
  TSConfig() {
    this.getJsonFile().getBaseName().matches("%tsconfig%.json") and
    this.isTopLevel()
  }

  /** Gets the folder containing this file. */
  Folder getFolder() { result = this.getJsonFile().getParentContainer() }

  /** Gets the `compilerOptions` object. */
  JsonObject getCompilerOptions() { result = this.getPropValue("compilerOptions") }

  /** Gets the string value in the `extends` property. */
  string getExtendsPath() { result = this.getPropStringValue("extends") }

  /** Gets the file referred to by the `extends` property. */
  File getExtendedFile() { result = Resolver::resolve(this.getFolder(), this.getExtendsPath()) }

  /** Gets the `TSConfig` file referred to by the `extends` property. */
  TSConfig getExtendedTSConfig() { result.getJsonFile() = this.getExtendedFile() }

  /** Gets the string value in the `baseUrl` property. */
  string getBaseUrlPath() { result = this.getCompilerOptions().getPropStringValue("baseUrl") }

  /** Gets the folder referred to by the `baseUrl` property in this file, not taking `extends` into account. */
  Folder getOwnBaseUrlFolder() {
    result = Resolver::resolve(this.getFolder(), this.getBaseUrlPath())
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
   * Gets a file or folder refenced by a path the `include` property, possibly
   * inherited from an extended tsconfig file.
   *
   * Does not include all the files within includes directories, use `getAnIncludedContainer` for that.
   */
  Container getAnIncludePathTarget() {
    result = Resolver::resolve(this.getFolder(), this.getAnIncludePath())
    or
    not exists(this.getPropValue("include")) and
    result = this.getExtendedTSConfig().getAnIncludePathTarget()
  }

  /**
   * Gets a file or folder inside the directory tree mentioned in the `include` property.
   */
  Container getAnIncludedContainer() {
    result = this.getAnIncludePathTarget()
    or
    result = this.getAnIncludedContainer().getAChildContainer()
  }

  private JsonObject getPathMappings() { result = this.getCompilerOptions().getPropValue("paths") }

  predicate hasPathMapping(string pattern, string newPath) {
    this.getPathMappings().getPropStringValue(pattern) = newPath
    or
    this.getPathMappings().getPropValue(pattern).(JsonArray).getElementStringValue(_) = newPath
  }

  predicate hasExactPathMapping(string pattern, string newPath) {
    this.hasPathMapping(pattern, newPath) and
    not pattern.matches("%*%")
  }

  predicate hasPrefixPathMapping(string pattern, string newPath) {
    this.hasPathMapping(pattern + "*", newPath + "*")
  }

  predicate hasExactPathMappingTo(string pattern, Container target) {
    exists(string newPath |
      this.hasExactPathMapping(pattern, newPath) and
      target = resolvePathMapping(this, newPath)
    )
    or
    this.getExtendedTSConfig().hasExactPathMappingTo(pattern, target)
  }

  predicate hasPrefixPathMappingTo(string pattern, Container target) {
    exists(string newPath |
      this.hasPrefixPathMapping(pattern, newPath) and
      target = resolvePathMapping(this, newPath)
    )
    or
    this.getExtendedTSConfig().hasPrefixPathMappingTo(pattern, target)
  }
}

/** For resolving paths in a tsconfig file, except `paths` mappings. */
private module ResolverConfig implements PathResolverSig {
  predicate shouldResolve(Container base, string path) {
    exists(TSConfig cfg |
      base = cfg.getFolder() and
      path = [cfg.getExtendsPath(), cfg.getBaseUrlPath(), cfg.getAnIncludePath()]
    )
  }

  predicate allowGlobs() { any() }
}

private module Resolver = PathResolver<ResolverConfig>;

/** For resolving `paths` mappings, since these require the baseURL to be resolved first. */
private module PathMappingResolverConfig implements PathResolverSig {
  additional predicate shouldResolve(TSConfig cfg, Container base, string path) {
    (cfg.hasExactPathMapping(_, path) or cfg.hasPrefixPathMapping(_, path)) and
    if isRelativePath(path)
    then base = cfg.getFolder() // relative paths are resolved relative to tsconfig.json
    else base = cfg.getBaseUrlFolder() // non-relative paths are resolved relative to the baseUrl
  }

  predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }
}

private module PathMappingResolver = PathResolver<PathMappingResolverConfig>;

private Container resolvePathMapping(TSConfig cfg, string path) {
  exists(Container base |
    PathMappingResolverConfig::shouldResolve(cfg, base, path) and
    result = PathMappingResolver::resolve(base, path)
  )
}
