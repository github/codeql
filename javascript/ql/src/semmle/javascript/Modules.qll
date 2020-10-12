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
  string getAnExportedSymbol() { exists(getAnExportedValue(result)) }

  /**
   * DEPRECATED. Use `getAnExportedValue` instead.
   *
   * Holds if this module explicitly exports symbol `name` at the
   * program element `export`.
   *
   * Note that in some module systems (notably CommonJS and AMD)
   * modules are arbitrary objects that export all their
   * properties. This predicate only considers properties
   * that are explicitly defined on the module object.
   *
   * Symbols defined in another module that are re-exported by
   * this module are only sometimes considered.
   */
  deprecated predicate exports(string name, ASTNode export) {
    this instanceof AmdModule and
    exists(DataFlow::PropWrite pwn | export = pwn.getAstNode() |
      pwn.getBase().analyze().getAValue() = this.(AmdModule).getDefine().getAModuleExportsValue() and
      name = pwn.getPropertyName()
    )
    or
    this instanceof Closure::ClosureModule and
    exists(DataFlow::PropWrite write, Expr base |
      write.getAstNode() = export and
      write.writes(base.flow(), name, _) and
      (
        base = this.(Closure::ClosureModule).getExportsVariable().getAReference()
        or
        base = this.(Closure::ClosureModule).getExportsVariable().getAnAssignedExpr()
      )
    )
    or
    this instanceof NodeModule and
    (
      // a property write whose base is `exports` or `module.exports`
      exists(DataFlow::PropWrite pwn | export = pwn.getAstNode() |
        pwn.getBase() = this.(NodeModule).getAModuleExportsNode() and
        name = pwn.getPropertyName()
      )
      or
      // a re-export using spread-operator. E.g. `const foo = require("./foo"); module.exports = {bar: bar, ...foo};`
      exists(ObjectExpr obj | obj = this.(NodeModule).getAModuleExportsNode().asExpr() |
        obj
            .getAProperty()
            .(SpreadProperty)
            .getInit()
            .(SpreadElement)
            .getOperand()
            .flow()
            .getALocalSource()
            .asExpr()
            .(Import)
            .getImportedModule()
            .exports(name, export)
      )
      or
      // an externs definition (where appropriate)
      exists(PropAccess pacc | export = pacc |
        pacc.getBase() = this.(NodeModule).getAModuleExportsNode().asExpr() and
        name = pacc.getPropertyName() and
        isExterns() and
        exists(pacc.getDocumentation())
      )
    )
    or
    this instanceof ES2015Module and
    exists(ExportDeclaration ed | ed = this.(ES2015Module).getAnExport() and ed = export |
      ed.exportsAs(_, name)
    )
  }

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
  abstract DataFlow::Node getAnExportedValue(string name);

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
    result.getFile() =
      min(TypeRootFolder typeRoot |
        |
        typeRoot.getModuleFile(getImportedPath().getValue())
        order by
          typeRoot.getSearchPriority(getFile().getParentContainer())
      )
  }

  /**
   * Gets the imported module, as determined by the TypeScript compiler, if any.
   */
  private Module resolveFromTypeScriptSymbol() {
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
  Module getImportedModule() {
    if exists(resolveExternsImport())
    then result = resolveExternsImport()
    else (
      result = resolveAsProvidedModule() or
      result = resolveImportedPath() or
      result = resolveFromTypeRoot() or
      result = resolveFromTypeScriptSymbol() or
      result = resolveNeighbourPackage(this.getImportedPath().getValue())
    )
  }

  /**
   * Gets the data flow node that the default import of this import is available at.
   */
  abstract DataFlow::Node getImportedModuleNode();
}

/**
 * DEPRECATED. Use `PathExpr` instead.
 *
 * A path expression that appears in a module and is resolved relative to it.
 */
abstract deprecated class PathExprInModule extends PathExpr {
  PathExprInModule() {
    this.(Expr).getTopLevel() instanceof Module
    or
    this.(Comment).getTopLevel() instanceof Module
  }
}

/**
 * Gets a module imported from another package in the same repository.
 *
 * No support for importing from folders inside the other package.
 */
private Module resolveNeighbourPackage(PathString importPath) {
  exists(PackageJSON json | importPath = json.getPackageName() and result = json.getMainModule())
  or
  exists(string package |
    result.getFile().getParentContainer() = getPackageFolder(package) and
    importPath = package + "/" + [result.getFile().getBaseName(), result.getFile().getStem()]
  )
}

/**
 * Gets the folder for a package that has name `package` according to a package.json file in the resulting folder.
 */
pragma[noinline]
private Folder getPackageFolder(string package) {
  exists(PackageJSON json |
    json.getPackageName() = package and
    result = json.getFile().getParentContainer()
  )
}
