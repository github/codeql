/**
 * Provides classes for working with NPM module definitions and dependencies.
 */

import javascript
private import NodeModuleResolutionImpl

/** A `package.json` configuration object. */
class PackageJson extends JsonObject {
  PackageJson() {
    this.getJsonFile().getBaseName() = "package.json" and
    this.isTopLevel()
  }

  /** Gets the name of this package. */
  string getPackageName() { result = this.getPropStringValue("name") }

  /** Gets the version of this package. */
  string getVersion() { result = this.getPropStringValue("version") }

  /** Gets the description of this package. */
  string getDescription() { result = this.getPropStringValue("description") }

  /** Gets the array of keywords for this package. */
  JsonArray getKeywords() { result = this.getPropValue("keywords") }

  /** Gets a keyword for this package. */
  string getAKeyword() { result = this.getKeywords().getElementStringValue(_) }

  /** Gets the homepage URL of this package. */
  string getHomepage() { result = this.getPropStringValue("homepage") }

  /** Gets the bug tracker information of this package. */
  BugTrackerInfo getBugs() { result = this.getPropValue("bugs") }

  /** Gets the license information of this package. */
  string getLicense() { result = this.getPropStringValue("license") }

  /** Gets the author information of this package. */
  ContributorInfo getAuthor() { result = this.getPropValue("author") }

  /** Gets information for a contributor to this package. */
  ContributorInfo getAContributor() {
    result = this.getPropValue("contributors").getElementValue(_)
  }

  /** Gets the array of files for this package. */
  JsonArray getFiles() { result = this.getPropValue("files") }

  /** Gets a file for this package. */
  string getAFile() { result = this.getFiles().getElementStringValue(_) }

  /** Gets the main module of this package. */
  string getMain() { result = MainModulePath::of(this).getValue() }

  /** Gets the path of a command defined for this package. */
  string getBin(string cmd) {
    cmd = this.getPackageName() and result = this.getPropStringValue("bin")
    or
    result = this.getPropValue("bin").getPropValue(cmd).getStringValue()
  }

  /** Gets a manual page for this package. */
  string getAManFile() {
    result = this.getPropStringValue("man") or
    result = this.getPropValue("man").getElementValue(_).getStringValue()
  }

  /** Gets information about the directories of this package. */
  JsonObject getDirectories() { result = this.getPropValue("directories") }

  /** Gets repository information for this package. */
  RepositoryInfo getRepository() { result = this.getPropValue("repository") }

  /** Gets information about the scripts of this package. */
  JsonObject getScripts() { result = this.getPropValue("scripts") }

  /** Gets configuration information for this package. */
  JsonObject getConfig() { result = this.getPropValue("config") }

  /** Gets the dependencies of this package. */
  PackageDependencies getDependencies() { result = this.getPropValue("dependencies") }

  /** Gets the development dependencies of this package. */
  PackageDependencies getDevDependencies() { result = this.getPropValue("devDependencies") }

  /** Gets the peer dependencies of this package. */
  PackageDependencies getPeerDependencies() { result = this.getPropValue("peerDependencies") }

  /** Gets the bundled dependencies of this package. */
  PackageDependencies getBundledDependencies() {
    result = this.getPropValue("bundledDependencies") or
    result = this.getPropValue("bundleDependencies")
  }

  /** Gets the optional dependencies of this package. */
  PackageDependencies getOptionalDependencies() {
    result = this.getPropValue("optionalDependencies")
  }

  /**
   * Gets a JSON object describing a group of dependencies of
   * this package of the kind specified by `depkind`:
   * `""` for normal dependencies, `"dev"` for `devDependencies`,
   * `"bundled"` for `bundledDependencies` and `"opt"` for
   * `optionalDependencies`.
   */
  PackageDependencies getADependenciesObject(string depkind) {
    result = this.getDependencies() and depkind = ""
    or
    result = this.getDevDependencies() and depkind = "dev"
    or
    result = this.getBundledDependencies() and depkind = "bundled"
    or
    result = this.getOptionalDependencies() and depkind = "opt"
  }

  /**
   * Holds if this package declares a dependency (including
   * optional, development and bundled dependencies) on the given version
   * of the given package.
   *
   * This does _not_ consider peer dependencies, which are semantically
   * different from the other dependency types.
   */
  predicate declaresDependency(string pkg, string version) {
    this.getADependenciesObject(_).getADependency(pkg, version)
  }

  /** Gets the engine dependencies of this package. */
  PackageDependencies getEngines() { result = this.getPropValue("engines") }

  /** Holds if this package has strict engine requirements. */
  predicate isEngineStrict() { this.getPropValue("engineStrict").(JsonBoolean).getValue() = "true" }

  /** Gets information about operating systems supported by this package. */
  JsonArray getOSs() { result = this.getPropValue("os") }

  /** Gets an operating system supported by this package. */
  string getWhitelistedOS() {
    result = this.getOSs().getElementStringValue(_) and
    not result.matches("!%")
  }

  /** Gets an operating system not supported by this package. */
  string getBlacklistedOS() {
    exists(string str | str = this.getOSs().getElementStringValue(_) |
      result = str.regexpCapture("!(.*)", 1)
    )
  }

  /** Gets information about platforms supported by this package. */
  JsonArray getCPUs() { result = this.getPropValue("cpu") }

  /** Gets a platform supported by this package. */
  string getWhitelistedCPU() {
    result = this.getCPUs().getElementStringValue(_) and
    not result.matches("!%")
  }

  /** Gets a platform not supported by this package. */
  string getBlacklistedCPU() {
    exists(string str | str = this.getCPUs().getElementStringValue(_) |
      result = str.regexpCapture("!(.*)", 1)
    )
  }

  /** Holds if this package prefers to be installed globally. */
  predicate isPreferGlobal() { this.getPropValue("preferGlobal").(JsonBoolean).getValue() = "true" }

  /** Holds if this is a private package. */
  predicate isPrivate() { this.getPropValue("private").(JsonBoolean).getValue() = "true" }

  /** Gets publishing configuration information about this package. */
  JsonValue getPublishConfig() { result = this.getPropValue("publishConfig") }

  /**
   * Gets the main module of this package.
   */
  Module getMainModule() {
    result = min(Module m, int prio | m.getFile() = resolveMainModule(this, prio) | m order by prio)
  }
}

/** DEPRECATED: Alias for PackageJson */
deprecated class PackageJSON = PackageJson;

/**
 * A representation of bug tracker information for an NPM package.
 */
class BugTrackerInfo extends JsonValue {
  BugTrackerInfo() {
    exists(PackageJson pkg | pkg.getPropValue("bugs") = this) and
    (this instanceof JsonObject or this instanceof JsonString)
  }

  /** Gets the bug tracker URL. */
  string getUrl() {
    result = this.getPropValue("url").getStringValue() or
    result = this.getStringValue()
  }

  /** Gets the bug reporting email address. */
  string getEmail() { result = this.getPropValue("email").getStringValue() }
}

/**
 * A representation of contributor information for an NPM package.
 */
class ContributorInfo extends JsonValue {
  ContributorInfo() {
    exists(PackageJson pkg |
      this = pkg.getPropValue("author") or
      this = pkg.getPropValue("contributors").getElementValue(_)
    ) and
    (this instanceof JsonObject or this instanceof JsonString)
  }

  /**
   * Gets the `i`th item of information about a contributor, where the first
   * item is their name, the second their email address, and the third their
   * homepage URL.
   */
  private string parseInfo(int group) {
    result = this.getStringValue().regexpCapture("(.*?)(?: <(.*?)>)?(?: \\((.*)?\\))", group)
  }

  /** Gets the contributor's name. */
  string getName() {
    result = this.getPropValue("name").getStringValue() or
    result = this.parseInfo(1)
  }

  /** Gets the contributor's email address. */
  string getEmail() {
    result = this.getPropValue("email").getStringValue() or
    result = this.parseInfo(2)
  }

  /** Gets the contributor's homepage URL. */
  string getUrl() {
    result = this.getPropValue("url").getStringValue() or
    result = this.parseInfo(3)
  }
}

/**
 * A representation of repository information for an NPM package.
 */
class RepositoryInfo extends JsonObject {
  RepositoryInfo() { exists(PackageJson pkg | this = pkg.getPropValue("repository")) }

  /** Gets the repository type. */
  string getType() { result = this.getPropStringValue("type") }

  /** Gets the repository URL. */
  string getUrl() { result = this.getPropStringValue("url") }
}

/**
 * A representation of package dependencies for an NPM package.
 */
class PackageDependencies extends JsonObject {
  PackageDependencies() {
    exists(PackageJson pkg, string name |
      name.regexpMatch("(.+D|d)ependencies|engines") and
      this = pkg.getPropValue(name)
    )
  }

  /** Holds if this package depends on version 'version' of package 'pkg'. */
  predicate getADependency(string pkg, string version) { version = this.getPropStringValue(pkg) }
}

/**
 * An NPM package.
 */
class NpmPackage extends @folder {
  /** The `package.json` file of this package. */
  PackageJson pkg;

  NpmPackage() { pkg.getJsonFile().getParentContainer() = this }

  /** Gets a textual representation of this package. */
  string toString() { result = this.(Folder).toString() }

  /** Gets the full file system path of this package. */
  string getPath() { result = this.(Folder).getAbsolutePath() }

  /** Gets the `package.json` object of this package. */
  PackageJson getPackageJson() { result = pkg }

  /** DEPRECATED: Alias for getPackageJson */
  deprecated PackageJSON getPackageJSON() { result = this.getPackageJson() }

  /** Gets the name of this package. */
  string getPackageName() { result = this.getPackageJson().getPackageName() }

  /** Gets the `node_modules` folder of this package. */
  Folder getNodeModulesFolder() {
    result.getBaseName() = "node_modules" and
    result.getParentContainer() = this
  }

  /**
   * Gets a file belonging to this package.
   *
   * We only consider files to belong to the nearest enclosing package,
   * and files inside the `node_modules` folder of a package are not
   * considered to belong to that package.
   */
  File getAFile() { this = packageInternalParent*(result.getParentContainer()) }

  /**
   * Gets a Node.js module belonging to this package.
   *
   * We only consider modules to belong to the nearest enclosing package,
   * and modules inside the `node_modules` folder of a package are not
   * considered to belong to that package.
   */
  Module getAModule() { result.getFile() = this.getAFile() }

  /**
   * Gets the main module of this package.
   */
  Module getMainModule() { result = pkg.getMainModule() }

  /**
   * Holds if this package declares a dependency on version `v` of package `p`.
   */
  predicate declaresDependency(string p, string v) { pkg.declaresDependency(p, v) }
}

/** DEPRECATED: Alias for NpmPackage */
deprecated class NPMPackage = NpmPackage;

/**
 * Gets the parent folder of `c`, provided that they belong to the same NPM
 * package; that is, `c` must not be a `node_modules` folder.
 */
private Folder packageInternalParent(Container c) {
  result = c.getParentContainer() and
  not c.(Folder).getBaseName() = "node_modules"
}
