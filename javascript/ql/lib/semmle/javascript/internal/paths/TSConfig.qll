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

  /** Gets the effective baseUrl folder for this tsconfig file, or its enclosing folder if there is no baseUrl. */
  Folder getBaseUrlFolderOrOwnFolder() {
    result = this.getBaseUrlFolder()
    or
    not exists(this.getBaseUrlFolder()) and
    result = this.getFolder()
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
}

/** For resolving paths in a tsconfig file, except `paths` mappings. */
private module ResolverConfig implements PathResolverSig {
  predicate shouldResolve(Container base, string path) {
    exists(TSConfig cfg |
      base = cfg.getFolder() and
      path = [cfg.getExtendsPath(), cfg.getBaseUrlPath(), cfg.getAnIncludePath()]
    )
  }

  predicate allowGlobs() { any() } // "include" can use globs
}

private module Resolver = PathResolver<ResolverConfig>;
