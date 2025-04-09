private import javascript
private import semmle.javascript.internal.paths.PathResolver

private module ResolverConfig implements PathResolverSig {
  predicate shouldResolve(Container base, string path) {
    exists(TSConfig cfg |
      base = cfg.getFolder() and
      path = [cfg.getExtendsPath(), cfg.getBaseUrlPath(), cfg.getAnIncludePath()]
    )
  }
}

private module Resolver = PathResolver<ResolverConfig>;

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
   * Gets a file or folder mentioned in the `include` property.
   *
   * Does not include all the files within includes directories.
   */
  Container getAnIncludedBaseContainer() {
    result = Resolver::resolve(this.getFolder(), this.getAnIncludePath())
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
