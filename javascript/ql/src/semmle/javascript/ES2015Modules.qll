/** Provides classes for working with ECMAScript 2015 modules. */

import javascript

/**
 * An ECMAScript 2015 module.
 *
 * Example:
 *
 * ```
 * import console from 'console';
 *
 * console.log("Hello, world!");
 * ```
 */
class ES2015Module extends Module {
  ES2015Module() { is_es2015_module(this) }

  override ModuleScope getScope() { result.getScopeElement() = this }

  /** Gets the full path of the file containing this module. */
  override string getPath() { result = getFile().getAbsolutePath() }

  /** Gets the short name of this module without file extension. */
  override string getName() { result = getFile().getStem() }

  /** Gets an export declaration in this module. */
  ExportDeclaration getAnExport() { result.getTopLevel() = this }

  override DataFlow::Node getAnExportedValue(string name) {
    exists(ExportDeclaration ed | ed = getAnExport() and result = ed.getSourceNode(name))
  }

  /** Holds if this module exports variable `v` under the name `name`. */
  predicate exportsAs(LexicalName v, string name) { getAnExport().exportsAs(v, name) }

  override predicate isStrict() {
    // modules are implicitly strict
    any()
  }
}

/**
 * Holds if `mod` contains one or more named export declarations other than `default`.
 */
private predicate hasNamedExports(ES2015Module mod) {
  mod.getAnExport().(ExportNamedDeclaration).getASpecifier().getExportedName() != "default"
  or
  exists(mod.getAnExport().(ExportNamedDeclaration).getAnExportedDecl())
  or
  // Bulk re-exports only export named bindings (not "default")
  mod.getAnExport() instanceof BulkReExportDeclaration
}

/**
 * Holds if this module contains a `default` export.
 */
private predicate hasDefaultExport(ES2015Module mod) {
  // export default foo;
  mod.getAnExport() instanceof ExportDefaultDeclaration
  or
  // export { foo as default };
  mod.getAnExport().(ExportNamedDeclaration).getASpecifier().getExportedName() = "default"
}

/**
 * Holds if `mod` contains both named and `default` exports.
 *
 * This is used to determine whether a default-import of the module should be reinterpreted
 * as a namespace-import, to accomodate the non-standard behavior implemented by some compilers.
 */
private predicate hasBothNamedAndDefaultExports(ES2015Module mod) {
  hasNamedExports(mod) and
  hasDefaultExport(mod)
}

/**
 * An import declaration.
 *
 * Examples:
 *
 * ```
 * import console, { log, error as fatal } from 'console';
 * import * as console from 'console';
 * ```
 */
class ImportDeclaration extends Stmt, Import, @import_declaration {
  override ES2015Module getEnclosingModule() { result = getTopLevel() }

  override PathExpr getImportedPath() { result = getChildExpr(-1) }

  /** Gets the `i`th import specifier of this import declaration. */
  ImportSpecifier getSpecifier(int i) { result = getChildExpr(i) }

  /** Gets an import specifier of this import declaration. */
  ImportSpecifier getASpecifier() { result = getSpecifier(_) }

  override DataFlow::Node getImportedModuleNode() {
    // `import * as http from 'http'` or `import http from `http`'
    exists(ImportSpecifier is |
      is = getASpecifier() and
      result = DataFlow::valueNode(is)
    |
      is instanceof ImportNamespaceSpecifier and
      count(getASpecifier()) = 1
      or
      // For compatibility with the non-standard implementation of default imports,
      // treat default imports as namespace imports in cases where it can't cause ambiguity
      // between named exports and the properties of a default-exported object.
      not hasBothNamedAndDefaultExports(getImportedModule()) and
      is.getImportedName() = "default"
    )
    or
    // `import { createServer } from 'http'`
    result = DataFlow::destructuredModuleImportNode(this)
  }

  /** Holds if this is declared with the `type` keyword, so it only imports types. */
  predicate isTypeOnly() { has_type_keyword(this) }

  override string getAPrimaryQlClass() { result = "ImportDeclaration" }
}

/** A literal path expression appearing in an `import` declaration. */
private class LiteralImportPath extends PathExpr, ConstantString {
  LiteralImportPath() { exists(ImportDeclaration req | this = req.getChildExpr(-1)) }

  override string getValue() { result = getStringValue() }
}

/**
 * An import specifier in an import declaration.
 *
 * Examples:
 *
 * ```
 * import
 *   console,            // default import specifier
 *   {
 *     log,              // named import specifier
 *     error as fatal    // renaming import specifier
 *   } from 'console';
 *
 * import
 *   * as console        // namespace import specifier
 *   from 'console';
 * ```
 */
class ImportSpecifier extends Expr, @import_specifier {
  /** Gets the imported symbol; undefined for default and namespace import specifiers. */
  Identifier getImported() { result = getChildExpr(0) }

  /**
   * Gets the name of the imported symbol.
   *
   * For example, consider these four imports:
   *
   * ```javascript
   * import { x } from 'a'
   * import { y as z } from 'b'
   * import f from 'c'
   * import * as g from 'd'
   * ```
   *
   * The names of the imported symbols for the first three of them are, respectively,
   * `x`, `y` and `default`, while the last one does not import an individual symbol.
   */
  string getImportedName() { result = getImported().getName() }

  /** Gets the local variable into which this specifier imports. */
  VarDecl getLocal() { result = getChildExpr(1) }

  override string getAPrimaryQlClass() { result = "ImportSpecifier" }
}

/**
 * A named import specifier.
 *
 * Examples:
 *
 * ```
 * import
 *   {
 *     log,              // named import specifier
 *     error as fatal    // renaming import specifier
 *   } from 'console';
 * ```
 */
class NamedImportSpecifier extends ImportSpecifier, @named_import_specifier { }

/**
 * A default import specifier.
 *
 * Example:
 *
 * ```
 * import
 *   console             // default import specifier
 *   from 'console';
 * ```
 */
class ImportDefaultSpecifier extends ImportSpecifier, @import_default_specifier {
  override string getImportedName() { result = "default" }
}

/**
 * A namespace import specifier.
 *
 * Example:
 *
 * ```
 * import
 *   * as console        // namespace import specifier
 *   from 'console';
 * ```
 */
class ImportNamespaceSpecifier extends ImportSpecifier, @import_namespace_specifier { }

/**
 * A bulk import that imports an entire module as a namespace.
 *
 * Example:
 *
 * ```
 * import * as console from 'console';
 * ```
 */
class BulkImportDeclaration extends ImportDeclaration {
  BulkImportDeclaration() { getASpecifier() instanceof ImportNamespaceSpecifier }

  /** Gets the local namespace variable under which the module is imported. */
  VarDecl getLocal() { result = getASpecifier().getLocal() }
}

/**
 * A selective import that imports zero or more declarations.
 *
 * Example:
 *
 * ```
 * import console, { log } from 'console';
 * ```
 */
class SelectiveImportDeclaration extends ImportDeclaration {
  SelectiveImportDeclaration() { not this instanceof BulkImportDeclaration }

  /** Holds if `local` is the local variable into which `imported` is imported. */
  predicate importsAs(string imported, LexicalDecl local) {
    exists(ImportSpecifier spec | spec = getASpecifier() |
      imported = spec.getImported().getName() and
      local = spec.getLocal()
    )
    or
    imported = "default" and local = getASpecifier().(ImportDefaultSpecifier).getLocal()
  }
}

/**
 * An export declaration.
 *
 * Examples:
 *
 * ```
 * export * from 'a';               // bulk re-export declaration
 *
 * export default function f() {};  // default export declaration
 * export default 42;               // default export declaration
 *
 * export { x, y as z };            // named export declaration
 * export var x = 42;               // named export declaration
 * export { x } from 'a';           // named re-export declaration
 * export x from 'a';               // default re-export declaration
 * ```
 */
abstract class ExportDeclaration extends Stmt, @export_declaration {
  /** Gets the module to which this export declaration belongs. */
  ES2015Module getEnclosingModule() { this = result.getAnExport() }

  /** Holds if this export declaration exports variable `v` under the name `name`. */
  abstract predicate exportsAs(LexicalName v, string name);

  /**
   * Gets the data flow node corresponding to the value this declaration exports
   * under the name `name`.
   *
   * For example, consider the following exports:
   *
   * ```javascript
   * export var x = 23;
   * export { y as z };
   * export default function f() { ... };
   * export { x } from 'a';
   * ```
   *
   * The first one exports `23` under the name `x`, the second one exports
   * `y` under the name `z`, while the third one exports `function f() { ... }`
   * under the name `default`.
   *
   * The final export re-exports under the name `x` whatever module `a`
   * exports under the same name. In particular, its source node belongs
   * to module `a` or possibly to some other module from which `a` re-exports.
   */
  abstract DataFlow::Node getSourceNode(string name);

  /** Holds if is declared with the `type` keyword, so only types are exported. */
  predicate isTypeOnly() { has_type_keyword(this) }

  override string getAPrimaryQlClass() { result = "ExportDeclaration" }
}

/**
 * A bulk re-export declaration of the form `export * from 'a'`, which re-exports
 * all exports of another module.
 *
 * Examples:
 *
 * ```
 * export * from 'a';          // bulk re-export declaration
 * ```
 */
class BulkReExportDeclaration extends ReExportDeclaration, @export_all_declaration {
  /** Gets the name of the module from which this declaration re-exports. */
  override ConstantString getImportedPath() { result = getChildExpr(0) }

  override predicate exportsAs(LexicalName v, string name) {
    getReExportedES2015Module().exportsAs(v, name) and
    not isShadowedFromBulkExport(this, name)
  }

  override DataFlow::Node getSourceNode(string name) {
    result = getReExportedES2015Module().getAnExport().getSourceNode(name)
  }
}

/**
 * Holds if the given bulk export should not re-export `name` because there is an explicit export
 * of that name in the same module.
 *
 * At compile time, shadowing works across declaration spaces.
 * For instance, directly exporting an interface `X` will block a variable `X` from being re-exported:
 * ```
 * export interface X {}
 * export * from 'lib' // will not re-export X
 * ```
 * At runtime, the interface `X` will have been removed, so `X` is actually re-exported anyway,
 * but we ignore this subtlety.
 */
private predicate isShadowedFromBulkExport(BulkReExportDeclaration reExport, string name) {
  exists(ExportNamedDeclaration other | other.getTopLevel() = reExport.getEnclosingModule() |
    other.getAnExportedDecl().getName() = name
    or
    other.getASpecifier().getExportedName() = name
  )
}

/**
 * A default export declaration.
 *
 * Examples:
 *
 * ```
 * export default function f() {};
 * export default 42;
 * ```
 */
class ExportDefaultDeclaration extends ExportDeclaration, @export_default_declaration {
  /** Gets the operand statement or expression that is exported by this declaration. */
  ExprOrStmt getOperand() { result = getChild(0) }

  override predicate exportsAs(LexicalName v, string name) {
    name = "default" and v = getADecl().getVariable()
  }

  /** Gets the declaration, if any, exported by this default export. */
  VarDecl getADecl() {
    exists(ExprOrStmt op | op = getOperand() |
      result = op.(FunctionDeclStmt).getIdentifier() or
      result = op.(ClassDeclStmt).getIdentifier()
    )
  }

  override DataFlow::Node getSourceNode(string name) {
    name = "default" and result = DataFlow::valueNode(getOperand())
  }
}

/**
 * A named export declaration.
 *  *
 * Examples:
 *
 * ```
 * export { x, y as z };
 * export var x = 42;
 * export { x } from 'a';
 * ```
 */
class ExportNamedDeclaration extends ExportDeclaration, @export_named_declaration {
  /** Gets the operand statement or expression that is exported by this declaration. */
  ExprOrStmt getOperand() { result = getChild(-1) }

  /**
   * Gets an identifier, if any, exported as part of a declaration by this named export.
   *
   * Does not include names of export specifiers.
   * That is, it includes the `v` in `export var v` but not in `export {v}`.
   */
  Identifier getAnExportedDecl() {
    exists(ExprOrStmt op | op = getOperand() |
      result = op.(DeclStmt).getADecl().getBindingPattern().getABindingVarRef() or
      result = op.(FunctionDeclStmt).getIdentifier() or
      result = op.(ClassDeclStmt).getIdentifier() or
      result = op.(NamespaceDeclaration).getIdentifier() or
      result = op.(EnumDeclaration).getIdentifier() or
      result = op.(InterfaceDeclaration).getIdentifier() or
      result = op.(TypeAliasDeclaration).getIdentifier() or
      result = op.(ImportEqualsDeclaration).getIdentifier()
    )
  }

  /** Gets the variable declaration, if any, exported by this named export. */
  VarDecl getADecl() { result = getAnExportedDecl() }

  override predicate exportsAs(LexicalName v, string name) {
    exists(LexicalDecl vd | vd = getAnExportedDecl() |
      name = vd.getName() and v = vd.getALexicalName()
    )
    or
    exists(ExportSpecifier spec | spec = getASpecifier() and name = spec.getExportedName() |
      v = spec.getLocal().(LexicalAccess).getALexicalName()
      or
      this.(ReExportDeclaration).getReExportedES2015Module().exportsAs(v, spec.getLocalName())
    )
  }

  override DataFlow::Node getSourceNode(string name) {
    exists(VarDef d | d.getTarget() = getADecl() |
      name = d.getTarget().(VarDecl).getName() and
      result = DataFlow::valueNode(d.getSource())
    )
    or
    exists(ObjectPattern obj | obj = getOperand().(DeclStmt).getADecl().getBindingPattern() |
      exists(DataFlow::PropRead read | read = result |
        read.getBase() = obj.flow() and
        name = read.getPropertyName()
      )
    )
    or
    exists(ExportSpecifier spec | spec = getASpecifier() and name = spec.getExportedName() |
      not exists(getImportedPath()) and result = DataFlow::valueNode(spec.getLocal())
      or
      exists(ReExportDeclaration red | red = this |
        result = red.getReExportedES2015Module().getAnExport().getSourceNode(spec.getLocalName())
      )
    )
  }

  /** Gets the module from which the exports are taken if this is a re-export. */
  ConstantString getImportedPath() { result = getChildExpr(-2) }

  /** Gets the `i`th export specifier of this declaration. */
  ExportSpecifier getSpecifier(int i) { result = getChildExpr(i) }

  /** Gets an export specifier of this declaration. */
  ExportSpecifier getASpecifier() { result = getSpecifier(_) }
}

/**
 * An export declaration with the `type` modifier.
 */
private class TypeOnlyExportDeclaration extends ExportNamedDeclaration {
  TypeOnlyExportDeclaration() { isTypeOnly() }

  override predicate exportsAs(LexicalName v, string name) {
    super.exportsAs(v, name) and
    not v instanceof Variable
  }
}

/**
 * An export specifier in an export declaration.
 *
 * Examples:
 *
 * ```
 * export
 *   *              // namespace export specifier
 *   from 'a';
 *
 * export
 *   default        // default export specifier
 *   var x = 42;
 *
 * export {
 *   x,             // named export specifier
 *   y as z         // named export specifier
 * };
 *
 * export
 *   x              // default re-export specifier
 *   from 'a';
 * ```
 */
class ExportSpecifier extends Expr, @exportspecifier {
  /** Gets the declaration to which this specifier belongs. */
  ExportDeclaration getExportDeclaration() { result = getParent() }

  /** Gets the local symbol that is being exported. */
  Identifier getLocal() { result = getChildExpr(0) }

  /** Gets the name under which the symbol is exported. */
  Identifier getExported() { result = getChildExpr(1) }

  /**
   * Gets the local name of the exported symbol, that is, the name
   * of the exported local variable, or the imported name in a
   * re-export.
   *
   * For example, consider these six exports:
   *
   * ```javascript
   * export { x }
   * export { y as z }
   * export function f() {}
   * export default 42
   * export * from 'd'
   * export default from 'm'
   * ```
   *
   * The local names for the first three of them are, respectively,
   * `x`, `y` and `f`; the fourth one exports an un-named value, and
   * hence has no local name; the fifth one does not export a unique
   * name, and hence also does not have a local name.
   *
   * The sixth one (unlike the fourth one) _does_ have a local name
   * (that is, `default`), since it is a re-export.
   */
  string getLocalName() { result = getLocal().getName() }

  /**
   * Gets the name under which the symbol is exported.
   *
   * For example, consider these five exports:
   *
   * ```javascript
   * export { x }
   * export { y as z }
   * export function f() {}
   * export default 42
   * export * from 'd'
   * ```
   *
   * The exported names for the first four of them are, respectively,
   * `x`, `z`, `f` and `default`, while the last one does not have
   * an exported name since it does not export a unique symbol.
   */
  string getExportedName() { result = getExported().getName() }

  override string getAPrimaryQlClass() { result = "ExportSpecifier" }
}

/**
 * A named export specifier.
 *
 * Examples:
 *
 * ```
 * export {
 *   x,       // named export specifier
 *   y as z   // named export specifier
 * };
 * ```
 */
class NamedExportSpecifier extends ExportSpecifier, @named_export_specifier { }

/**
 * A default export specifier.
 *
 * Examples:
 *
 * ```
 * export
 *   default    // default export specifier
 *   42;
 * export
 *   x          // default re-export specifier
 *   from 'a';
 * ```
 */
class ExportDefaultSpecifier extends ExportSpecifier, @export_default_specifier {
  override string getExportedName() { result = "default" }
}

/**
 * A default export specifier in a re-export declaration.
 *
 * Example:
 *
 * ```
 * export
 *   x          // default re-export specifier
 *   from 'a';
 * ```
 */
class ReExportDefaultSpecifier extends ExportDefaultSpecifier {
  ReExportDefaultSpecifier() { getExportDeclaration() instanceof ReExportDeclaration }

  override string getLocalName() { result = "default" }

  override string getExportedName() { result = getExported().getName() }
}

/**
 * A namespace export specifier, that is `*` or `* as x` occuring in an export declaration.
 *
 * Examples:
 *
 * ```
 * export
 *   *          // namespace export specifier
 *   from 'a';
 *
 * export
 *   * as x     // namespace export specifier
 *   from 'a';
 * ```
 */
class ExportNamespaceSpecifier extends ExportSpecifier, @export_namespace_specifier { }

/**
 * An export declaration that re-exports declarations from another module.
 *
 * Examples:
 *
 * ```
 * export * from 'a';               // bulk re-export declaration
 * export * as x from 'a';          // namespace re-export declaration
 * export { x } from 'a';           // named re-export declaration
 * export x from 'a';               // default re-export declaration
 * ```
 */
abstract class ReExportDeclaration extends ExportDeclaration {
  /** Gets the path of the module from which this declaration re-exports. */
  abstract ConstantString getImportedPath();

  /**
   * DEPRECATED. Use `getReExportedES2015Module()` instead.
   *
   * Gets the module from which this declaration re-exports.
   */
  deprecated ES2015Module getImportedModule() { result = getReExportedModule() }

  /** Gets the module from which this declaration re-exports, if it is an ES2015 module. */
  ES2015Module getReExportedES2015Module() { result = getReExportedModule() }

  /** Gets the module from which this declaration re-exports. */
  Module getReExportedModule() {
    result.getFile() = getEnclosingModule().resolve(getImportedPath().(PathExpr))
    or
    result = resolveFromTypeRoot()
  }

  /**
   * Gets a module in a `node_modules/@types/` folder that matches the imported module name.
   */
  private Module resolveFromTypeRoot() {
    result.getFile() =
      min(TypeRootFolder typeRoot |
        |
        typeRoot.getModuleFile(getImportedPath().getStringValue())
        order by
          typeRoot.getSearchPriority(getFile().getParentContainer())
      )
  }
}

/** A literal path expression appearing in a re-export declaration. */
private class LiteralReExportPath extends PathExpr, ConstantString {
  LiteralReExportPath() { exists(ReExportDeclaration bred | this = bred.getImportedPath()) }

  override string getValue() { result = getStringValue() }
}

/**
 * A named export declaration that re-exports symbols imported from another module.
 *
 * Example:
 *
 * ```
 * export { x } from 'a';
 * ```
 */
class SelectiveReExportDeclaration extends ReExportDeclaration, ExportNamedDeclaration {
  SelectiveReExportDeclaration() { exists(ExportNamedDeclaration.super.getImportedPath()) }

  /** Gets the path of the module from which this declaration re-exports. */
  override ConstantString getImportedPath() {
    result = ExportNamedDeclaration.super.getImportedPath()
  }
}

/**
 * An export declaration that exports zero or more declarations from the module it appears in.
 *
 * Examples:
 *
 * ```
 * export default function f() {};
 * export default 42;
 * export { x, y as z };
 * export var x = 42;
 * ```
 */
class OriginalExportDeclaration extends ExportDeclaration {
  OriginalExportDeclaration() { not this instanceof ReExportDeclaration }

  override predicate exportsAs(LexicalName v, string name) {
    this.(ExportDefaultDeclaration).exportsAs(v, name) or
    this.(ExportNamedDeclaration).exportsAs(v, name)
  }

  override DataFlow::Node getSourceNode(string name) {
    result = this.(ExportDefaultDeclaration).getSourceNode(name) or
    result = this.(ExportNamedDeclaration).getSourceNode(name)
  }
}
