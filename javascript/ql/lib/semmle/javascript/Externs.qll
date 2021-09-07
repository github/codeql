/**
 * Provides classes for working with external declarations from Closure-style externs files.
 *
 * A declaration may either declare a type alias, a global variable or a member variable.
 * Member variables may either be static variables, meaning that they are directly attached
 * to a global object (typically a constructor function), or instance variables, meaning
 * that they are attached to the 'prototype' property of a constructor function.
 *
 * An example of a type alias declaration is
 *
 * <pre>
 * /** @typedef {String} *&#47;
 * var MyString;
 * </pre>
 *
 * Examples of a global variable declarations are
 *
 * <pre>
 * var Math = {};
 * function Object() {}
 * var Array = function() {};
 * </pre>
 *
 * Examples of static member variable declarations are
 *
 * <pre>
 * Math.PI;
 * Object.keys = function(obj) {};
 * Array.isArray = function(arr) {};
 * </pre>
 *
 * Examples of instance member variable declarations are
 *
 * <pre>
 * Object.prototype.hasOwnProperty = function(p) {};
 * Array.prototype.length;
 * </pre>
 */

import javascript

/**
 * A declaration in an externs file.
 *
 * Examples:
 *
 * <pre>
 * /**
 *  * @constructor
 *  * @return {!Object}
 *  *&#47;
 * function Object() {}
 *
 * /**
 *  * @param {!Object} obj
 *  * @return {!Array<string>}
 *  *&#47;
 * Object.keys = function(obj) {};
 *
 * /**
 *  * @param {*} p
 *  * @return {boolean}
 *  *&#47;
 * Object.prototype.hasOwnProperty = function(p) {};
 * </pre>
 */
abstract class ExternalDecl extends ASTNode {
  /** Gets the name of this declaration. */
  abstract string getName();

  /** Gets the qualified name of this declaration. */
  abstract string getQualifiedName();
}

/** Holds if statement `s` has a JSDoc comment with a `@typedef` tag in it. */
private predicate hasTypedefAnnotation(Stmt s) {
  s.getDocumentation().getATag().getTitle() = "typedef"
}

/** A typedef declaration in an externs file. */
class ExternalTypedef extends ExternalDecl, VariableDeclarator {
  ExternalTypedef() {
    getBindingPattern() instanceof Identifier and
    inExternsFile() and
    hasTypedefAnnotation(getDeclStmt())
  }

  override string getName() { result = getBindingPattern().(Identifier).getName() }

  override string getQualifiedName() { result = getName() }
}

/**
 * A variable or function declaration in an externs file.
 *
 * Examples:
 *
 * <pre>
 * /**
 *  * @constructor
 *  * @return {!Object}
 *  *&#47;
 * function Object() {}
 *
 * /**
 *  * @type {number}
 *  *&#47;
 * var NaN;
 *
 * /**
 *  * @param {!Object} obj
 *  * @return {!Array<string>}
 *  *&#47;
 * Object.keys = function(obj) {};
 *
 * /**
 *  * @type {number}
 *  *&#47;
 * Number.NaN;
 * </pre>
 */
abstract class ExternalVarDecl extends ExternalDecl {
  /**
   * Gets the initializer associated with this declaration, if any.
   *
   * The result can be either a function or an expression.
   */
  abstract ASTNode getInit();

  /**
   * Gets a JSDoc tag associated with this declaration.
   */
  JSDocTag getATag() { result = this.(Documentable).getDocumentation().getATag() }

  /**
   * Gets the `@type` tag associated with this declaration, if any.
   */
  ExternalTypeTag getTypeTag() { result = getATag() }
}

/**
 * A global declaration of a function or variable in an externs file.
 *
 * Examples:
 *
 * <pre>
 * /**
 *  * @constructor
 *  * @return {!Object}
 *  *&#47;
 * function Object() {}
 *
 * /**
 *  * @type {number}
 *  *&#47;
 * var NaN;
 * </pre>
 */
abstract class ExternalGlobalDecl extends ExternalVarDecl {
  override string getQualifiedName() { result = getName() }
}

/**
 * A global function declaration in an externs file.
 *
 * Examples:
 *
 * <pre>
 * /**
 *  * @constructor
 *  * @return {!Object}
 *  *&#47;
 * function Object() {}
 * </pre>
 */
class ExternalGlobalFunctionDecl extends ExternalGlobalDecl, FunctionDeclStmt {
  ExternalGlobalFunctionDecl() { inExternsFile() }

  /** Gets the name of this declaration. */
  override string getName() { result = FunctionDeclStmt.super.getName() }

  override ASTNode getInit() { result = this }
}

/**
 * A global variable declaration in an externs file.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * @type {number}
 *  *&#47;
 * var NaN;
 * </pre>
 */
class ExternalGlobalVarDecl extends ExternalGlobalDecl, VariableDeclarator {
  ExternalGlobalVarDecl() {
    getBindingPattern() instanceof Identifier and
    inExternsFile() and
    // exclude type aliases
    not hasTypedefAnnotation(getDeclStmt())
  }

  override string getName() { result = getBindingPattern().(Identifier).getName() }

  /** Gets the initializer associated with this declaration, if any. */
  override Expr getInit() { result = VariableDeclarator.super.getInit() }
}

/**
 * A member variable declaration in an externs file.
 *
 * <pre>
 * /**
 *  * @param {!Object} obj
 *  * @return {!Array<string>}
 *  *&#47;
 * Object.keys = function(obj) {};
 *
 * /**
 *  * @type {number}
 *  *&#47;
 * Number.NaN;
 * </pre>
 */
class ExternalMemberDecl extends ExternalVarDecl, ExprStmt {
  ExternalMemberDecl() {
    getParent() instanceof Externs and
    (
      getExpr() instanceof PropAccess or
      getExpr().(AssignExpr).getLhs() instanceof PropAccess
    )
  }

  /**
   * Gets the property access describing the declared member.
   */
  PropAccess getProperty() {
    result = getExpr() or
    result = getExpr().(AssignExpr).getLhs()
  }

  override Expr getInit() { result = getExpr().(AssignExpr).getRhs() }

  override string getQualifiedName() { result = getBaseName() + "." + getName() }

  /**
   * Holds if this member belongs to type `base` and has name `name`.
   */
  predicate hasQualifiedName(string base, string name) { base = getBaseName() and name = getName() }

  override string getName() { result = getProperty().getPropertyName() }

  /**
   * Gets the name of the base type to which the member declared by this declaration belongs.
   */
  string getBaseName() { none() }

  /**
   * Gets the base type to which the member declared by this declaration belongs.
   */
  ExternalType getDeclaringType() { result.getQualifiedName() = getBaseName() }
}

/**
 * A static member variable declaration in an externs file.
 *
 * Examples:
 *
 * <pre>
 * /**
 *  * @param {!Object} obj
 *  * @return {!Array<string>}
 *  *&#47;
 * Object.keys = function(obj) {};
 *
 * /**
 *  * @type {number}
 *  *&#47;
 * Number.NaN;
 * </pre>
 */
class ExternalStaticMemberDecl extends ExternalMemberDecl {
  ExternalStaticMemberDecl() { getProperty().getBase() instanceof Identifier }

  override string getBaseName() { result = getProperty().getBase().(Identifier).getName() }
}

/**
 * An instance member variable declaration in an externs file.
 *
 * Examples:
 *
 * <pre>
 * /**
 *  * @param {*} p
 *  * @return {boolean}
 *  *&#47;
 * Object.prototype.hasOwnProperty = function(p) {};
 *
 * /**
 *  * @type {number}
 *  *&#47;
 * Array.prototype.length;
 * </pre>
 */
class ExternalInstanceMemberDecl extends ExternalMemberDecl {
  ExternalInstanceMemberDecl() {
    exists(PropAccess outer, PropAccess inner | outer = getProperty() and inner = outer.getBase() |
      inner.getBase() instanceof Identifier and
      inner.getPropertyName() = "prototype"
    )
  }

  override string getBaseName() {
    result = getProperty().getBase().(PropAccess).getBase().(Identifier).getName()
  }
}

/**
 * A function or object defined in an externs file.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * @param {*} p
 *  * @return {boolean}
 *  *&#47;
 * Object.prototype.hasOwnProperty =
 *   function(p) {};  // external function entity
 * </pre>
 */
class ExternalEntity extends ASTNode {
  ExternalEntity() { exists(ExternalVarDecl d | d.getInit() = this) }

  /** Gets the variable declaration to which this entity belongs. */
  ExternalVarDecl getDecl() { result.getInit() = this }
}

/**
 * A function defined in an externs file.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * @param {*} p
 *  * @return {boolean}
 *  *&#47;
 * Object.prototype.hasOwnProperty =
 *   function(p) {};  // external function
 * </pre>
 */
class ExternalFunction extends ExternalEntity, Function {
  /**
   * Holds if the last parameter of this external function has a rest parameter type annotation.
   */
  predicate isVarArgs() {
    exists(SimpleParameter lastParm, JSDocParamTag pt |
      lastParm = this.getParameter(this.getNumParameter() - 1) and
      pt = getDecl().getATag() and
      pt.getName() = lastParm.getName() and
      pt.getType() instanceof JSDocRestParameterTypeExpr
    )
  }
}

/**
 * A `@constructor` tag.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * @constructor  // constructor tag
 *  *&#47;
 * function Array() {}
 * </pre>
 */
class ConstructorTag extends JSDocTag {
  ConstructorTag() { getTitle() = "constructor" }
}

/**
 * A JSDoc tag that refers to a named type.
 *
 * Example:
 *
 * <pre>
 * /** @type {number} *&#47;  // refers to named type `number`
 * var NaN;
 * </pre>
 */
abstract private class NamedTypeReferent extends JSDocTag {
  /** Gets the name of the type to which this tag refers. */
  string getTarget() {
    result = getType().(JSDocNamedTypeExpr).getName() or
    result = getType().(JSDocAppliedTypeExpr).getHead().(JSDocNamedTypeExpr).getName()
  }

  /**
   * Gets the source declaration of the type to which this tag refers, if any.
   *
   * The source declaration of a constructor or interface type is the declaration of the
   * type itself; the source declaration of an applied type is the source declaration of
   * its head; the source declaration of a qualified type such as a nullable or non-nullable
   * type is that of the underlying type.
   *
   * For example, the source declaration of `!Array<string>` is (the declaration of)
   * type `Array`, which is also the source declaration of `!Array=`. Primitive types,
   * union types, and other complex kinds of types do not have a source declaration.
   */
  ExternalType getTypeDeclaration() { result = sourceDecl(getType()) }
}

/**
 * Gets the source declaration of the type to which `tp` refers, if any.
 */
private ExternalType sourceDecl(JSDocTypeExpr tp) {
  result.getQualifiedName() = tp.(JSDocNamedTypeExpr).getName() or
  result = sourceDecl(tp.(JSDocAppliedTypeExpr).getHead()) or
  result = sourceDecl(tp.(JSDocNullableTypeExpr).getTypeExpr()) or
  result = sourceDecl(tp.(JSDocNonNullableTypeExpr).getTypeExpr()) or
  result = sourceDecl(tp.(JSDocOptionalParameterTypeExpr).getUnderlyingType())
}

/**
 * An `@implements` tag.
 *
 * Example:
 *
 * <pre>
 * /** @implements {EventTarget} *&#47;
 * function Node() {}
 * </pre>
 */
class ImplementsTag extends NamedTypeReferent {
  ImplementsTag() { getTitle() = "implements" }
}

/**
 * An `@extends` tag.
 *
 * Example:
 *
 * <pre>
 * /** @extends {Node} *&#47;
 * function Document() {}
 * </pre>
 */
class ExtendsTag extends NamedTypeReferent {
  ExtendsTag() { getTitle() = "extends" }
}

/**
 * A `@type` tag.
 *
 * Example:
 *
 * <pre>
 * /** @type {number} *&#47;
 * var NaN;
 * </pre>
 */
class ExternalTypeTag extends NamedTypeReferent {
  ExternalTypeTag() { getTitle() = "type" }
}

/**
 * A constructor or interface function defined in an externs file.
 *
 * Examples:
 *
 * <pre>
 * /**
 *  * @constructor
 *  * @return {!Object}
 *  *&#47;
 * function Object() {}
 *
 * /**
 *  * @interface
 *  *&#47;
 * function EventTarget() {}
 * </pre>
 */
abstract class ExternalType extends ExternalGlobalFunctionDecl {
  /** Gets a type which this type extends. */
  ExternalType getAnExtendedType() {
    getDocumentation().getATag().(ExtendsTag).getTarget() = result.getQualifiedName()
  }

  /** Gets a type which this type implements. */
  ExternalType getAnImplementedType() {
    getDocumentation().getATag().(ImplementsTag).getTarget() = result.getQualifiedName()
  }

  /** Gets a supertype of this type. */
  ExternalType getASupertype() { result = getAnExtendedType() or result = getAnImplementedType() }

  /** Gets a declaration of a member of this type. */
  ExternalMemberDecl getAMember() { result.getDeclaringType() = this }
}

/**
 * A constructor function defined in an externs file.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * @constructor
 *  * @return {!Object}
 *  *&#47;
 * function Object() {}
 * </pre>
 */
class ExternalConstructor extends ExternalType {
  ExternalConstructor() { getDocumentation().getATag() instanceof ConstructorTag }
}

/**
 * An interface function defined in an externs file.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * @interface
 *  *&#47;
 * function EventTarget() {}
 * </pre>
 */
class ExternalInterface extends ExternalType {
  ExternalInterface() { getDocumentation().getATag().getTitle() = "interface" }
}

/**
 * Externs definition for the Function object.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * @constructor
 *  * @param {...*} args
 *  *&#47;
 * function Function(args) {}
 * </pre>
 */
class FunctionExternal extends ExternalConstructor {
  FunctionExternal() { getName() = "Function" }
}

/**
 * Externs definition for the Object object.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * @constructor
 *  * @return {!Object}
 *  *&#47;
 * function Object() {}
 * </pre>
 */
class ObjectExternal extends ExternalConstructor {
  ObjectExternal() { getName() = "Object" }
}

/**
 * Externs definition for the Array object.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * @constructor
 *  * @param {...*} args
 *  * @return {!Array}
 *  *&#47;
 * function Array(args) {}
 * </pre>
 */
class ArrayExternal extends ExternalConstructor {
  ArrayExternal() { getName() = "Array" }
}
