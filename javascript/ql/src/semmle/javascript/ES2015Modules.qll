/** Provides classes for working with ECMAScript 2015 modules. */

import javascript

/**
 * An ECMAScript 2015 module.
 */
class ES2015Module extends Module {
  ES2015Module() { isES2015Module(this) }

  override ModuleScope getScope() { result.getScopeElement() = this }

  /** Gets the full path of the file containing this module. */
  override string getPath() { result = getFile().getAbsolutePath() }

  /** Gets the short name of this module without file extension. */
  override string getName() { result = getFile().getStem() }

  /** Gets an export declaration in this module. */
  ExportDeclaration getAnExport() { result.getTopLevel() = this }

  override predicate exports(string name, ASTNode export) {
    exists(ExportDeclaration ed | ed = getAnExport() and ed = export | ed.exportsAs(_, name))
  }

  /** Holds if this module exports variable `v` under the name `name`. */
  predicate exportsAs(LexicalName v, string name) { getAnExport().exportsAs(v, name) }

  override predicate isStrict() {
    // modules are implicitly strict
    any()
  }
}

/** An import declaration. */
class ImportDeclaration extends Stmt, Import, @importdeclaration {
  override ES2015Module getEnclosingModule() { result = getTopLevel() }

  override PathExprInModule getImportedPath() { result = getChildExpr(-1) }

  /** Gets the `i`th import specifier of this import declaration. */
  ImportSpecifier getSpecifier(int i) { result = getChildExpr(i) }

  /** Gets an import specifier of this import declaration. */
  ImportSpecifier getASpecifier() { result = getSpecifier(_) }

  override DataFlow::Node getDefaultNode() {
    // `import * as http from 'http'` or `import http from `http`'
    exists(ImportSpecifier is |
      is = getASpecifier() and
      result = DataFlow::ssaDefinitionNode(SSA::definition(is))
    |
      is instanceof ImportNamespaceSpecifier and
      count(getASpecifier()) = 1
      or
      is.getImportedName() = "default"
    )
    or
    // `import { createServer } from 'http'`
    result = DataFlow::destructuredModuleImportNode(this)
  }
}

/** A literal path expression appearing in an `import` declaration. */
private class LiteralImportPath extends PathExprInModule, ConstantString {
  LiteralImportPath() { exists(ImportDeclaration req | this = req.getChildExpr(-1)) }

  override string getValue() { result = this.(ConstantString).getStringValue() }
}

/**
 * An import specifier in an import declaration.
 *
 * There are four kinds of import specifiers:
 *
 *   - default import specifiers, which import the default export of a module
 *     and make it available under a local name, as in `import` <u>`f`</u> `from 'a'`;
 *   - namespace import specifiers, which import all exports of a module and
 *     make them available through a local namespace object, as in
 *     `import` <u>`* as ns`</u> `from 'a'`;
 *   - named import specifiers, which import a named export of a module and
 *     make it available in the importing module under the same name, as in
 *     `import {` <u>`x`</u> `} from 'a'`;
 *   - renaming import specifiers, which import a named export of a module and
 *     make it available in the importing module under a different name, as in
 *     `import {` <u>`x as y`</u> `} from 'a'`.
 */
class ImportSpecifier extends Expr, @importspecifier {
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
}

/** A named import specifier. */
class NamedImportSpecifier extends ImportSpecifier, @namedimportspecifier { }

/** A default import specifier. */
class ImportDefaultSpecifier extends ImportSpecifier, @importdefaultspecifier {
  override string getImportedName() { result = "default" }
}

/** A namespace import specifier. */
class ImportNamespaceSpecifier extends ImportSpecifier, @importnamespacespecifier { }

/** A bulk import that imports an entire module as a namespace. */
class BulkImportDeclaration extends ImportDeclaration {
  BulkImportDeclaration() { getASpecifier() instanceof ImportNamespaceSpecifier }

  /** Gets the local namespace variable under which the module is imported. */
  VarDecl getLocal() { result = getASpecifier().getLocal() }
}

/** A selective import that imports zero or more declarations. */
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
 * There are three kinds of export declarations:
 *
 *   - a bulk re-export declaration of the form `export * from 'a'`, which re-exports
 *     all exports of another module;
 *   - a default export declaration of the form `export default var x = 42`, which exports
 *     a local value or declaration as the default export;
 *   - a named export declaration such as `export { x, y as z }`, which exports local
 *     values or declarations under specific names; a named export declaration
 *     may also export symbols itself imported from another module, as in
 *     `export { x } from 'a'`.
 */
abstract class ExportDeclaration extends Stmt, @exportdeclaration {
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
}

/**
 * A bulk re-export declaration of the form `export * from 'a'`, which re-exports
 * all exports of another module.
 */
class BulkReExportDeclaration extends ReExportDeclaration, @exportalldeclaration {
  /** Gets the name of the module from which this declaration re-exports. */
  override ConstantString getImportedPath() { result = getChildExpr(0) }

  override predicate exportsAs(LexicalName v, string name) {
    getImportedModule().exportsAs(v, name) and
    not isShadowedFromBulkExport(this, name)
  }

  override DataFlow::Node getSourceNode(string name) {
    result = getImportedModule().getAnExport().getSourceNode(name)
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
 * A default export declaration such as `export default function f{}`
 * or `export default { x: 42 }`.
 */
class ExportDefaultDeclaration extends ExportDeclaration, @exportdefaultdeclaration {
  /** Gets the operand statement or expression that is exported by this declaration. */
  ExprOrStmt getOperand() { result = getChild(0) }

  override predicate exportsAs(LexicalName v, string name) {
    name = "default" and v = getADecl().getVariable()
  }

  /** Gets the declaration, if any, exported by this default export. */
  VarDecl getADecl() {
    exists(ExprOrStmt op | op = getOperand() |
      result = op.(FunctionDeclStmt).getId() or
      result = op.(ClassDeclStmt).getIdentifier()
    )
  }

  override DataFlow::Node getSourceNode(string name) {
    name = "default" and result = DataFlow::valueNode(getOperand())
  }
}

/** A named export declaration such as `export { x, y }` or `export var x = 42`. */
class ExportNamedDeclaration extends ExportDeclaration, @exportnameddeclaration {
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
      result = op.(FunctionDeclStmt).getId() or
      result = op.(ClassDeclStmt).getIdentifier() or
      result = op.(NamespaceDeclaration).getId() or
      result = op.(EnumDeclaration).getIdentifier() or
      result = op.(InterfaceDeclaration).getIdentifier() or
      result = op.(TypeAliasDeclaration).getIdentifier() or
      result = op.(ImportEqualsDeclaration).getId()
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
      this.(ReExportDeclaration).getImportedModule().exportsAs(v, spec.getLocalName())
    )
  }

  override DataFlow::Node getSourceNode(string name) {
    exists(VarDef d | d.getTarget() = getADecl() |
      name = d.getTarget().(VarDecl).getName() and
      result = DataFlow::valueNode(d.getSource())
    )
    or
    exists(ExportSpecifier spec | spec = getASpecifier() and name = spec.getExportedName() |
      not exists(getImportedPath()) and result = DataFlow::valueNode(spec.getLocal())
      or
      exists(ReExportDeclaration red | red = this |
        result = red.getImportedModule().getAnExport().getSourceNode(spec.getLocalName())
      )
    )
  }

  /** Gets the module from which the exports are taken if this is a re-export. */
  ConstantString getImportedPath() { result = getChildExpr(-2) }

  /** Gets the `i`th export specifier of this declaration. */
  ExportSpecifier getSpecifier(int i) { result = getChildExpr(i) }

  /** Gets an export specifier of this declaration. */
  ExportSpecifier getASpecifier() { result = getSpecifier(_) }

  override predicate isAmbient() {
    // An export such as `export declare function f()` should be seen as ambient.
    hasDeclareKeyword(getOperand()) or getParent().isAmbient()
  }
}

/** An export specifier in a named export declaration. */
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
}

/**
 * A named export specifier, for example `v` in `export { v }`.
 */
class NamedExportSpecifier extends ExportSpecifier, @namedexportspecifier { }

/**
 * A default export specifier, for example `default` in `export default 42`,
 * or `v` in `export v from "mod"`.
 */
class ExportDefaultSpecifier extends ExportSpecifier, @exportdefaultspecifier {
  override string getExportedName() { result = "default" }
}

/**
 * A default export specifier in a re-export declaration, for example `v` in
 * `export v from "mod"`.
 */
class ReExportDefaultSpecifier extends ExportDefaultSpecifier {
  ReExportDefaultSpecifier() { getExportDeclaration() instanceof ReExportDeclaration }

  override string getLocalName() { result = "default" }

  override string getExportedName() { result = getExported().getName() }
}

/**
 * A namespace export specifier, for example `*` in `export * from "mod"`.
 */
class ExportNamespaceSpecifier extends ExportSpecifier, @exportnamespacespecifier { }

/** An export declaration that re-exports declarations from another module. */
abstract class ReExportDeclaration extends ExportDeclaration {
  /** Gets the path of the module from which this declaration re-exports. */
  abstract ConstantString getImportedPath();

  /** Gets the module from which this declaration re-exports. */
  ES2015Module getImportedModule() {
    result.getFile() = getEnclosingModule().resolve(getImportedPath().(PathExpr))
    or
    result = resolveFromTypeRoot()
  }

  /**
   * Gets a module in a `node_modules/@types/` folder that matches the imported module name.
   */
  private Module resolveFromTypeRoot() {
    result.getFile() = min(TypeRootFolder typeRoot |
        |
        typeRoot.getModuleFile(getImportedPath().getStringValue())
        order by
          typeRoot.getSearchPriority(getFile().getParentContainer())
      )
  }
}

/** A literal path expression appearing in a re-export declaration. */
private class LiteralReExportPath extends PathExprInModule, ConstantString {
  LiteralReExportPath() { exists(ReExportDeclaration bred | this = bred.getImportedPath()) }

  override string getValue() { result = this.(ConstantString).getStringValue() }
}

/** A named export declaration that re-exports symbols imported from another module. */
class SelectiveReExportDeclaration extends ReExportDeclaration, ExportNamedDeclaration {
  SelectiveReExportDeclaration() { exists(ExportNamedDeclaration.super.getImportedPath()) }

  /** Gets the path of the module from which this declaration re-exports. */
  override ConstantString getImportedPath() {
    result = ExportNamedDeclaration.super.getImportedPath()
  }
}

/** An export declaration that exports zero or more declarations from the module it appears in. */
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
