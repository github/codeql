overlay[local?]
module;

import minimal

/**
 * A statement that defines a namespace, that is, a namespace declaration or enum declaration.
 *
 * Declarations that declare an alias for a namespace (i.e. an import) are not
 * considered to be namespace definitions.
 */
class NamespaceDefinition extends Stmt, @namespace_definition, AST::ValueNode {
  /**
   * Gets the identifier naming the namespace.
   */
  Identifier getIdentifier() { none() } // Overridden in subtypes.

  /**
   * Gets unqualified name of the namespace being defined.
   */
  string getName() {
    result = this.(NamespaceDeclaration).getName()
    or
    result = this.(EnumDeclaration).getName()
  }

  /**
   * Gets the local namespace name induced by this namespace.
   */
  LocalNamespaceName getLocalNamespaceName() {
    result = this.getIdentifier().(LocalNamespaceDecl).getLocalNamespaceName()
  }
}

/**
 * A TypeScript namespace declaration.
 *
 * This is also known as an "internal module" and can be declared
 * using the `module` or `namespace` keyword. For example:
 * ```
 * namespace util { ... }
 * module util { ... } // equivalent
 * ```
 *
 * Note that modules whose name is a string literal, called "external modules",
 * and are not namespace declarations.
 * For example, `declare module "X" {...}` is an external module declaration.
 * These are represented by `ExternalModuleDeclaration`.
 */
class NamespaceDeclaration extends NamespaceDefinition, StmtContainer, @namespace_declaration {
  /** Gets the name of this namespace. */
  override Identifier getIdentifier() { result = this.getChildExpr(-1) }

  /** Gets the name of this namespace as a string. */
  override string getName() { result = this.getIdentifier().getName() }

  /** Gets the `i`th statement in this namespace. */
  Stmt getStmt(int i) {
    i >= 0 and
    result = this.getChildStmt(i)
  }

  /** Gets a statement in this namespace. */
  override Stmt getAStmt() { result = this.getStmt(_) }

  /** Gets the number of statements in this namespace. */
  int getNumStmt() { result = count(this.getAStmt()) }

  override StmtContainer getEnclosingContainer() { result = this.getContainer() }

  /**
   * Holds if this declaration implies the existence of a concrete namespace object at runtime.
   *
   * A namespace that is empty or only contains interfaces and type aliases is not instantiated,
   * and thus has no namespace object at runtime and is not associated with a variable.
   */
  predicate isInstantiated() { is_instantiated(this) }

  override ControlFlowNode getFirstControlFlowNode() {
    if has_declare_keyword(this) then result = this else result = this.getIdentifier()
  }

  override string getAPrimaryQlClass() { result = "NamespaceDeclaration" }
}

/**
 * A statement that defines a named type, that is, a class, interface, type alias, or enum declaration.
 *
 * Note that imports and type parameters are not type definitions.  Consider using `TypeDecl` to capture
 * a wider class of type declarations.
 */
class TypeDefinition extends AstNode, @type_definition {
  /**
   * Gets the identifier naming the type.
   */
  Identifier getIdentifier() {
    result = this.(ClassDefinition).getIdentifier() or
    result = this.(InterfaceDeclaration).getIdentifier() or
    result = this.(TypeAliasDeclaration).getIdentifier() or
    result = this.(EnumDeclaration).getIdentifier() or
    result = this.(EnumMember).getIdentifier()
  }

  /**
   * Gets the unqualified name of the type being defined.
   */
  string getName() { result = this.getIdentifier().getName() }

  override string getAPrimaryQlClass() { result = "TypeDefinition" }
}

/**
 * A TypeScript declaration of form `declare module "X" {...}` where `X`
 * is the name of an external module.
 */
class ExternalModuleDeclaration extends Stmt, StmtContainer, @external_module_declaration {
  /**
   * Gets the string literal denoting the module name, such as `"fs"` in:
   * ```
   * declare module "fs" {...}
   * ```
   */
  StringLiteral getNameLiteral() { result = this.getChildExpr(-1) }

  /**
   * Gets the module name, such as `fs` in:
   * ```
   * declare module "fs" {...}
   * ```
   */
  string getName() { result = this.getNameLiteral().getStringValue() }

  /** Gets the `i`th statement in this namespace. */
  Stmt getStmt(int i) {
    i >= 0 and
    result = this.getChildStmt(i)
  }

  /** Gets a statement in this namespace. */
  override Stmt getAStmt() { result = this.getStmt(_) }

  /** Gets the number of statements in this namespace. */
  int getNumStmt() { result = count(this.getAStmt()) }

  override StmtContainer getEnclosingContainer() { result = this.getContainer() }

  override string getAPrimaryQlClass() { result = "ExternalModuleDeclaration" }
}

/**
 * A TypeScript declaration of form `declare global {...}`.
 */
class GlobalAugmentationDeclaration extends Stmt, StmtContainer, @global_augmentation_declaration {
  /** Gets the `i`th statement in this namespace. */
  Stmt getStmt(int i) {
    i >= 0 and
    result = this.getChildStmt(i)
  }

  /** Gets a statement in this namespace. */
  override Stmt getAStmt() { result = this.getStmt(_) }

  /** Gets the number of statements in this namespace. */
  int getNumStmt() { result = count(this.getAStmt()) }

  override StmtContainer getEnclosingContainer() { result = this.getContainer() }

  override string getAPrimaryQlClass() { result = "GlobalAugmentationDeclaration" }
}

/** A TypeScript "import-equals" declaration. */
class ImportEqualsDeclaration extends Stmt, @import_equals_declaration {
  /** Gets the name under which the imported entity is imported. */
  Identifier getIdentifier() { result = this.getChildExpr(0) }

  /** Gets the expression specifying the imported module or entity. */
  Expr getImportedEntity() { result = this.getChildExpr(1) }

  override ControlFlowNode getFirstControlFlowNode() { result = this.getIdentifier() }

  override string getAPrimaryQlClass() { result = "ImportEqualsDeclaration" }
}

/**
 * A `require()` call in a TypeScript import-equals declaration, such as `require("foo")` in:
 * ```
 * import foo = require("foo");
 * ```
 *
 * These are special in that they may only occur in an import-equals declaration,
 * and the compiled output depends on the `--module` flag passed to the
 * TypeScript compiler.
 */
class ExternalModuleReference extends Expr, @external_module_reference {
  /** Gets the expression specifying the module. */
  Expr getExpression() { result = this.getChildExpr(0) }

  Expr getImportedPathExpr() { result = this.getExpression() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getExpression().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "ExternalModuleReference" }
}

/** A TypeScript "export-assign" declaration. */
class ExportAssignDeclaration extends Stmt, @export_assign_declaration {
  /** Gets the expression exported by this declaration. */
  Expr getExpression() { result = this.getChildExpr(0) }

  override string getAPrimaryQlClass() { result = "ExportAssignDeclaration" }
}

/** A TypeScript export of form `export as namespace X` where `X` is an identifier. */
class ExportAsNamespaceDeclaration extends Stmt, @export_as_namespace_declaration {
  /**
   * Gets the `X` in `export as namespace X`.
   */
  Identifier getIdentifier() { result = this.getChildExpr(0) }

  override string getAPrimaryQlClass() { result = "ExportAsNamespaceDeclaration" }
}

/**
 * A type alias declaration, that is, a statement of form `type A = T`.
 */
class TypeAliasDeclaration extends @type_alias_declaration, TypeParameterized, Stmt {
  /** Gets the name of this type alias as a string. */
  string getName() { result = this.getIdentifier().getName() }

  Identifier getIdentifier() { result = this.getChildTypeExpr(0) }

  override TypeParameter getTypeParameter(int n) { result = this.getChildTypeExpr(n + 2) }

  /**
   * Gets the `T` in `type A = T`.
   */
  TypeExpr getDefinition() { result = this.getChildTypeExpr(1) }

  override string describe() { result = "type alias " + this.getName() }

  override string getAPrimaryQlClass() { result = "TypeAliasDeclaration" }
}

/**
 * A TypeScript interface declaration, inline interface type, or function type.
 */
class InterfaceDefinition extends @interface_definition, ClassOrInterface {
  override predicate isAbstract() { any() }

  override string getAPrimaryQlClass() { result = "InterfaceDefinition" }
}

/** A TypeScript interface declaration. */
class InterfaceDeclaration extends Stmt, InterfaceDefinition, @interface_declaration {
  override Identifier getIdentifier() { result = this.getChildTypeExpr(0) }

  override TypeParameter getTypeParameter(int n) {
    exists(int astIndex | typeexprs(result, _, this, astIndex, _) |
      astIndex <= -2 and astIndex % 2 = 0 and n = -(astIndex + 2) / 2
    )
  }

  override string describe() { result = "interface " + this.getName() }

  /**
   * Gets the `n`th type from the `extends` clause of this interface, starting at 0.
   */
  override TypeExpr getSuperInterface(int n) {
    exists(int astIndex | typeexprs(result, _, this, astIndex, _) |
      astIndex <= -1 and astIndex % 2 = -1 and n = -(astIndex + 1) / 2
    )
  }

  /**
   * Gets any type from the `extends` clause of this interface.
   */
  override TypeExpr getASuperInterface() { result = InterfaceDefinition.super.getASuperInterface() }

  override string getAPrimaryQlClass() { result = "InterfaceDeclaration" }
}

/** An inline TypeScript interface type, such as `{x: number; y: number}`. */
class InterfaceTypeExpr extends TypeExpr, InterfaceDefinition, @interface_typeexpr {
  override Identifier getIdentifier() { none() }

  override string describe() { result = "anonymous interface" }

  override string getAPrimaryQlClass() { result = "InterfaceTypeExpr" }
}

/**
 * A TypeScript function type, such as `(x: string) => number` or a
 * constructor type such as `new (x: string) => Object`.
 */
class FunctionTypeExpr extends TypeExpr, @function_typeexpr {
  /** Holds if this is a constructor type, such as `new (x: string) => Object`. */
  predicate isConstructor() { this instanceof ConstructorTypeExpr }

  /** Gets the function AST node that holds the parameters and return type. */
  FunctionExpr getFunction() { result = this.getChildExpr(0) }

  /** Gets the `n`th parameter of this function type. */
  Parameter getParameter(int n) { result = this.getFunction().getParameter(n) }

  /** Gets any of the parameters of this function type. */
  Parameter getAParameter() { result = this.getFunction().getAParameter() }

  /** Gets the number of parameters of this function type. */
  int getNumParameter() { result = this.getFunction().getNumParameter() }

  /** Gets the `n`th type parameter of this function type. */
  TypeParameter getTypeParameter(int n) { result = this.getFunction().getTypeParameter(n) }

  /** Gets any of the type parameters of this function type. */
  TypeParameter getATypeParameter() { result = this.getFunction().getATypeParameter() }

  /** Gets the number of type parameters of this function type. */
  int getNumTypeParameter() { result = this.getFunction().getNumTypeParameter() }

  /** Gets the return type of this function type, if any. */
  TypeExpr getReturnTypeAnnotation() { result = this.getFunction().getReturnTypeAnnotation() }

  override string getAPrimaryQlClass() { result = "FunctionTypeExpr" }
}

/** A constructor type, such as `new (x: string) => Object`. */
class ConstructorTypeExpr extends FunctionTypeExpr, @constructor_typeexpr { }

/** A function type that is not a constructor type, such as `(x: string) => number`. */
class PlainFunctionTypeExpr extends FunctionTypeExpr, @plain_function_typeexpr { }

/** A possibly qualified identifier that declares or refers to a type. */
abstract class TypeRef extends AstNode { }

/** An identifier declaring a type name, that is, the name of a class, interface, type parameter, or import. */
class TypeDecl extends Identifier, TypeRef, LexicalDecl {
  TypeDecl() {
    this = any(ClassOrInterface ci).getIdentifier() or
    this = any(TypeParameter tp).getIdentifier() or
    this = any(ImportSpecifier im).getLocal() or
    this = any(ImportEqualsDeclaration im).getIdentifier() or
    this = any(TypeAliasDeclaration td).getIdentifier() or
    this = any(EnumDeclaration ed).getIdentifier() or
    this = any(EnumMember member).getIdentifier()
  }

  /**
   * Gets the local type name being declared.
   *
   * If this is an import or type alias, the local type name represents the local alias.
   */
  LocalTypeName getLocalTypeName() { result.getADeclaration() = this }

  /**
   * Gets a string describing the type being declared, consisting of the declaration kind and
   * the name being declared, such as `class C` for a class declaration `C`.
   */
  string describe() {
    exists(ClassOrInterface ci | this = ci.getIdentifier() | result = ci.describe())
    or
    exists(TypeParameter tp | this = tp.getIdentifier() |
      result = "type parameter " + this.getName()
    )
    or
    exists(TypeAliasDeclaration td | this = td.getIdentifier() |
      result = "type alias " + this.getName()
    )
    or
    exists(EnumDeclaration enum | this = enum.getIdentifier() | result = "enum " + this.getName())
    or
    exists(EnumMember member | this = member.getIdentifier() |
      result = "enum member " + member.getPrefixedName()
    )
    or
    exists(ImportSpecifier im | this = im.getLocal() | result = "imported type " + this.getName())
  }
}

/**
 * The local name for a type in a particular scope.
 *
 * It is possible for two distinct local type names to refer to the same underlying
 * type through imports or type aliases. For example:
 * ```
 * namespace A {
 *   export class C {}
 * }
 * namespace B {
 *   import C = A.C;
 * }
 * ```
 * In the above example, two distinct local type names exist for the type `C`:
 * one in `A` and one in `B`.
 * Since a local type name is always specific to one scope, it is not possible
 * for the two namespaces to share a single local type name for `C`.
 *
 * There may be multiple declarations of a given local type name, for example:
 * ```
 * interface Point { x: number; }
 * interface Point { y: number; }
 * ```
 * In the above example, the two declarations of `Point` refer to the same
 * local type name.
 */
class LocalTypeName extends @local_type_name, LexicalName {
  /** Gets the local name of this type. */
  override string getName() { local_type_names(this, result, _) }

  /** Gets the scope this type name is declared in. */
  override Scope getScope() { local_type_names(this, _, result) }

  /** Gets a textual representation of this element. */
  override string toString() { result = this.getName() }

  /**
   * Gets a declaration of this type name.
   *
   * All local type names have at least one declaration and may have
   * multiple declarations in case these are interface declarations.
   */
  TypeDecl getADeclaration() { typedecl(result, this) }

  /**
   * Gets the first declaration of this type name.
   */
  TypeDecl getFirstDeclaration() {
    result =
      min(this.getADeclaration() as decl
        order by
          decl.getLocation().getStartLine(), decl.getLocation().getStartColumn()
      )
  }

  /** Gets a use of this type name in a type annotation. */
  LocalTypeAccess getATypeAccess() { typebind(result, this) }

  /** Gets a use of this type name in an export. */
  ExportVarAccess getAnExportAccess() { typebind(result, this) }

  /** Gets an identifier that refers to this type name. */
  Identifier getAnAccess() { typebind(result, this) }

  override DeclarationSpace getDeclarationSpace() { result = "type" }
}

/**
 * The local name for a namespace in a particular scope.
 *
 * Namespace declarations and imports can give rise to local namespace names.
 * For example, the following declarations declare two local namespace names,
 * `A` and `B`:
 * ```
 * import A from './A';
 * namespace B {}
 * ```
 *
 * It is possible for a namespace to have multiple aliases; each alias corresponds
 * to a distinct local namespace name. For example, there are three distinct local
 * namespace names for `A` in this example:
 * ```
 * namespace A {}
 * namespace Q {
 *   import B = A;
 *   import C = A;
 * }
 * ```
 * There is one local namespace name for the declaration of `A` and one for each import.
 */
class LocalNamespaceName extends @local_namespace_name, LexicalName {
  /** Gets the local name of this namespace. */
  override string getName() { local_namespace_names(this, result, _) }

  /** Gets the scope this namespace name is declared in. */
  override Scope getScope() { local_namespace_names(this, _, result) }

  /** Gets a textual representation of this element. */
  override string toString() { result = this.getName() }

  /**
   * Gets a declaration of this namespace name.
   *
   * All local namespace names have at least one declaration and may have
   * multiple declarations unless it comes from an import.
   */
  LocalNamespaceDecl getADeclaration() { namespacedecl(result, this) }

  /**
   * Gets the first declaration of this namespace name.
   */
  LocalNamespaceDecl getFirstDeclaration() {
    result =
      min(this.getADeclaration() as decl
        order by
          decl.getLocation().getStartLine(), decl.getLocation().getStartColumn()
      )
  }

  /** Gets a use of this namespace name in a type annotation. */
  LocalNamespaceAccess getATypeAccess() { namespacebind(result, this) }

  /** Gets a use of this namespace in an export. */
  ExportVarAccess getAnExportAccess() { namespacebind(result, this) }

  /**
   * Gets an access to a type member of this namespace alias,
   * such as `http.ServerRequest` where `http` is a reference to this namespace.
   */
  QualifiedTypeAccess getAMemberAccess(string member) {
    result.getIdentifier().getName() = member and
    result.getQualifier() = this.getAnAccess()
  }

  /** Gets an identifier that refers to this namespace name. */
  Identifier getAnAccess() { namespacebind(result, this) }

  override DeclarationSpace getDeclarationSpace() { result = "namespace" }
}

/**
 * A type expression, that is, an AST node that is part of a TypeScript type annotation.
 *
 * This class includes only explicit type annotations -
 * types inferred by the TypeScript compiler are not type expressions.
 */
class TypeExpr extends ExprOrType, @typeexpr, TypeAnnotation {
  override string toString() { typeexprs(this, _, _, _, result) }

  override Stmt getEnclosingStmt() { result = ExprOrType.super.getEnclosingStmt() }

  override Function getEnclosingFunction() { result = ExprOrType.super.getEnclosingFunction() }

  override TopLevel getTopLevel() { result = ExprOrType.super.getTopLevel() }
}

/**
 * Classes that are internally represented as a keyword type.
 */
private class KeywordTypeExpr extends @keyword_typeexpr, TypeExpr {
  string getName() { literals(result, _, this) }

  override predicate isAny() { this.getName() = "any" }

  override predicate isString() { this.getName() = "string" }

  override predicate isStringy() { this.getName() = "string" }

  override predicate isNumber() { this.getName() = "number" }

  override predicate isNumbery() { this.getName() = "number" }

  override predicate isBoolean() { this.getName() = "boolean" }

  override predicate isBooleany() { this.getName() = "boolean" }

  override predicate isUndefined() { this.getName() = "undefined" }

  override predicate isNull() { this.getName() = "null" }

  override predicate isVoid() { this.getName() = "void" }

  override predicate isNever() { this.getName() = "never" }

  override predicate isThis() { this.getName() = "this" }

  override predicate isSymbol() { this.getName() = "symbol" }

  override predicate isUniqueSymbol() { this.getName() = "unique symbol" }

  override predicate isObjectKeyword() { this.getName() = "object" }

  override predicate isUnknownKeyword() { this.getName() = "unknown" }

  override predicate isBigInt() { this.getName() = "bigint" }

  override predicate isConstKeyword() { this.getName() = "const" }

  override string getAPrimaryQlClass() { result = "KeywordTypeExpr" }
}

/**
 * A use of the predefined type `any`, `string`, `number`, `boolean`, `null`, `undefined`, `void`, `never`, `symbol`, or `object`.
 */
class PredefinedTypeExpr extends KeywordTypeExpr {
  PredefinedTypeExpr() {
    not this.isThis() // The only keyword type that we don't consider a "predefined" type
  }
}

/**
 * A use of the `this` type.
 */
class ThisTypeExpr extends KeywordTypeExpr {
  ThisTypeExpr() { this.isThis() }
}

/**
 * A possibly qualified name that is used as part of a type, such as `Date` or `http.ServerRequest`.
 *
 * Type arguments are not part of a type access but there are convenience methods in this class
 * for accessing them.
 */
class TypeAccess extends @typeaccess, TypeExpr, TypeRef {
  /** Gets the identifier naming the type without any qualifier, such as `ServerRequest` in `http.ServerRequest`. */
  Identifier getIdentifier() { none() }

  /**
   * Gets the enclosing generic type expression providing type arguments to this type, if any.
   *
   * For example, in `Array<number>`, the `Array` part is a type access with `Array<number>`
   * being its enclosing generic type.
   */
  GenericTypeExpr getAsGenericType() { result.getTypeAccess() = this }

  /**
   * Holds if there are type arguments provided to this type by an enclosing generic type expression.
   *
   * For example, in `Array<number>`, the `Array` part is a type access having type arguments.
   */
  predicate hasTypeArguments() { exists(this.getAsGenericType()) }

  /**
   * Gets the `n`th type argument provided to this type by the enclosing generic type expression, if any.
   *
   * For example, in `Array<number>`, the `Array` part is a type access having the type argument `number`.
   */
  TypeExpr getTypeArgument(int n) { result = this.getAsGenericType().getTypeArgument(n) }

  /**
   * Gets a type argument provided to this type by the enclosing generic type expression, if any.
   *
   * For example, in `Array<number>`, the `Array` part is a type access having the type argument `number`.
   */
  TypeExpr getATypeArgument() { result = this.getAsGenericType().getATypeArgument() }

  /**
   * Gets the number of type arguments provided to this type by the enclosing generic type expression,
   * if any, or 0 otherwise.
   *
   * For example, in `Array<number>`, the `Array` part is a type access having 1 type argument.
   */
  int getNumTypeArgument() {
    if exists(this.getAsGenericType())
    then result = this.getAsGenericType().getNumTypeArgument()
    else result = 0
  }

  override string getAPrimaryQlClass() { result = "TypeAccess" }
}

/** An identifier that is used as part of a type, such as `Date`. */
class LocalTypeAccess extends @local_type_access, TypeAccess, Identifier, LexicalAccess {
  override predicate isStringy() { this.getName() = "String" }

  override predicate isNumbery() { this.getName() = "Number" }

  override predicate isBooleany() { this.getName() = "Boolean" }

  override predicate isRawFunction() { this.getName() = "Function" }

  override Identifier getIdentifier() { result = this }

  /**
   * Gets the local type name being referenced by this identifier, if any.
   *
   * Names that refer to a declaration in an external `d.ts` file, such as in
   * the built-in `lib.d.ts` prelude, do not have a local typename.
   *
   * For example, in `Array<number>`, the `Array` name will usually not have
   * a local type name as it is declared in `lib.d.ts`.
   */
  LocalTypeName getLocalTypeName() { result.getAnAccess() = this }

  private TypeAliasDeclaration getAlias() {
    this.getLocalTypeName().getADeclaration() = result.getIdentifier()
  }

  override TypeExpr getAnUnderlyingType() {
    result = this.getAlias().getDefinition().getAnUnderlyingType()
    or
    not exists(this.getAlias()) and
    result = this
  }

  override string getAPrimaryQlClass() { result = "LocalTypeAccess" }
}

/**
 * A qualified name that is used as part of a type, such as `http.ServerRequest`.
 */
class QualifiedTypeAccess extends @qualified_type_access, TypeAccess {
  /**
   * Gets the qualifier in front of the name, such as `http` in `http.ServerRequest`.
   *
   * If the prefix consists of multiple identifiers, the qualifier is itself a qualified namespace access.
   * For example, the qualifier of `lib.util.List` is `lib.util`.
   */
  NamespaceAccess getQualifier() { result = this.getChildTypeExpr(0) }

  /** Gets the last identifier in the name, such as `ServerRequest` in `http.ServerRequest`. */
  override Identifier getIdentifier() { result = this.getChildTypeExpr(1) }
}

/**
 * A type consisting of a name and at least one type argument, such as `Array<number>`.
 *
 * For convenience, the methods for accessing type arguments are also made available
 * on the `TypeAccess` class.
 */
class GenericTypeExpr extends @generic_typeexpr, TypeExpr {
  /** Gets the name of the type, such as `Array` in `Array<number>`. */
  TypeAccess getTypeAccess() { result = this.getChildTypeExpr(-1) }

  /** Gets the `n`th type argument, starting at 0. */
  TypeExpr getTypeArgument(int n) { result = this.getChildTypeExpr(n) and n >= 0 }

  /** Gets any of the type arguments. */
  TypeExpr getATypeArgument() { result = this.getTypeArgument(_) }

  /** Gets the number of type arguments. This is always at least one. */
  int getNumTypeArgument() { result = count(this.getATypeArgument()) }

  override string getAPrimaryQlClass() { result = "GenericTypeExpr" }
}

/**
 * A string, number, or boolean literal used as a type.
 *
 * Note that the `null` and `undefined` types are considered predefined types, not literal types.
 */
class LiteralTypeExpr extends @literal_typeexpr, TypeExpr {
  /** Gets the value of this literal, as a string. */
  string getValue() { literals(result, _, this) }

  /**
   * Gets the raw source text of this literal, including quotes for
   * string literals.
   */
  string getRawValue() { literals(_, result, this) }

  override string getAPrimaryQlClass() { result = "LiteralTypeExpr" }
}

/** A string literal used as a type. */
class StringLiteralTypeExpr extends @string_literal_typeexpr, LiteralTypeExpr { }

/** A number literal used as a type. */
class NumberLiteralTypeExpr extends @number_literal_typeexpr, LiteralTypeExpr {
  /** Gets the integer value of this literal type. */
  int getIntValue() { result = this.getValue().toInt() }
}

/** A boolean literal used as a type. */
class BooleanLiteralTypeExpr extends @boolean_literal_typeexpr, LiteralTypeExpr {
  predicate isTrue() { this.getValue() = "true" }

  predicate isFalse() { this.getValue() = "false" }
}

/** A bigint literal used as a TypeScript type annotation. */
class BigIntLiteralTypeExpr extends @bigint_literal_typeexpr, LiteralTypeExpr {
  /** Gets the integer value of the bigint literal, if it can be represented as a QL integer. */
  int getIntValue() { result = this.getValue().toInt() }

  /**
   * Gets the floating point value of this literal if it can be represented
   * as a QL floating point value.
   */
  float getFloatValue() { result = this.getValue().toFloat() }
}

/**
 * An array type, such as `number[]`, or in general `T[]` where `T` is a type.
 *
 * This class includes only type expressions that use the notation `T[]`.
 * Named types such as `Array<number>` and tuple types such as `[number, string]`
 * are not array type expressions.
 */
class ArrayTypeExpr extends @array_typeexpr, TypeExpr {
  /** Gets the type of the array elements. */
  TypeExpr getElementType() { result = this.getChildTypeExpr(0) }

  override string getAPrimaryQlClass() { result = "ArrayTypeExpr" }
}

private class RawUnionOrIntersectionTypeExpr = @union_typeexpr or @intersection_typeexpr;

/**
 * A union or intersection type, such as `string|number|boolean` or `A & B`.
 */
class UnionOrIntersectionTypeExpr extends RawUnionOrIntersectionTypeExpr, TypeExpr {
  /** Gets the `n`th type in the union or intersection, starting at 0. */
  TypeExpr getElementType(int n) { result = this.getChildTypeExpr(n) }

  /** Gets any of the types in the union or intersection. */
  TypeExpr getAnElementType() { result = this.getElementType(_) }

  /** Gets the number of types in the union or intersection. This is always at least two. */
  int getNumElementType() { result = count(this.getAnElementType()) }

  override TypeExpr getAnUnderlyingType() { result = this.getAnElementType().getAnUnderlyingType() }
}

/**
 * A union type, such as `string|number|boolean`.
 */
class UnionTypeExpr extends @union_typeexpr, UnionOrIntersectionTypeExpr {
  override string getAPrimaryQlClass() { result = "UnionTypeExpr" }
}

/**
 * A type of form `T[K]` where `T` and `K` are types.
 */
class IndexedAccessTypeExpr extends @indexed_access_typeexpr, TypeExpr {
  /** Gets the type `T` in `T[K]`, denoting the object type whose properties are to be extracted. */
  TypeExpr getObjectType() { result = this.getChildTypeExpr(0) }

  /** Gets the type `K` in `T[K]`, denoting the property names to extract from the object type. */
  TypeExpr getIndexType() { result = this.getChildTypeExpr(1) }

  override string getAPrimaryQlClass() { result = "IndexedAccessTypeExpr" }
}

/**
 * A type of form `S&T`, denoting the intersection of type `S` and type `T`.
 *
 * In general, there are can more than two operands to an intersection type.
 */
class IntersectionTypeExpr extends @intersection_typeexpr, UnionOrIntersectionTypeExpr {
  override string getAPrimaryQlClass() { result = "IntersectionTypeExpr" }
}

/**
 * A type expression enclosed in parentheses.
 */
class ParenthesizedTypeExpr extends @parenthesized_typeexpr, TypeExpr {
  /** Gets the type inside the parentheses. */
  TypeExpr getElementType() { result = this.getChildTypeExpr(0) }

  override TypeExpr stripParens() { result = this.getElementType().stripParens() }

  override TypeExpr getAnUnderlyingType() { result = this.getElementType().getAnUnderlyingType() }

  override string getAPrimaryQlClass() { result = "ParenthesizedTypeExpr" }
}

/**
 * A tuple type such as `[number, string]`.
 */
class TupleTypeExpr extends @tuple_typeexpr, TypeExpr {
  /** Gets the `n`th element type in the tuple, starting at 0. */
  TypeExpr getElementType(int n) { result = this.getChildTypeExpr(n) and n >= 0 }

  /** Gets any of the element types in the tuple. */
  TypeExpr getAnElementType() { result = this.getElementType(_) }

  /** Gets the number of elements in the tuple type. */
  int getNumElementType() { result = count(this.getAnElementType()) }

  /**
   * Gets the name of the `n`th tuple member, starting at 0.
   * Only has a result if the tuple members are named.
   */
  Identifier getElementName(int n) {
    // Type element names are at indices -1, -2, -3, ...
    result = this.getChild(-(n + 1)) and n >= 0
  }

  override string getAPrimaryQlClass() { result = "TupleTypeExpr" }
}

/**
 * A type of form `keyof T` where `T` is a type.
 */
class KeyofTypeExpr extends @keyof_typeexpr, TypeExpr {
  /** Gets the type `T` in `keyof T`, denoting the object type whose property names are to be extracted. */
  TypeExpr getElementType() { result = this.getChildTypeExpr(0) }

  override string getAPrimaryQlClass() { result = "KeyofTypeExpr" }
}

/**
 * A type of form `{ [K in C]: T }` where `K in C` declares a type parameter with `C`
 * as the bound, and `T` is a type that may refer to `K`.
 */
class MappedTypeExpr extends @mapped_typeexpr, TypeParameterized, TypeExpr {
  /**
   * Gets the `K in C` part from `{ [K in C]: T }`.
   */
  TypeParameter getTypeParameter() { result = this.getChildTypeExpr(0) }

  override TypeParameter getTypeParameter(int n) { n = 0 and result = this.getTypeParameter() }

  /**
   * Gets the `T` part from `{ [K in C]: T }`.
   */
  TypeExpr getElementType() { result = this.getChildTypeExpr(1) }

  override string describe() { result = "mapped type" }

  override string getAPrimaryQlClass() { result = "MappedTypeExpr" }
}

/**
 * A type of form `typeof E` where `E` is a possibly qualified name referring to a variable,
 * function, class, or namespace.
 */
class TypeofTypeExpr extends @typeof_typeexpr, TypeExpr {
  /**
   * Gets the `E` in `typeof E`, denoting the qualified the name of a
   * variable, function, class, or namespace whose type is to be extracted.
   */
  VarTypeAccess getExpressionName() { result = this.getChildTypeExpr(0) }

  override string getAPrimaryQlClass() { result = "TypeofTypeExpr" }
}

/**
 * A function return type that refines the type of one of its parameters or `this`.
 *
 * Examples:
 * ```js
 * function f(x): x is string {}
 * function f(x): asserts x is string {}
 * function f(x): asserts x {}
 * ```
 */
class PredicateTypeExpr extends @predicate_typeexpr, TypeExpr {
  /**
   * Gets the parameter name or `this` token `E` in `E is T`.
   */
  VarTypeAccess getParameterName() { result = this.getChildTypeExpr(0) }

  /**
   * Gets the type `T` in `E is T` or `asserts E is T`.
   *
   * Has no results for types of form `asserts E`.
   */
  TypeExpr getPredicateType() { result = this.getChildTypeExpr(1) }

  /**
   * Holds if this is a type of form `asserts E is T` or `asserts E`.
   */
  predicate hasAssertsKeyword() { has_asserts_keyword(this) }

  override string getAPrimaryQlClass() { result = "PredicateTypeExpr" }
}

/**
 * A function return type of form `x is T` or `asserts x is T`.
 *
 * Examples:
 * ```js
 * function f(x): x is string {}
 * function f(x): asserts x is string {}
 * ```
 */
class IsTypeExpr extends PredicateTypeExpr {
  IsTypeExpr() { exists(this.getPredicateType()) }

  override string getAPrimaryQlClass() { result = "IsTypeExpr" }
}

/**
 * An optional type element in a tuple type, such as `number?` in `[string, number?]`.
 */
class OptionalTypeExpr extends @optional_typeexpr, TypeExpr {
  /** Gets the type `T` in `T?` */
  TypeExpr getElementType() { result = this.getChildTypeExpr(0) }

  override TypeExpr getAnUnderlyingType() { result = this.getElementType().getAnUnderlyingType() }

  override string getAPrimaryQlClass() { result = "OptionalTypeExpr" }
}

/**
 * A rest element in a tuple type, such as `...string[]` in `[number, ...string[]]`.
 */
class RestTypeExpr extends @rest_typeexpr, TypeExpr {
  /** Gets the type `T[]` in `...T[]`, such as `string[]` in `[number, ...string[]]`. */
  TypeExpr getArrayType() { result = this.getChildTypeExpr(0) }

  /** Gets the type `T` in `...T[]`, such as `string` in `[number, ...string[]]`. */
  TypeExpr getElementType() { result = this.getArrayType().(ArrayTypeExpr).getElementType() }

  override string getAPrimaryQlClass() { result = "RestTypeExpr" }
}

/**
 * A type of form `readonly T`, such as `readonly number[]`.
 */
class ReadonlyTypeExpr extends @readonly_typeexpr, TypeExpr {
  /** Gets the type `T` in `readonly T`. */
  TypeExpr getElementType() { result = this.getChildTypeExpr(0) }

  override TypeExpr getAnUnderlyingType() { result = this.getElementType().getAnUnderlyingType() }

  override string getAPrimaryQlClass() { result = "ReadonlyTypeExpr" }
}

/**
 * A possibly qualified name that refers to a variable from inside a type.
 *
 * This can occur as
 * - part of the operand to a `typeof` type, or
 * - as the first operand to a predicate type
 *
 * For example, it may occur as the `E` in these examples:
 * ```
 * var x : typeof E
 * function f(...) : E is T {}
 * function f(...) : asserts E  {}
 * ```
 *
 * In the latter two cases, this may also refer to the pseudo-variable `this`.
 */
class VarTypeAccess extends @vartypeaccess, TypeExpr {
  override string getAPrimaryQlClass() { result = "VarTypeAccess" }
}

/**
 * An identifier that refers to a variable from inside a type.
 *
 * This can occur as part of the operand to a `typeof` type or as the first operand to an `is` type.
 */
class LocalVarTypeAccess extends @local_var_type_access, VarTypeAccess, LexicalAccess, Identifier {
  /** Gets the variable being referenced, or nothing if this is a `this` keyword. */
  Variable getVariable() { bind(this, result) }

  override string getAPrimaryQlClass() { result = "LocalVarTypeAccess" }
}

/**
 * A `this` keyword used as the first operand to an `is` type.
 *
 * For example, it may occur as the `this` in the following example:
 * ```
 * interface Node { isLeaf(): this is Leaf; }
 * ```
 */
class ThisVarTypeAccess extends @this_var_type_access, VarTypeAccess {
  override string getAPrimaryQlClass() { result = "ThisVarTypeAccess" }
}

/**
 * A qualified name that refers to a variable from inside a type.
 *
 * This can only occur as part of the operand to a `typeof` type.
 */
class QualifiedVarTypeAccess extends @qualified_var_type_access, VarTypeAccess {
  /**
   * Gets the qualifier in front of the name being accessed, such as `http` in `http.ServerRequest`.
   */
  VarTypeAccess getQualifier() { result = this.getChildTypeExpr(0) }

  /**
   * Gets the last identifier in the name, such as `ServerRequest` in `http.ServerRequest`.
   */
  Identifier getIdentifier() { result = this.getChildTypeExpr(1) }
}

/**
 * A conditional type annotation, such as `T extends any[] ? A : B`.
 */
class ConditionalTypeExpr extends @conditional_typeexpr, TypeExpr {
  /**
   * Gets the type to the left of the `extends` keyword, such as `T` in `T extends any[] ? A : B`.
   */
  TypeExpr getCheckType() { result = this.getChildTypeExpr(0) }

  /**
   * Gets the type to the right of the `extends` keyword, such as `any[]` in `T extends any[] ? A : B`.
   */
  TypeExpr getExtendsType() { result = this.getChildTypeExpr(1) }

  /**
   * Gets the type to be used if the `extend` condition holds, such as `A` in `T extends any[] ? A : B`.
   */
  TypeExpr getTrueType() { result = this.getChildTypeExpr(2) }

  /**
   * Gets the type to be used if the `extend` condition fails, such as `B` in `T extends any[] ? A : B`.
   */
  TypeExpr getFalseType() { result = this.getChildTypeExpr(3) }

  override string getAPrimaryQlClass() { result = "ConditionalTypeExpr" }
}

/**
 * A type annotation of form `infer R`.
 */
class InferTypeExpr extends @infer_typeexpr, TypeParameterized, TypeExpr {
  /**
   * Gets the type parameter capturing the matched type, such as `R` in `infer R`.
   */
  TypeParameter getTypeParameter() { result = this.getChildTypeExpr(0) }

  override TypeParameter getTypeParameter(int n) { n = 0 and result = this.getTypeParameter() }

  override string describe() { result = "'infer' type " + this.getTypeParameter().getName() }

  override string getAPrimaryQlClass() { result = "InferTypeExpr" }
}

/**
 * A template literal used as a type.
 */
class TemplateLiteralTypeExpr extends @template_literal_typeexpr, TypeExpr {
  /**
   * Gets the `i`th element of this template literal, which may either
   * be a type expression or a constant template element.
   */
  ExprOrType getElement(int i) { result = this.getChild(i) }

  /**
   * Gets an element of this template literal.
   */
  ExprOrType getAnElement() { result = this.getElement(_) }

  /**
   * Gets the number of elements of this template literal.
   */
  int getNumElement() { result = count(this.getAnElement()) }

  override string getAPrimaryQlClass() { result = "TemplateLiteralTypeExpr" }
}

/**
 * A scope induced by a conditional type expression whose `extends` type
 * contains `infer` types.
 */
class ConditionalTypeScope extends @conditional_type_scope, Scope {
  /** Gets the conditional type expression that induced this scope. */
  ConditionalTypeExpr getConditionalTypeExpr() { result = Scope.super.getScopeElement() }
}

/**
 * An expression with type arguments, occurring as the super-class expression of a class, for example:
 * ```
 * class StringList extends List<string>
 * ```
 * In the above example, `List` is a concrete expression, `string` is a type annotation,
 * and `List<string>` is thus an expression with type arguments.
 */
class ExpressionWithTypeArguments extends @expression_with_type_arguments, Expr {
  /**
   * Gets the expression, such as `List` in `List<string>`.
   *
   * Although it is common for this expression to take the form of a qualified name,
   * it can in general be any kind of expression.
   */
  Expr getExpression() { result = this.getChildExpr(-1) }

  /**
   * Gets the `n`th type argument, starting at 0.
   */
  TypeExpr getTypeArgument(int n) { result = this.getChildTypeExpr(n) }

  /**
   * Gets any of the type arguments.
   */
  TypeExpr getATypeArgument() { result = this.getTypeArgument(_) }

  /**
   * Gets the number of type arguments. This is always at least one.
   */
  int getNumTypeArgument() { result = count(this.getATypeArgument()) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getExpression().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "ExpressionWithTypeArguments" }
}

/**
 * A program element that supports type parameters, that is, a function, class, interface, type alias, mapped type, or `infer` type.
 */
class TypeParameterized extends @type_parameterized, AstNode {
  /** Gets the `n`th type parameter declared on this function or type. */
  TypeParameter getTypeParameter(int n) { none() } // Overridden in subtypes.

  /** Gets any type parameter declared on this function or type. */
  TypeParameter getATypeParameter() { result = this.getTypeParameter(_) }

  /** Gets the number of type parameters declared on this function or type. */
  int getNumTypeParameter() { result = count(this.getATypeParameter()) }

  /** Holds if this function or type declares any type parameters. */
  predicate hasTypeParameters() { exists(this.getATypeParameter()) }

  /** Gets a description of this function or type. */
  string describe() { none() }
}

/**
 * A type parameter declared on a class, interface, function, or type alias.
 */
class TypeParameter extends @type_parameter, TypeExpr {
  /**
   * Gets the name of the type parameter as a string.
   */
  string getName() { result = this.getIdentifier().getName() }

  /**
   * Gets the identifier node of the type parameter, such as `T` in `class C<T>`.
   */
  Identifier getIdentifier() { result = this.getChildTypeExpr(0) }

  /**
   * Gets the upper bound of the type parameter, such as `U` in `class C<T extends U>`.
   */
  TypeExpr getBound() { result = this.getChildTypeExpr(1) }

  /**
   * Gets the default value of the type parameter, such as `D` in `class C<T = D>`.
   */
  TypeExpr getDefault() { result = this.getChildTypeExpr(2) }

  /**
   * Gets the function or type that declares this type parameter.
   */
  TypeParameterized getHost() { result.getATypeParameter() = this }

  /**
   * Gets the local type name declared by this type parameter.
   */
  LocalTypeName getLocalTypeName() { result = this.getIdentifier().(TypeDecl).getLocalTypeName() }

  override string getAPrimaryQlClass() { result = "TypeParameter" }
}

/**
 * A type assertion, also known as an unchecked type cast, is a TypeScript expression
 * of form `E as T` or `<T> E` where `E` is an expression and `T` is a type.
 */
class TypeAssertion extends Expr, @type_assertion {
  /** Gets the expression whose type to assert, that is, the `E` in `E as T` or `<T> E`. */
  Expr getExpression() { result = this.getChildExpr(0) }

  /** Gets the type to cast to, that is, the `T` in `E as T` or `<T> E`. */
  TypeExpr getTypeAnnotation() { result = this.getChildTypeExpr(1) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getExpression().getFirstControlFlowNode()
  }

  override Expr getUnderlyingValue() { result = this.getExpression().getUnderlyingValue() }

  override Expr getUnderlyingReference() { result = this.getExpression().getUnderlyingReference() }

  override string getAPrimaryQlClass() { result = "TypeAssertion" }
}

/**
 * A type assertion specifically of the form `E as T` (as opposed to the `<T> E` syntax).
 */
class AsTypeAssertion extends TypeAssertion, @as_type_assertion { }

/**
 * A type assertion specifically of the form `<T> E` (as opposed to the `E as T` syntax).
 */
class PrefixTypeAssertion extends TypeAssertion, @prefix_type_assertion { }

/**
 * A satisfies type asserion of the form `E satisfies T` where `E` is an expression and `T` is a type.
 */
class SatisfiesExpr extends Expr, @satisfies_expr {
  /** Gets the expression whose type to assert, that is, the `E` in `E as T` or `<T> E`. */
  Expr getExpression() { result = this.getChildExpr(0) }

  /** Gets the type to cast to, that is, the `T` in `E as T` or `<T> E`. */
  TypeExpr getTypeAnnotation() { result = this.getChildTypeExpr(1) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getExpression().getFirstControlFlowNode()
  }

  override Expr getUnderlyingValue() { result = this.getExpression().getUnderlyingValue() }

  override Expr getUnderlyingReference() { result = this.getExpression().getUnderlyingReference() }

  override string getAPrimaryQlClass() { result = "SatisfiesExpr" }
}

/**
 * A TypeScript expression of form `E!`, asserting that `E` is not null.
 */
class NonNullAssertion extends Expr, @non_null_assertion {
  /** Gets the expression whose type to assert. */
  Expr getExpression() { result = this.getChildExpr(0) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getExpression().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "NonNullAssertion" }
}

/**
 * A possibly qualified identifier that refers to or declares a local name for a namespace.
 */
abstract class NamespaceRef extends AstNode { }

/**
 * An identifier that declares a local name for a namespace, that is,
 * the name of an actual namespace declaration or the local name of an import.
 *
 * For instance, this includes the `N` in each of the following examples:
 * ```
 * namespace N {}
 * import N = require('./lib')
 * import N from './lib'
 * import { N } from './lib'
 * import { X as N } from './lib'
 * import * as N from './lib'
 * ```
 */
class LocalNamespaceDecl extends VarDecl, NamespaceRef {
  LocalNamespaceDecl() {
    any(NamespaceDeclaration nd).getIdentifier() = this or
    any(ImportEqualsDeclaration im).getIdentifier() = this or
    any(ImportSpecifier im).getLocal() = this or
    any(EnumDeclaration ed).getIdentifier() = this
  }

  /** Gets the local name being declared. */
  LocalNamespaceName getLocalNamespaceName() { namespacedecl(this, result) }
}

/**
 * A possibly qualified name that refers to a namespace from inside a type annotation.
 *
 * For example, in the type access `A.B.C`, the prefix `A.B` is a qualified namespace access, and
 * the prefix `A` is a local namespace access.
 *
 * *Expressions* that refer to namespaces are represented as `VarAccess` and `PropAccess` expressions,
 * as opposed to `NamespaceAccess`.
 */
class NamespaceAccess extends TypeExpr, NamespaceRef, @namespace_access {
  Identifier getIdentifier() { none() }

  override string getAPrimaryQlClass() { result = "NamespaceAccess" }
}

/**
 * An identifier that refers to a namespace from inside a type annotation.
 */
class LocalNamespaceAccess extends NamespaceAccess, LexicalAccess, Identifier,
  @local_namespace_access
{
  override Identifier getIdentifier() { result = this }

  /** Gets the local name being accessed. */
  LocalNamespaceName getLocalNamespaceName() { namespacebind(this, result) }

  override string getAPrimaryQlClass() { result = "LocalNamespaceAccess" }
}

/**
 * A qualified name that refers to a namespace from inside a type annotation.
 */
class QualifiedNamespaceAccess extends NamespaceAccess, @qualified_namespace_access {
  NamespaceAccess getQualifier() { result = this.getChildTypeExpr(0) }

  override Identifier getIdentifier() { result = this.getChildTypeExpr(1) }
}

/**
 * An import inside a type annotation, such as in `import("http").ServerRequest`.
 */
class ImportTypeExpr extends TypeExpr, @import_typeexpr {
  /**
   * Gets the string literal with the imported path, such as `"http"` in `import("http")`.
   */
  TypeExpr getPathExpr() { result = this.getChildTypeExpr(0) }

  /**
   * Gets the unresolved path string, such as `http` in `import("http")`.
   */
  string getPath() { result = this.getPathExpr().(StringLiteralTypeExpr).getValue() }

  /** Holds if this import is used in the context of a type, such as in `let x: import("foo")`. */
  predicate isTypeAccess() { this instanceof @import_type_access }

  /** Holds if this import is used in the context of a namespace, such as in `let x: import("http").ServerRequest"`. */
  predicate isNamespaceAccess() { this instanceof @import_namespace_access }

  /** Holds if this import is used in the context of a variable type, such as `let x: typeof import("fs")`. */
  predicate isVarTypeAccess() { this instanceof @import_var_type_access }

  override string getAPrimaryQlClass() { result = "ImportTypeExpr" }
}

/**
 * An import used in the context of a type, such as in `let x: import("foo")`.
 */
class ImportTypeAccess extends TypeAccess, ImportTypeExpr, @import_type_access {
  override string getAPrimaryQlClass() { result = "ImportTypeAccess" }
}

/**
 * An import used in the context of a namespace inside a type annotation, such as in `let x: import("http").ServerRequest`.
 */
class ImportNamespaceAccess extends NamespaceAccess, ImportTypeExpr, @import_namespace_access {
  override string getAPrimaryQlClass() { result = "ImportNamespaceAccess" }
}

/**
 * An import used in the context of a variable type, such as in `let x: typeof import("fs")`.
 */
class ImportVarTypeAccess extends VarTypeAccess, ImportTypeExpr, @import_var_type_access {
  override string getAPrimaryQlClass() { result = "ImportVarTypeAccess" }
}

/**
 * A TypeScript enum declaration, such as the following declaration:
 * ```
 * enum Color { red = 1, green, blue }
 * ```
 */
class EnumDeclaration extends NamespaceDefinition, @enum_declaration, AST::ValueNode {
  /** Gets the name of this enum, such as `E` in `enum E { A, B }`. */
  override Identifier getIdentifier() { result = this.getChildExpr(0) }

  /** Gets the name of this enum as a string. */
  override string getName() { result = this.getIdentifier().getName() }

  /**
   * Gets the variable holding the enumeration object.
   *
   * For example, this would be the variable `E` introduced by `enum E { A, B }`.
   *
   * If the enumeration is a `const enum` then this variable will not exist at runtime
   * and all uses of the variable will be constant-folded by the TypeScript compiler,
   * but the analysis models it as an ordinary variable.
   */
  Variable getVariable() { result = this.getIdentifier().(VarDecl).getVariable() }

  /**
   * Gets the local type name introduced by the enumeration.
   *
   * For example, this would be the type `E` introduced by `enum E { A, B }`.
   */
  LocalTypeName getLocalTypeName() { result = this.getIdentifier().(TypeDecl).getLocalTypeName() }

  /**
   * Gets the local namespace name introduced by the enumeration, for use in
   * types that reference the enum members directly.
   *
   * For example, in the type `E.A` below, the enum `E` is accessed through the
   * local namespace name `E`:
   * ```
   * enum E { A = 1, B = 2 }
   * var x: E.A = 1
   * ```
   */
  override LocalNamespaceName getLocalNamespaceName() {
    result = this.getIdentifier().(LocalNamespaceDecl).getLocalNamespaceName()
  }

  /** Gets the `n`th enum member, starting at 0, such as `A` or `B` in `enum E { A, B }`. */
  EnumMember getMember(int n) { properties(result, this, n + 1, _, _) }

  /** Gets the enum member with the given name, if any. */
  EnumMember getMemberByName(string name) { result = this.getAMember() and result.getName() = name }

  /** Gets any of the enum members. */
  EnumMember getAMember() { result = this.getMember(_) }

  /** Gets the number of enum members. */
  int getNumMember() { result = count(this.getAMember()) }

  /** Gets the `n`th decorator applied to this enum declaration. */
  Decorator getDecorator(int n) { result = this.getChildExpr(-n - 1) }

  /** Gets a decorator applied to this enum declaration. */
  Decorator getADecorator() { result = this.getDecorator(_) }

  /** Gets the number of decorators applied to this enum declaration. */
  int getNumDecorator() { result = count(this.getADecorator()) }

  /** Holds if this enumeration is declared with the `const` keyword. */
  predicate isConst() { is_const_enum(this) }

  override ControlFlowNode getFirstControlFlowNode() { result = this.getIdentifier() }

  override string getAPrimaryQlClass() { result = "EnumDeclaration" }
}

/**
 * A member of a TypeScript enum declaration, such as `red` in the following declaration:
 * ```
 * enum Color { red = 1, green, blue }
 * ```
 */
class EnumMember extends AstNode, @enum_member {
  /**
   * Gets the name of the enum member, such as `off` in `enum State { on, off }`.
   *
   * Note that if the name of the member is written as a string literal,
   * a synthetic identifier node is created to represent the name.
   * In other words, the name will always be an identifier node.
   */
  Identifier getIdentifier() { result = this.getChildExpr(0) }

  /** Gets the name of the enum member as a string. */
  string getName() { result = this.getIdentifier().getName() }

  /** Gets the explicit initializer expression of this member, if any. */
  Expr getInitializer() { result = this.getChildExpr(1) }

  /** Gets the enum declaring this member. */
  EnumDeclaration getDeclaringEnum() { result.getAMember() = this }

  override string toString() { properties(this, _, _, _, result) }

  override ControlFlowNode getFirstControlFlowNode() { result = this.getIdentifier() }

  /**
   * Gets the name of the member prefixed by the declaring enum name.
   *
   * For example, the prefixed name of the `red` member below is `Color.red`:
   * ```
   * enum Color { red, green, blue }
   * ```
   */
  string getPrefixedName() { result = this.getDeclaringEnum().getName() + "." + this.getName() }

  override string getAPrimaryQlClass() { result = "EnumMember" }
}

/**
 * A scope induced by an interface declaration, containing the type parameters declared on the interface.
 *
 * Interfaces that do not declare type parameters have no scope object.
 */
class InterfaceScope extends @interface_scope, Scope {
  override string toString() { result = "interface scope" }
}

/**
 * A scope induced by a type alias declaration, containing the type parameters declared the the alias.
 *
 * Type aliases that do not declare type parameters have no scope object.
 */
class TypeAliasScope extends @type_alias_scope, Scope {
  override string toString() { result = "type alias scope" }
}

/**
 * A scope induced by a mapped type expression, containing the type parameter declared as part of the type.
 */
class MappedTypeScope extends @mapped_type_scope, Scope {
  override string toString() { result = "mapped type scope" }
}

/**
 * A scope induced by an enum declaration, containing the names of its enum members.
 *
 * Initializers of enum members are resolved in this scope since they can reference
 * previously-defined enum members by their unqualified name.
 */
class EnumScope extends @enum_scope, Scope {
  override string toString() { result = "enum scope" }
}

/**
 * A scope induced by a declaration of form `declare module "X" {...}`.
 */
class ExternalModuleScope extends @external_module_scope, Scope {
  override string toString() { result = "external module scope" }
}

/**
 * A TypeScript comment of one of the two forms:
 * ```
 * /// <reference path="FILE.d.ts"/>
 * /// <reference types="NAME"/>
 * ```
 */
class ReferenceImport extends LineComment {
  string attribute;
  string value;

  ReferenceImport() {
    this.getFile().getFileType().isTypeScript() and
    exists(string regex |
      regex = "/\\s*<reference\\s+([a-z]+)\\s*=\\s*[\"']([^\"']*)[\"']\\s*/>\\s*"
    |
      attribute = this.getText().regexpCapture(regex, 1) and
      value = this.getText().regexpCapture(regex, 2)
    ) and
    (attribute = "path" or attribute = "types")
  }

  /**
   * Gets the value of `path` or `types` attribute.
   */
  string getAttributeValue() { result = value }

  /**
   * Gets the name of the attribute, i.e. "`path`" or "`types`".
   */
  string getAttributeName() { result = attribute }
}

/**
 * A TypeScript comment of the form:
 * ```
 * /// <reference path="FILE.d.ts"/>
 * ```
 */
class ReferencePathImport extends ReferenceImport {
  ReferencePathImport() { attribute = "path" }
}

/**
 * A TypeScript comment of the form:
 * ```
 * /// <reference types="NAME" />
 * ```
 */
class ReferenceTypesImport extends ReferenceImport {
  ReferenceTypesImport() { attribute = "types" }
}

/**
 * A folder where TypeScript finds declaration files for imported modules.
 *
 * Currently, this is any folder whose path ends with `node_modules/@types`.
 */
class TypeRootFolder extends Folder {
  TypeRootFolder() {
    exists(Folder nodeModules |
      nodeModules.getBaseName() = "node_modules" and
      nodeModules.getFolder("@types") = this
    )
  }

  /**
   * Gets the enclosing `node_modules` folder.
   */
  Folder getNodeModulesFolder() { result = this.getParentContainer() }

  /**
   * Gets the `d.ts` file correspnding to the given module name.
   *
   * Concretely, this is the file at `node_modules/@types/<moduleName>/index.d.ts` if it exists.
   */
  File getModuleFile(string moduleName) {
    result = this.getFolder(moduleName).getFile("index.d.ts")
  }
}
