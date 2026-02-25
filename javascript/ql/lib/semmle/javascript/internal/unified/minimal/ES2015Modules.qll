/** Provides classes for working with ECMAScript 2015 modules. */
overlay[local?]
module;

import minimal

class Module extends TopLevel {
  /** Gets the full path of the file containing this module. */
  string getPath() { result = this.getFile().getAbsolutePath() }

  /** Gets the short name of this module without file extension. */
  string getName() { result = this.getFile().getStem() }
}

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

  /** Gets an export declaration in this module. */
  pragma[nomagic]
  ExportDeclaration getAnExport() { result.getTopLevel() = this }

  override predicate isStrict() {
    // modules are implicitly strict
    any()
  }

  /**
   * Holds if this module contains both named and `default` exports.
   *
   * This is used to determine whether a default-import of the module should be reinterpreted
   * as a namespace-import, to accommodate the non-standard behavior implemented by some compilers.
   *
   * When a module has both named and `default` exports, the non-standard interpretation can lead to
   * ambiguities, so we only allow the standard interpretation in that case.
   */
  overlay[global]
  predicate hasBothNamedAndDefaultExports() {
    hasNamedExports(this) and
    hasDefaultExport(this)
  }
}

/**
 * Holds if `mod` contains one or more named export declarations other than `default`.
 */
overlay[global]
private predicate hasNamedExports(ES2015Module mod) {
  mod.getAnExport().(ExportNamedDeclaration).getASpecifier().getExportedName() != "default"
  or
  exists(mod.getAnExport().(ExportNamedDeclaration).getAnExportedDecl())
  or
  // Bulk re-exports only export named bindings (not "default")
  mod.getAnExport() instanceof BulkReExportDeclaration
}

/**
 * Holds if this module contains a default export.
 */
overlay[global]
private predicate hasDefaultExport(ES2015Module mod) {
  // export default foo;
  mod.getAnExport() instanceof ExportDefaultDeclaration
  or
  // export { foo as default };
  mod.getAnExport().(ExportNamedDeclaration).getASpecifier().getExportedName() = "default"
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
class ImportDeclaration extends Stmt, @import_declaration {
  /**
   * INTERNAL USE ONLY. DO NOT USE.
   */
  string getRawImportPath() { result = this.getChildExpr(-1).getStringValue() }

  Expr getImportedPathExpr() { result = this.getChildExpr(-1) }

  /**
   * Gets the object literal passed as part of the `with` (or `assert`) clause in this import declaration.
   *
   * For example, this gets the `{ type: "json" }` object literal in the following:
   * ```js
   * import foo from "foo" with { type: "json" };
   * import foo from "foo" assert { type: "json" };
   * ```
   */
  ObjectExpr getImportAttributes() { result = this.getChildExpr(-10) }

  /**
   * DEPRECATED: use `getImportAttributes` instead.
   * Gets the object literal passed as part of the `with` (or `assert`) clause in this import declaration.
   *
   * For example, this gets the `{ type: "json" }` object literal in the following:
   * ```js
   * import foo from "foo" with { type: "json" };
   * import foo from "foo" assert { type: "json" };
   * ```
   */
  deprecated ObjectExpr getImportAssertion() { result = this.getImportAttributes() }

  /** Gets the `i`th import specifier of this import declaration. */
  ImportSpecifier getSpecifier(int i) { result = this.getChildExpr(i) }

  /** Gets an import specifier of this import declaration. */
  ImportSpecifier getASpecifier() { result = this.getSpecifier(_) }

  /** Holds if this is declared with the `type` keyword, so it only imports types. */
  predicate isTypeOnly() { has_type_keyword(this) }

  /**
   * Holds if this is declared with the `defer` keyword, for example:
   * ```ts
   * import defer * as f from "somewhere";
   * ```
   */
  predicate isDeferredImport() { has_defer_keyword(this) }

  override string getAPrimaryQlClass() { result = "ImportDeclaration" }
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
  /** Gets the import declaration in which this specifier appears. */
  overlay[global]
  ImportDeclaration getImportDeclaration() { result.getASpecifier() = this }

  /** Gets the imported symbol; undefined for default and namespace import specifiers. */
  Identifier getImported() { result = this.getChildExpr(0) }

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
  string getImportedName() { result = this.getImported().getName() }

  /** Gets the local variable into which this specifier imports. */
  VarDecl getLocal() { result = this.getChildExpr(1) }

  override string getAPrimaryQlClass() { result = "ImportSpecifier" }

  /** Holds if this is declared with the `type` keyword, so only types are imported. */
  predicate isTypeOnly() { has_type_keyword(this) }
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
  BulkImportDeclaration() { this.getASpecifier() instanceof ImportNamespaceSpecifier }

  /** Gets the local namespace variable under which the module is imported. */
  VarDecl getLocal() { result = this.getASpecifier().getLocal() }
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
overlay[global]
class SelectiveImportDeclaration extends ImportDeclaration {
  SelectiveImportDeclaration() { not this instanceof BulkImportDeclaration }

  /** Holds if `local` is the local variable into which `imported` is imported. */
  predicate importsAs(string imported, LexicalDecl local) {
    exists(ImportSpecifier spec | spec = this.getASpecifier() |
      imported = spec.getImported().getName() and
      local = spec.getLocal()
    )
    or
    imported = "default" and local = this.getASpecifier().(ImportDefaultSpecifier).getLocal()
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
  overlay[global]
  ES2015Module getEnclosingModule() { this = result.getAnExport() }

  /**
   * Holds if this export declaration exports variable `v` under the name `name`,
   * not counting re-exports.
   */
  predicate exportsDirectlyAs(LexicalName v, string name) { none() }

  /** Holds if is declared with the `type` keyword, so only types are exported. */
  predicate isTypeOnly() { has_type_keyword(this) }

  override string getAPrimaryQlClass() { result = "ExportDeclaration" }

  /**
   * Gets the object literal passed as part of the `with` (or `assert`) clause, if this is
   * a re-export declaration.
   *
   * For example, this gets the `{ type: "json" }` expression in each of the following:
   * ```js
   * export { x } from 'foo' with { type: "json" };
   * export * from 'foo' with { type: "json" };
   * export * as x from 'foo' with { type: "json" };
   * export * from 'foo' assert { type: "json" };
   * ```
   */
  ObjectExpr getImportAttributes() { result = this.getChildExpr(-10) }

  /**
   * DEPRECATED: use `getImportAttributes` instead.
   * Gets the object literal passed as part of the `with` (or `assert`) clause, if this is
   * a re-export declaration.
   *
   * For example, this gets the `{ type: "json" }` expression in each of the following:
   * ```js
   * export { x } from 'foo' with { type: "json" };
   * export * from 'foo' with { type: "json" };
   * export * as x from 'foo' with { type: "json" };
   * export * from 'foo' assert { type: "json" };
   * ```
   */
  deprecated ObjectExpr getImportAssertion() { result = this.getImportAttributes() }
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
  override Expr getImportedPathExpr() { result = this.getChildExpr(0) }
}

/**
 * Holds if bulk re-exports in `mod` should not re-export `name` because there is an explicit export
 * of that name in `mod`.
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
overlay[global]
predicate isShadowedFromBulkExport(Module mod, string name) {
  exists(ExportNamedDeclaration other | other.getTopLevel() = mod |
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
  ExprOrStmt getOperand() { result = this.getChild(0) }

  override predicate exportsDirectlyAs(LexicalName v, string name) {
    name = "default" and v = this.getADecl().getVariable()
  }

  /** Gets the declaration, if any, exported by this default export. */
  VarDecl getADecl() {
    exists(ExprOrStmt op | op = this.getOperand() |
      result = op.(FunctionDeclStmt).getIdentifier() or
      result = op.(ClassDeclStmt).getIdentifier()
    )
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
  ExprOrStmt getOperand() { result = this.getChild(-1) }

  /**
   * Gets an identifier, if any, exported as part of a declaration by this named export.
   *
   * Does not include names of export specifiers.
   * That is, it includes the `v` in `export var v` but not in `export {v}`.
   */
  Identifier getAnExportedDecl() {
    exists(ExprOrStmt op | op = this.getOperand() |
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
  VarDecl getADecl() { result = this.getAnExportedDecl() }

  override predicate exportsDirectlyAs(LexicalName v, string name) {
    (
      exists(LexicalDecl vd | vd = this.getAnExportedDecl() |
        name = vd.getName() and v = vd.getALexicalName()
      )
      or
      exists(ExportSpecifier spec | spec = this.getASpecifier() and name = spec.getExportedName() |
        v = spec.getLocal().(LexicalAccess).getALexicalName()
      )
    ) and
    not (this.isTypeOnly() and v instanceof Variable)
  }

  /** Gets the module from which the exports are taken if this is a re-export. */
  Expr getImportedPathExpr() { result = this.getChildExpr(-2) }

  /** Gets the `i`th export specifier of this declaration. */
  ExportSpecifier getSpecifier(int i) { result = this.getChildExpr(i) }

  /** Gets an export specifier of this declaration. */
  ExportSpecifier getASpecifier() { result = this.getSpecifier(_) }
}

private import semmle.javascript.dataflow.internal.PreCallGraphStep

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
  ExportDeclaration getExportDeclaration() { result = this.getParent() }

  /** Gets the local symbol that is being exported. */
  Identifier getLocal() { result = this.getChildExpr(0) }

  /** Gets the name under which the symbol is exported. */
  Identifier getExported() { result = this.getChildExpr(1) }

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
  string getLocalName() { result = this.getLocal().getName() }

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
  string getExportedName() { result = this.getExported().getName() }

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
  ReExportDefaultSpecifier() { this.getExportDeclaration() instanceof ReExportDeclaration }

  override string getLocalName() { result = "default" }

  override string getExportedName() { result = this.getExported().getName() }
}

/**
 * A namespace export specifier, that is `*` or `* as x` occurring in an export declaration.
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
  abstract Expr getImportedPathExpr();
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
  SelectiveReExportDeclaration() { exists(ExportNamedDeclaration.super.getImportedPathExpr()) }

  /** Gets the path of the module from which this declaration re-exports. */
  override Expr getImportedPathExpr() {
    result = ExportNamedDeclaration.super.getImportedPathExpr()
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
}
