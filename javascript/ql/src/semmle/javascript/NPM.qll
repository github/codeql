/**
 * Provides classes for working with NPM module definitions and dependencies.
 */

import javascript
private import NodeModuleResolutionImpl

/** A `package.json` configuration object. */
class PackageJSON extends JSONObject {
  PackageJSON() {
    getJsonFile().getBaseName() = "package.json" and
    isTopLevel()
  }

  /** Gets the name of this package. */
  string getPackageName() { result = getPropStringValue("name") }

  /** Gets the version of this package. */
  string getVersion() { result = getPropStringValue("version") }

  /** Gets the description of this package. */
  string getDescription() { result = getPropStringValue("description") }

  /** Gets the array of keywords for this package. */
  JSONArray getKeywords() { result = getPropValue("keywords") }

  /** Gets a keyword for this package. */
  string getAKeyword() { result = getKeywords().getElementStringValue(_) }

  /** Gets the homepage URL of this package. */
  string getHomepage() { result = getPropStringValue("homepage") }

  /** Gets the bug tracker information of this package. */
  BugTrackerInfo getBugs() { result = getPropValue("bugs") }

  /** Gets the license information of this package. */
  string getLicense() { result = getPropStringValue("license") }

  /** Gets the author information of this package. */
  ContributorInfo getAuthor() { result = getPropValue("author") }

  /** Gets information for a contributor to this package. */
  ContributorInfo getAContributor() {
    result = getPropValue("contributors").(JSONArray).getElementValue(_)
  }

  /** Gets the array of files for this package. */
  JSONArray getFiles() { result = getPropValue("files") }

  /** Gets a file for this package. */
  string getAFile() { result = getFiles().getElementStringValue(_) }

  /** Gets the main module of this package. */
  string getMain() { result = getPropStringValue("main") }

  /** Gets the path of a command defined for this package. */
  string getBin(string cmd) {
    cmd = getPackageName() and result = getPropStringValue("bin")
    or
    result = getPropValue("bin").(JSONObject).getPropStringValue(cmd)
  }

  /** Gets a manual page for this package. */
  string getAManFile() {
    result = getPropStringValue("man") or
    result = getPropValue("man").(JSONArray).getElementStringValue(_)
  }

  /** Gets information about the directories of this package. */
  JSONObject getDirectories() { result = getPropValue("directories") }

  /** Gets repository information for this package. */
  RepositoryInfo getRepository() { result = getPropValue("repository") }

  /** Gets information about the scripts of this package. */
  JSONObject getScripts() { result = getPropValue("scripts") }

  /** Gets configuration information for this package. */
  JSONObject getConfig() { result = getPropValue("config") }

  /** Gets the dependencies of this package. */
  PackageDependencies getDependencies() { result = getPropValue("dependencies") }

  /** Gets the development dependencies of this package. */
  PackageDependencies getDevDependencies() { result = getPropValue("devDependencies") }

  /** Gets the peer dependencies of this package. */
  PackageDependencies getPeerDependencies() { result = getPropValue("peerDependencies") }

  /** Gets the bundled dependencies of this package. */
  PackageDependencies getBundledDependencies() {
    result = getPropValue("bundledDependencies") or
    result = getPropValue("bundleDependencies")
  }

  /** Gets the optional dependencies of this package. */
  PackageDependencies getOptionalDependencies() { result = getPropValue("optionalDependencies") }

  /**
   * Gets a JSON object describing a group of dependencies of
   * this package of the kind specified by `depkind`:
   * `""` for normal dependencies, `"dev"` for `devDependencies`,
   * `"bundled"` for `bundledDependencies` and `"opt"` for
   * `optionalDependencies`.
   */
  PackageDependencies getADependenciesObject(string depkind) {
    result = getDependencies() and depkind = ""
    or
    result = getDevDependencies() and depkind = "dev"
    or
    result = getBundledDependencies() and depkind = "bundled"
    or
    result = getOptionalDependencies() and depkind = "opt"
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
    getADependenciesObject(_).getADependency(pkg, version)
  }

  /** Gets the engine dependencies of this package. */
  PackageDependencies getEngines() { result = getPropValue("engines") }

  /** Holds if this package has strict engine requirements. */
  predicate isEngineStrict() { getPropValue("engineStrict").(JSONBoolean).getValue() = "true" }

  /** Gets information about operating systems supported by this package. */
  JSONArray getOSs() { result = getPropValue("os") }

  /** Gets an operating system supported by this package. */
  string getWhitelistedOS() {
    result = getOSs().getElementStringValue(_) and
    not result.matches("!%")
  }

  /** Gets an operating system not supported by this package. */
  string getBlacklistedOS() {
    exists(string str | str = getOSs().getElementStringValue(_) |
      result = str.regexpCapture("!(.*)", 1)
    )
  }

  /** Gets information about platforms supported by this package. */
  JSONArray getCPUs() { result = getPropValue("cpu") }

  /** Gets a platform supported by this package. */
  string getWhitelistedCPU() {
    result = getCPUs().getElementStringValue(_) and
    not result.matches("!%")
  }

  /** Gets a platform not supported by this package. */
  string getBlacklistedCPU() {
    exists(string str | str = getCPUs().getElementStringValue(_) |
      result = str.regexpCapture("!(.*)", 1)
    )
  }

  /** Holds if this package prefers to be installed globally. */
  predicate isPreferGlobal() { getPropValue("preferGlobal").(JSONBoolean).getValue() = "true" }

  /** Holds if this is a private package. */
  predicate isPrivate() { getPropValue("private").(JSONBoolean).getValue() = "true" }

  /** Gets publishing configuration information about this package. */
  JSONValue getPublishConfig() { result = getPropValue("publishConfig") }

  /**
   * Gets the main module of this package.
   */
  Module getMainModule() {
    result = min(Module m, int prio | m.getFile() = resolveMainModule(this, prio) | m order by prio)
  }
}

/**
 * A representation of bug tracker information for an NPM package.
 */
class BugTrackerInfo extends JSONValue {
  BugTrackerInfo() {
    exists(PackageJSON pkg | pkg.getPropValue("bugs") = this) and
    (this instanceof JSONObject or this instanceof JSONString)
  }

  /** Gets the bug tracker URL. */
  string getUrl() {
    result = this.(JSONObject).getPropStringValue("url") or
    result = this.(JSONString).getValue()
  }

  /** Gets the bug reporting email address. */
  string getEmail() { result = this.(JSONObject).getPropStringValue("email") }
}

/**
 * A representation of contributor information for an NPM package.
 */
class ContributorInfo extends JSONValue {
  ContributorInfo() {
    exists(PackageJSON pkg |
      this = pkg.getPropValue("author") or
      this = pkg.getPropValue("contributors").(JSONArray).getElementValue(_)
    ) and
    (this instanceof JSONObject or this instanceof JSONString)
  }

  /**
   * Gets the `i`th item of information about a contributor, where the first
   * item is their name, the second their email address, and the third their
   * homepage URL.
   */
  private string parseInfo(int group) {
    result = this.(JSONString).getValue().regexpCapture("(.*?)(?: <(.*?)>)?(?: \\((.*)?\\))", group)
  }

  /** Gets the contributor's name. */
  string getName() {
    result = this.(JSONObject).getPropStringValue("name") or
    result = parseInfo(1)
  }

  /** Gets the contributor's email address. */
  string getEmail() {
    result = this.(JSONObject).getPropStringValue("email") or
    result = parseInfo(2)
  }

  /** Gets the contributor's homepage URL. */
  string getUrl() {
    result = this.(JSONObject).getPropStringValue("url") or
    result = parseInfo(3)
  }
}

/**
 * A representation of repository information for an NPM package.
 */
class RepositoryInfo extends JSONObject {
  RepositoryInfo() { exists(PackageJSON pkg | this = pkg.getPropValue("repository")) }

  /** Gets the repository type. */
  string getType() { result = getPropStringValue("type") }

  /** Gets the repository URL. */
  string getUrl() { result = getPropStringValue("url") }
}

/**
 * A representation of package dependencies for an NPM package.
 */
class PackageDependencies extends JSONObject {
  PackageDependencies() {
    exists(PackageJSON pkg, string name |
      name.regexpMatch("(.+D|d)ependencies|engines") and
      this = pkg.getPropValue(name)
    )
  }

  /** Holds if this package depends on version 'version' of package 'pkg'. */
  predicate getADependency(string pkg, string version) { version = getPropStringValue(pkg) }
}

/**
 * An NPM package.
 */
class NPMPackage extends @folder {
  /** The `package.json` file of this package. */
  PackageJSON pkg;

  NPMPackage() { pkg.getJsonFile().getParentContainer() = this }

  /** Gets a textual representation of this package. */
  string toString() { result = this.(Folder).toString() }

  /** Gets the full file system path of this package. */
  string getPath() { result = this.(Folder).getAbsolutePath() }

  /** Gets the `package.json` object of this package. */
  PackageJSON getPackageJSON() { result = pkg }

  /** Gets the name of this package. */
  string getPackageName() { result = getPackageJSON().getPackageName() }

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
  Module getAModule() { result.getFile() = getAFile() }

  /**
   * Gets the main module of this package.
   */
  Module getMainModule() { result = pkg.getMainModule() }

  /**
   * Holds if this package declares a dependency on version `v` of package `p`.
   */
  predicate declaresDependency(string p, string v) { pkg.declaresDependency(p, v) }
}

/**
 * Gets the parent folder of `c`, provided that they belong to the same NPM
 * package; that is, `c` must not be a `node_modules` folder.
 */
private Folder packageInternalParent(Container c) {
  result = c.getParentContainer() and
  not c.(Folder).getBaseName() = "node_modules"
}
