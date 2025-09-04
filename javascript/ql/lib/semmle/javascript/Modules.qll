/**
 * Provides classes for working with JavaScript modules, both
 * ECMAScript 2015-style modules, and the older CommonJS and AMD-style
 * modules.
 */

import javascript
private import semmle.javascript.internal.CachedStages
private import semmle.javascript.internal.paths.PathExprResolver

/**
 * A module, which may either be an ECMAScript 2015-style module,
 * a CommonJS module, or an AMD module.
 */
abstract class Module extends TopLevel {
  /** Gets the full path of the file containing this module. */
  string getPath() { result = this.getFile().getAbsolutePath() }

  /** Gets the short name of this module without file extension. */
  string getName() { result = this.getFile().getStem() }

  /** Gets an import appearing in this module. */
  Import getAnImport() { result.getTopLevel() = this }

  /** Gets a module from which this module imports. */
  Module getAnImportedModule() { result = this.getAnImport().getImportedModule() }

  /** Gets a symbol exported by this module. */
  string getAnExportedSymbol() { exists(this.getAnExportedValue(result)) }

  /**
   * Get a value that is explicitly exported from this module with under `name`.
   *
   * Note that in some module systems (notably CommonJS and AMD)
   * modules are arbitrary objects that export all their
   * properties. This predicate only considers properties
   * that are explicitly defined on the module object.
   *
   * Symbols defined in another module that are re-exported by
   * this module are only sometimes considered.
   */
  cached
  abstract DataFlow::Node getAnExportedValue(string name);

  /**
   * Gets a value that is exported as the whole exports object of this module.
   */
  cached
  DataFlow::Node getABulkExportedNode() { none() } // overridden in subclasses

  /**
   * Gets the ES2015 `default` export from this module, or for other types of modules,
   * gets a bulk exported node.
   *
   * This can be used to determine which value a default-import will likely refer to,
   * as the interaction between different module types is not standardized.
   */
  DataFlow::Node getDefaultOrBulkExport() {
    result = [this.getAnExportedValue("default"), this.getABulkExportedNode()]
  }

  /**
   * Gets the root folder relative to which the given import path (which must
   * appear in this module) is resolved.
   *
   * Each root has an associated priority, and roots with numerically smaller
   * priority are preferred during import resolution.
   *
   * This predicate is not part of the public API, it is only exposed to allow
   * overriding by subclasses.
   */
  deprecated predicate searchRoot(PathExpr path, Folder searchRoot, int priority) {
    path.getEnclosingModule() = this and
    priority = 0 and
    exists(string v | v = path.getValue() |
      // paths starting with a dot are resolved relative to the module's directory
      if v.matches(".%")
      then searchRoot = this.getFile().getParentContainer()
      else
        // all other paths are resolved relative to the file system root
        searchRoot.getBaseName() = ""
    )
  }

  /**
   * Gets the file to which the import path `path`, which must appear in this
   * module, resolves.
   *
   * If the path resolves to a file directly, this is the result. If the path
   * resolves to a folder containing a main module (such as `index.js`), then
   * that file is the result.
   */
  deprecated File resolve(PathExpr path) {
    path.getEnclosingModule() = this and
    (
      // handle the case where the import path is complete
      exists(Container c | c = path.resolve() |
        // import may refer to a file...
        result = c
        or
        // ...or to a directory, in which case we import index.js in that directory
        result = c.(Folder).getJavaScriptFile("index")
      )
      or
      // handle the case where the import path is missing the extension
      exists(Folder f | f = path.resolveUpTo(path.getNumComponent() - 1) |
        result = f.getJavaScriptFile(path.getBaseName())
        or
        // If a js file was not found look for a file that compiles to js
        path.getExtension() = ".js" and
        not exists(f.getJavaScriptFile(path.getBaseName())) and
        result = f.getJavaScriptFile(path.getStem())
      )
    )
  }
}

/**
 * An import in a module, which may be an ECMAScript 2015-style
 * `import` statement, a CommonJS-style `require` import, or an AMD dependency.
 */
abstract class Import extends AstNode {
  /** Gets the module in which this import appears. */
  abstract Module getEnclosingModule();

  /** DEPRECATED. Use `getImportedPathExpr` instead. */
  deprecated PathExpr getImportedPath() { result = this.getImportedPathExpr() }

  /** Gets the (unresolved) path that this import refers to. */
  abstract Expr getImportedPathExpr();

  /** Gets the imported path as a string. */
  final string getImportedPathString() { result = this.getImportedPathExpr().getStringValue() }

  /**
   * Gets an externs module the path of this import resolves to.
   *
   * Any externs module whose name exactly matches the imported
   * path is assumed to be a possible target of the import.
   */
  Module resolveExternsImport() {
    result.isExterns() and result.getName() = this.getImportedPathString()
  }

  /**
   * Gets the module the path of this import resolves to.
   */
  Module resolveImportedPath() { result.getFile() = this.getImportedFile() }

  /**
   * Gets the module the path of this import resolves to.
   */
  File getImportedFile() { result = ImportPathResolver::resolveExpr(this.getImportedPathExpr()) }

  /**
   * DEPRECATED. Use `getImportedModule()` instead.
   */
  deprecated Module resolveFromTypeScriptSymbol() {
    exists(CanonicalName symbol |
      ast_node_symbol(this, symbol) and
      ast_node_symbol(result, symbol)
    )
  }

  /**
   * Gets the module this import refers to.
   *
   * The result is either an externs module, or an actual source module;
   * in cases of ambiguity, the former are preferred. This models the runtime
   * behavior of Node.js imports, which prefer core modules such as `fs` over any
   * source module of the same name.
   */
  cached
  Module getImportedModule() {
    Stages::Imports::ref() and
    if exists(this.resolveExternsImport())
    then result = this.resolveExternsImport()
    else result = this.resolveImportedPath()
  }

  /**
   * Gets the data flow node referring to imported module object.
   *
   * For example:
   * ```js
   * // ES2015 style
   * import * as foo from "bar"; // gets the node for `foo`
   * import foo from "bar"; // gets the node for `foo` (see note on default imports below)
   *
   * // CommonJS style
   * require("bar"); // gets the node for the `require` call
   *
   * // AMD style
   * define(["bar"], function(foo) { // gets the node for the `foo` parameter
   * })
   * ```
   *
   * For statements of form `import foo from "bar'`, this gives the node corresponding to `foo`.
   * Technically this should refer to the export binding named `"default"`, not the whole module, but for compatibility with non-standard
   * interpretations of default imports, this node is usually treated as also referring to the whole module.
   * If this behaviour is not wanted, use `isDefaultImport()` to handle that case differently.
   */
  abstract DataFlow::Node getImportedModuleNode();

  /**
   * Holds if the result of `getImportedModuleNode` actually refers to the export binding named `"default"`,
   * as opposed an object whose properties correspond to the export bindings of the imported module.
   *
   * For compatibility with non-standard interpretations of `default` imports, the default
   * import is usually returned by `getImportedModuleNode()`. If such behaviour is not wanted,
   * this predicate can be used to handle that case differently.
   *
   * For example, `getImportedModuleNode()` returns `foo` in both of these imports, but `isDefaultImport()`
   * only holds for the first one:
   * ```js
   * import foo from "bar";
   * import * as foo from "bar";
   * ```
   */
  predicate isDefaultImport() { none() }

  /**
   * Gets the same as `getImportedModuleNode()` except this has no result for default imports when the target module
   * has both default and named exports.
   *
   * This is to avoid ambiguity between named export bindings and the properties of the default-exported object.
   */
  pragma[nomagic]
  final DataFlow::Node getImportedModuleNodeIfUnambiguous() {
    if
      this.isDefaultImport() and
      this.getImportedModule().(ES2015Module).hasBothNamedAndDefaultExports()
    then none()
    else result = this.getImportedModuleNode()
  }
}
