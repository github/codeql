/**
 * Provides classes for working with JavaScript modules, both
 * ECMAScript 2015-style modules, and the older CommonJS and AMD-style
 * modules.
 */

import javascript

/**
 * A module, which may either be an ECMAScript 2015-style module,
 * a CommonJS module, or an AMD module.
 */
abstract class Module extends TopLevel {
  /** Gets the full path of the file containing this module. */
  string getPath() { result = getFile().getAbsolutePath() }

  /** Gets the short name of this module without file extension. */
  string getName() { result = getFile().getStem() }

  /** Gets an import appearing in this module. */
  Import getAnImport() { result.getTopLevel() = this }

  /** Gets a module from which this module imports. */
  Module getAnImportedModule() { result = getAnImport().getImportedModule() }

  /** Gets a symbol exported by this module. */
  string getAnExportedSymbol() { exports(result, _) }

  /**
   * Holds if this module explicitly exports symbol `name` at the
   * program element `export`.
   *
   * Note that in some module systems (notably CommonJS and AMD)
   * modules are arbitrary objects that export all their
   * properties. This predicate only considers properties
   * that are explicitly defined on the module object.
   *
   * Symbols defined in another module that are re-exported by
   * this module are not considered either.
   */
  abstract predicate exports(string name, ASTNode export);

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
  predicate searchRoot(PathExpr path, Folder searchRoot, int priority) {
    path.getEnclosingModule() = this and
    priority = 0 and
    exists(string v | v = path.getValue() |
      // paths starting with a dot are resolved relative to the module's directory
      if v.matches(".%")
      then searchRoot = getFile().getParentContainer()
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
  File resolve(PathExpr path) {
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
abstract class Import extends ASTNode {
  /** Gets the module in which this import appears. */
  abstract Module getEnclosingModule();

  /** Gets the (unresolved) path that this import refers to. */
  abstract PathExpr getImportedPath();

  /**
   * Gets an externs module the path of this import resolves to.
   *
   * Any externs module whose name exactly matches the imported
   * path is assumed to be a possible target of the import.
   */
  Module resolveExternsImport() {
    result.isExterns() and result.getName() = getImportedPath().getValue()
  }

  /**
   * Gets the module the path of this import resolves to.
   */
  Module resolveImportedPath() {
    result.getFile() = getEnclosingModule().resolve(getImportedPath())
  }

  /**
   * Gets a module with a `@providesModule` JSDoc tag that matches
   * the imported path.
   */
  private Module resolveAsProvidedModule() {
    exists(JSDocTag tag |
      tag.getTitle() = "providesModule" and
      tag.getParent().getComment().getTopLevel() = result and
      tag.getDescription().trim() = getImportedPath().getValue()
    )
  }

  /**
   * Gets a module in a `node_modules/@types/` folder that matches the imported module name.
   */
  private Module resolveFromTypeRoot() {
    result.getFile() = min(TypeRootFolder typeRoot |
        |
        typeRoot.getModuleFile(getImportedPath().getValue())
        order by
          typeRoot.getSearchPriority(getFile().getParentContainer())
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
  Module getImportedModule() {
    if exists(resolveExternsImport())
    then result = resolveExternsImport()
    else (
      result = resolveAsProvidedModule() or
      result = resolveImportedPath() or
      result = resolveFromTypeRoot()
    )
  }

  /**
   * Gets the data flow node that the default import of this import is available at.
   */
  abstract DataFlow::Node getImportedModuleNode();
}

/**
 * A path expression that appears in a module and is resolved relative to it.
 */
abstract class PathExprInModule extends PathExpr {
  PathExprInModule() { exists(getEnclosingModule()) }

  override Folder getSearchRoot(int priority) {
    getEnclosingModule().searchRoot(this, result, priority)
  }
}
