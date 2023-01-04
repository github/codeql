/**
 * Provides classes for modeling dependencies such as NPM packages
 * and framework libraries.
 */

import javascript
private import FrameworkLibraries
private import semmle.javascript.dependencies.DependencyCustomizations
private import semmle.javascript.frameworks.Emscripten

/**
 * An abstract representation of a dependency.
 */
abstract class Dependency extends Locatable {
  /**
   * Holds if this dependency has identifier `id` and version `v`.
   *
   * The identifier should be treated as an opaque value. If the version
   * cannot be determined, `v` is bound to the string `"unknown"`.
   */
  abstract predicate info(string id, string v);

  /**
   * Gets a use of this dependency, which is of the given `kind`.
   *
   * Currently, the only supported kinds are `"import"` and `"use"`.
   */
  abstract Locatable getAUse(string kind);
}

/**
 * A module in an NPM package, viewed as a dependency.
 *
 * This may either be a bundled NPM package that is included in
 * the source tree, or a package that is referenced as a dependency
 * in a `package.json` file.
 */
abstract class NpmDependency extends Dependency {
  /** Gets the name of the NPM package this module belongs to. */
  abstract string getNpmPackageName();

  /** DEPRECATED: Alias for getNpmPackageName */
  deprecated string getNPMPackageName() { result = this.getNpmPackageName() }

  /** Gets the version of the NPM package this module belongs to. */
  abstract string getVersion();

  /** Gets an import that imports to this module. */
  abstract Import getAnImport();

  override predicate info(string id, string v) {
    id = this.getNpmPackageName() and
    v = this.getVersion()
  }

  override Locatable getAUse(string kind) {
    exists(Import i | i = this.getAnImport() |
      kind = "import" and result = i
      or
      kind = "use" and result = getATargetVariable(i).getAnAccess()
    )
  }
}

/** DEPRECATED: Alias for NpmDependency */
deprecated class NPMDependency = NpmDependency;

/**
 * Gets a variable into which something is imported by `i`.
 */
private Variable getATargetVariable(Import i) {
  // `var v = require('m')` or `var w = require('n').p`
  exists(DataFlow::SourceNode pacc |
    pacc = propAccessOn*(i).flow() and
    pacc.flowsToExpr(result.getAnAssignedExpr())
  )
  or
  // `import { x as y }, * as z from 'm'`
  result = i.(ImportDeclaration).getASpecifier().getLocal().getVariable()
}

/**
 * Gets a property access of which `e` is the base.
 */
private Expr propAccessOn(Expr e) { result.(PropAccess).getBase() = e }

/**
 * A bundled NPM module, that is, a module in a package whose source is
 * included in the database (as opposed to an `ExternalNPMDependency`
 * which is only referenced in a `package.json` file).
 */
class BundledNpmDependency extends NpmDependency {
  BundledNpmDependency() {
    exists(NpmPackage pkg | this = pkg.getAModule() |
      // exclude packages marked "private": they have no globally unique ID
      not pkg.getPackageJson().isPrivate()
    )
  }

  /** Gets the package to which this module belongs. */
  private NpmPackage getPackage() { this = result.getAModule() }

  /** Gets the `package.json` of the package to which this module belongs. */
  private PackageJson getPackageJson() { result = this.getPackage().getPackageJson() }

  override string getNpmPackageName() { result = this.getPackageJson().getPackageName() }

  /** DEPRECATED: Alias for getNpmPackageName */
  deprecated override string getNPMPackageName() { result = this.getNpmPackageName() }

  override string getVersion() { result = this.getPackageJson().getVersion() }

  override Import getAnImport() {
    this = result.getImportedModule() and
    // ignore intra-package imports; they do not induce dependencies
    not result.getEnclosingModule() = this.getPackage().getAModule()
  }
}

/** DEPRECATED: Alias for BundledNpmDependency */
deprecated class BundledNPMDependency = BundledNpmDependency;

/**
 * An NPM package referenced in a `package.json` file.
 */
class ExternalNpmDependency extends NpmDependency {
  ExternalNpmDependency() {
    exists(PackageJson pkgjson |
      this.(JsonString) = pkgjson.getADependenciesObject(_).getPropValue(_)
    )
  }

  /** Gets the NPM package declaring this dependency. */
  private NpmPackage getDeclaringPackage() {
    this = result.getPackageJson().getADependenciesObject(_).getPropValue(_)
  }

  override string getNpmPackageName() {
    exists(PackageDependencies pkgdeps | this = pkgdeps.getPropValue(result))
  }

  /** DEPRECATED: Alias for getNpmPackageName */
  deprecated override string getNPMPackageName() { result = this.getNpmPackageName() }

  private string getVersionNumber() {
    exists(string versionRange | versionRange = this.(JsonString).getValue() |
      // extract a concrete version from the version range; currently,
      // we handle exact versions as well as `<=`, `>=`, `~` and `^` ranges
      result = versionRange.regexpCapture("(?:[><]=|[=~^])?v?(\\d+(\\.\\d+){1,2})", 1)
    )
  }

  override string getVersion() {
    result = this.getVersionNumber()
    or
    // if no version is specified or could not be parsed, report version `unknown`
    not exists(this.getVersionNumber()) and
    result = "unknown"
  }

  override Import getAnImport() {
    exists(int depth | depth = importsDependency(result, this.getDeclaringPackage(), this) |
      // restrict to those results for which this is the closest matching dependency
      depth = min(importsDependency(result, _, _))
    )
  }
}

/** DEPRECATED: Alias for ExternalNpmDependency */
deprecated class ExternalNPMDependency = ExternalNpmDependency;

/**
 * Holds if import `i` may refer to the declared dependency `dep` of package `pkg`,
 * where the result value is the nesting depth of the file containing `i` within `pkg`.
 */
private int importsDependency(Import i, NpmPackage pkg, NpmDependency dep) {
  exists(string name |
    dep = pkg.getPackageJson().getADependenciesObject(_).getPropValue(name) and
    not exists(i.getImportedModule()) and
    i.getImportedPath().getComponent(0) = name and
    i.getEnclosingModule() = pkg.getAModule() and
    result = distance(pkg, i.getFile())
  )
}

/**
 * Gets the nesting depth of `descendant` within `ancestor`.
 */
private int distance(Folder ancestor, Container descendant) {
  ancestor = descendant and result = 0
  or
  result = 1 + distance(ancestor, descendant.getParentContainer())
}

/**
 * Holds if `e` is  of the form `g.x.y.z`, where `g` is an
 * access to a global variable and `.x.y.z` is a (possibly empty)
 * sequence of property accesses. The parameter `n` is bound
 * to the string `g.x.y.z`.
 */
private predicate propAccessOnGlobal(Expr e, string n) {
  e.accessesGlobal(n)
  or
  exists(PropAccess pacc, string q | pacc = e and propAccessOnGlobal(pacc.getBase(), q) |
    n = q + "." + pacc.getPropertyName()
  )
}

/**
 * A plain JavaScript library imported via a `<script>` tag.
 */
abstract class ScriptDependency extends Dependency {
  /**
   * Gets a use of a variable defined by the imported script.
   */
  abstract Expr getAnApiUse();

  override Locatable getAUse(string kind) {
    kind = "import" and
    result = this.getFile().(HTML::HtmlFile).getATopLevel()
    or
    kind = "use" and result = this.getAnApiUse()
  }
}

/**
 * An embedded JavaScript library included inside a `<script>` tag.
 */
class InlineScriptDependency extends ScriptDependency, @toplevel instanceof FrameworkLibraryInstance {
  override predicate info(string id, string v) {
    exists(FrameworkLibrary fl |
      FrameworkLibraryInstance.super.info(fl, v) and
      id = fl.getId()
    )
  }

  override Expr getAnApiUse() {
    exists(FrameworkLibrary fl |
      FrameworkLibraryInstance.super.info(fl, _) and
      propAccessOnGlobal(result, fl.getAnEntryPoint()) and
      result.getFile() = this.getFile() and
      result.getTopLevel() != this
    )
  }
}

/**
 * An external JavaScript library referenced via the `src` attribute
 * of a `<script>` tag.
 */
class ExternalScriptDependency extends ScriptDependency, @xmlattribute instanceof FrameworkLibraryReference {
  override predicate info(string id, string v) {
    exists(FrameworkLibrary fl |
      FrameworkLibraryReference.super.info(fl, v) and
      id = fl.getId()
    )
  }

  override Expr getAnApiUse() {
    exists(FrameworkLibrary fl |
      FrameworkLibraryReference.super.info(fl, _) and
      propAccessOnGlobal(result, fl.getAnEntryPoint()) and
      result.getFile() = this.getFile()
    )
  }
}

/**
 * A dependency on GWT indicated by a GWT header script.
 */
private class GwtDependency extends ScriptDependency instanceof GwtHeader {
  override predicate info(string id, string v) {
    id = "gwt" and
    exists(GwtHeader h | h = this |
      v = h.getGwtVersion()
      or
      not exists(h.getGwtVersion()) and v = "unknown"
    )
  }

  override Expr getAnApiUse() { none() }
}

/**
 * A dependency on the Google Closure library indicated by
 * a call to `goog.require` or `goog.provide`.
 */
private class GoogleClosureDep extends Dependency, @call_expr {
  GoogleClosureDep() {
    exists(MethodCallExpr mce |
      mce = this and mce.getReceiver().(GlobalVarAccess).getName() = "goog"
    |
      mce.getMethodName() = "require" or
      mce.getMethodName() = "provide"
    )
  }

  override predicate info(string id, string v) {
    id = "closure" and
    v = "unknown"
  }

  override Locatable getAUse(string kind) {
    kind = "import" and
    result = this.(Expr).getTopLevel()
  }
}

/**
 * A dependency indicated by marker comment left by a code generator.
 */
private class GeneratorComment extends Dependency, @comment {
  GeneratorComment() { generatedBy(this, _) }

  override predicate info(string id, string v) {
    generatedBy(this, id) and
    v = "unknown"
  }

  override Locatable getAUse(string kind) {
    kind = "generated" and
    result = this.(Comment).getTopLevel()
  }
}

/**
 * Holds if `c` is a marker comment left by the given `generator`.
 */
private predicate generatedBy(Comment c, string generator) {
  c instanceof EmscriptenMarkerComment and generator = "emscripten"
  or
  exists(string gn | gn = c.(CodeGeneratorMarkerComment).getGeneratorName() |
    // map generator names to their npm package names
    gn = "CoffeeScript" and generator = "coffee-script"
    or
    gn = "PEG.js" and generator = "pegjs"
    or
    gn != "CoffeeScript" and gn != "PEG.js" and generator = gn
  )
}

/**
 * A dependency indicated by an expression left by a module bundler.
 */
private class BundledTopLevel extends Dependency, @expr {
  BundledTopLevel() {
    isBrowserifyBundle(this) or
    isWebpackBundle(this)
  }

  override predicate info(string id, string v) {
    (
      isBrowserifyBundle(this) and id = "browserify"
      or
      isWebpackBundle(this) and id = "webpack"
    ) and
    v = "unknown"
  }

  override Locatable getAUse(string kind) {
    kind = "generated" and
    result = this.(Expr).getTopLevel()
  }
}
