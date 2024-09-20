/** Provides classes for working with JSDoc comments. */

import javascript
private import semmle.javascript.internal.CachedStages

/**
 * A JSDoc comment.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * An example JSDoc comment documenting a constructor function.
 *  *
 *  * @constructor
 *  * @param {Object=} options An object literal with options.
 *  *&#47;
 * </pre>
 */
class JSDoc extends @jsdoc, Locatable {
  /** Gets the description text of this JSDoc comment. */
  string getDescription() { jsdoc(this, result, _) }

  /** Gets the raw comment this JSDoc comment is an interpretation of. */
  Comment getComment() { jsdoc(this, _, result) }

  /** Gets a JSDoc tag within this JSDoc comment. */
  JSDocTag getATag() { result.getParent() = this }

  /** Gets a JSDoc tag within this JSDoc comment with the given title. */
  JSDocTag getATagByTitle(string title) {
    result = this.getATag() and
    result.getTitle() = title
  }

  override string toString() { result = this.getComment().toString() }
}

/**
 * A program element that can have a JSDoc comment.
 *
 * Example:
 *
 * <pre>
 * /**
 *  * An example JSDoc comment documenting a constructor function.
 *  *
 *  * @constructor
 *  * @param {Object=} options An object literal with options.
 *  *&#47;
 * function MyConstructor(options) {  // documentable
 *   this.options = options || {};
 * }
 * </pre>
 */
abstract class Documentable extends AstNode {
  /** Gets the JSDoc comment for this element, if any. */
  cached
  JSDoc getDocumentation() {
    Stages::Ast::ref() and result.getComment().getNextToken() = this.getFirstToken()
  }
}

/**
 * A syntactic element that a JSDoc type expression may be nested in, that is,
 * either a JSDoc tag or another JSDoc type expression.
 *
 * Examples:
 *
 * ```
 * // the `@param` tag and the `...=` type expressions are JSDoc type expression parents
 * @param {Object=} options An object literal with options.
 * ```
 */
class JSDocTypeExprParent extends @jsdoc_type_expr_parent, Locatable {
  /** Gets the JSDoc comment to which this element belongs. */
  JSDoc getJSDocComment() { none() }
}

/**
 * A JSDoc tag.
 *
 * Examples:
 *
 * ```
 * @param {Object=} options An object literal with options.
 * @return {!Server}
 * ```
 */
class JSDocTag extends @jsdoc_tag, JSDocTypeExprParent {
  /** Gets the tag title; for instance, the title of a `@param` tag is `"param"`. */
  string getTitle() { jsdoc_tags(this, result, _, _, _) }

  /** Gets the JSDoc comment this tag belongs to. */
  JSDoc getParent() { jsdoc_tags(this, _, result, _, _) }

  /** Gets the index of this tag within its parent comment. */
  int getIndex() { jsdoc_tags(this, _, _, result, _) }

  override string toString() { jsdoc_tags(this, _, _, _, result) }

  /** Gets the description associated with the tag. */
  string getDescription() { jsdoc_tag_descriptions(this, result) }

  /**
   * Gets the (optional) name associated with the tag, such as the name of the documented parameter
   * for a `@param` tag.
   */
  string getName() { jsdoc_tag_names(this, result) }

  /**
   * Gets the (optional) type associated with the tag, such as the type of the documented parameter
   * for a `@param` tag.
   */
  JSDocTypeExpr getType() { result.getParent() = this }

  /** Holds if this tag documents a simple name (as opposed to a name path). */
  predicate documentsSimpleName() {
    exists(string name | name = this.getName() | not name.matches("%.%"))
  }

  /** Gets the toplevel in which this tag appears. */
  TopLevel getTopLevel() { result = this.getParent().getComment().getTopLevel() }

  override JSDoc getJSDocComment() { result.getATag() = this }
}

/**
 * A `@param` tag.
 *
 * Example:
 *
 * ```
 * @param {Object=} options An object literal with options.
 * ```
 */
class JSDocParamTag extends JSDocTag {
  JSDocParamTag() { this.getTitle().regexpMatch("param|arg(ument)?") }

  /** Gets the parameter this tag refers to, if it can be determined. */
  Variable getDocumentedParameter() {
    exists(Parameterized parm | parm.getDocumentation() = this.getParent() |
      result = pragma[only_bind_out](parm).getParameterVariable(this.getName())
    )
  }
}

/**
 * A JSDoc type expression.
 *
 * Examples:
 *
 * ```
 * *
 * Array<string>
 * !Object
 * ```
 */
class JSDocTypeExpr extends @jsdoc_type_expr, JSDocTypeExprParent, TypeAnnotation {
  /**
   * Gets the syntactic element in which this type expression is nested, which may either
   * be another type expression or a JSDoc tag.
   */
  JSDocTypeExprParent getParent() { jsdoc_type_exprs(this, _, result, _, _) }

  /**
   * Gets the index of this type expression within its parent.
   */
  int getIndex() { jsdoc_type_exprs(this, _, _, result, _) }

  /**
   * Gets the `i`th child type expression of this type expression.
   *
   * _Note_: the indices of child type expressions in their parent elements are an implementation
   * detail that may change between versions of the extractor.
   */
  JSDocTypeExpr getChild(int i) { jsdoc_type_exprs(result, _, this, i, _) }

  override string toString() { jsdoc_type_exprs(this, _, _, _, result) }

  override JSDoc getJSDocComment() { result = this.getParent().getJSDocComment() }

  override Stmt getEnclosingStmt() {
    exists(Documentable astNode | astNode.getDocumentation() = this.getJSDocComment() |
      result = astNode
      or
      result = astNode.(ExprOrType).getEnclosingStmt()
      or
      result = astNode.(Property).getObjectExpr().getEnclosingStmt()
    )
  }

  override Function getEnclosingFunction() { result = this.getContainer() }

  override TopLevel getTopLevel() { result = this.getEnclosingStmt().getTopLevel() }
}

/**
 * An `any` type expression.
 *
 * Example:
 *
 * ```
 * *
 * ```
 */
class JSDocAnyTypeExpr extends @jsdoc_any_type_expr, JSDocTypeExpr {
  override predicate isAny() { any() }
}

/**
 * A null type expression.
 *
 * Example:
 *
 * ```
 * null
 * ```
 */
class JSDocNullTypeExpr extends @jsdoc_null_type_expr, JSDocTypeExpr {
  override predicate isNull() { any() }
}

/**
 * A type expression representing the type of `undefined`.
 *
 * Example:
 *
 * ```
 * undefined
 * ```
 */
class JSDocUndefinedTypeExpr extends @jsdoc_undefined_type_expr, JSDocTypeExpr {
  override predicate isUndefined() { any() }
}

/**
 * A type expression representing an unknown type.
 *
 * Example:
 *
 * ```
 * ?
 * ```
 */
class JSDocUnknownTypeExpr extends @jsdoc_unknown_type_expr, JSDocTypeExpr {
  override predicate isUnknownKeyword() { any() }
}

/**
 * A type expression representing the void type.
 *
 * Example:
 *
 * ```
 * void
 * ```
 */
class JSDocVoidTypeExpr extends @jsdoc_void_type_expr, JSDocTypeExpr {
  override predicate isVoid() { any() }
}

/**
 * A type expression referring to a named type.
 *
 * Example:
 *
 * ```
 * string
 * Object
 * ```
 */
class JSDocNamedTypeExpr extends @jsdoc_named_type_expr, JSDocTypeExpr {
  /** Gets the name of the type the expression refers to. */
  string getName() { result = this.toString() }

  override predicate isString() { this.getName() = "string" }

  override predicate isStringy() {
    exists(string name | name = this.getName() |
      name = "string" or
      name = "String"
    )
  }

  override predicate isNumber() { this.getName() = "number" }

  override predicate isNumbery() {
    exists(string name | name = this.getName() |
      name = ["number", "Number", "double", "Double", "int", "integer", "Integer"]
    )
  }

  override predicate isBoolean() { this.getName() = "boolean" }

  override predicate isBooleany() {
    this.getName() = "boolean" or
    this.getName() = "Boolean" or
    this.getName() = "bool"
  }

  override predicate isRawFunction() { this.getName() = "Function" }

  /**
   * Holds if this name consists of the unqualified name `prefix`
   * followed by a (possibly empty) `suffix`.
   *
   * For example:
   * - `foo.bar.Baz` has prefix `foo` and suffix `.bar.Baz`.
   * - `Baz` has prefix `Baz` and an empty suffix.
   */
  predicate hasNameParts(string prefix, string suffix) {
    exists(string regex, string name | regex = "([^.]+)(.*)" |
      name = this.getName() and
      prefix = name.regexpCapture(regex, 1) and
      suffix = name.regexpCapture(regex, 2)
    )
  }

  pragma[noinline]
  pragma[nomagic]
  private predicate hasNamePartsAndEnv(string prefix, string suffix, JSDoc::Environment env) {
    // Force join ordering
    this.hasNameParts(prefix, suffix) and
    env.isContainerInScope(this.getContainer())
  }

  /**
   * Gets the qualified name of this name by resolving its prefix, if any.
   */
  cached
  private string resolvedName() {
    exists(string prefix, string suffix, JSDoc::Environment env |
      this.hasNamePartsAndEnv(prefix, suffix, env) and
      result = env.resolveAlias(prefix) + suffix
    )
  }

  override predicate hasQualifiedName(string globalName) {
    globalName = this.resolvedName()
    or
    not exists(this.resolvedName()) and
    globalName = this.getName()
  }

  override DataFlow::ClassNode getClass() {
    exists(string name |
      this.hasQualifiedName(name) and
      result.hasQualifiedName(name)
    )
    or
    // Handle case where a local variable has a reference to the class,
    // but the class doesn't have a globally qualified name.
    exists(string alias, JSDoc::Environment env |
      this.hasNamePartsAndEnv(alias, "", env) and
      result.getAClassReference().flowsTo(env.getNodeFromAlias(alias))
    )
  }
}

/**
 * An applied type expression.
 *
 * Example:
 *
 * ```
 * Array<string>
 * ```
 */
class JSDocAppliedTypeExpr extends @jsdoc_applied_type_expr, JSDocTypeExpr {
  /** Gets the head type expression, such as `Array` in `Array<string>`. */
  JSDocTypeExpr getHead() { result = this.getChild(-1) }

  /**
   * Gets the `i`th argument type of the applied type expression.
   *
   * For example, in `Array<string>`, `string` is the 0th argument type.
   */
  JSDocTypeExpr getArgument(int i) { i >= 0 and result = this.getChild(i) }

  /**
   * Gets an argument type of the applied type expression.
   *
   * For example, in `Array<string>`, `string` is the only argument type.
   */
  JSDocTypeExpr getAnArgument() { result = this.getArgument(_) }

  override predicate hasQualifiedName(string globalName) {
    this.getHead().hasQualifiedName(globalName)
  }

  override DataFlow::ClassNode getClass() { result = this.getHead().getClass() }
}

/**
 * A nullable type expression.
 *
 * Example:
 *
 * ```
 * ?Array
 * ```
 */
class JSDocNullableTypeExpr extends @jsdoc_nullable_type_expr, JSDocTypeExpr {
  /** Gets the argument type expression. */
  JSDocTypeExpr getTypeExpr() { result = this.getChild(0) }

  /** Holds if the `?` operator of this type expression is written in prefix notation. */
  predicate isPrefix() { jsdoc_prefix_qualifier(this) }

  override JSDocTypeExpr getAnUnderlyingType() { result = this.getTypeExpr().getAnUnderlyingType() }

  override DataFlow::ClassNode getClass() { result = this.getTypeExpr().getClass() }
}

/**
 * A non-nullable type expression.
 *
 * Example:
 *
 * ```
 * !Array
 * ```
 */
class JSDocNonNullableTypeExpr extends @jsdoc_non_nullable_type_expr, JSDocTypeExpr {
  /** Gets the argument type expression. */
  JSDocTypeExpr getTypeExpr() { result = this.getChild(0) }

  /** Holds if the `!` operator of this type expression is written in prefix notation. */
  predicate isPrefix() { jsdoc_prefix_qualifier(this) }

  override JSDocTypeExpr getAnUnderlyingType() { result = this.getTypeExpr().getAnUnderlyingType() }

  override DataFlow::ClassNode getClass() { result = this.getTypeExpr().getClass() }
}

/**
 * A record type expression.
 *
 * Example:
 *
 * ```
 * { x: number, y: string }
 * ```
 */
class JSDocRecordTypeExpr extends @jsdoc_record_type_expr, JSDocTypeExpr {
  /** Gets the name of the `i`th field of the record type. */
  string getFieldName(int i) { jsdoc_record_field_name(this, i, result) }

  /** Gets the name of some field of the record type. */
  string getAFieldName() { result = this.getFieldName(_) }

  /** Gets the type of the `i`th field of the record type. */
  JSDocTypeExpr getFieldType(int i) { result = this.getChild(i) }

  /** Gets the type of the field with the given name. */
  JSDocTypeExpr getFieldTypeByName(string fieldname) {
    exists(int idx | fieldname = this.getFieldName(idx) and result = this.getFieldType(idx))
  }
}

/**
 * An array type expression.
 *
 * Example:
 *
 * ```
 * [string]
 * ```
 */
class JSDocArrayTypeExpr extends @jsdoc_array_type_expr, JSDocTypeExpr {
  /** Gets the type of the `i`th element of this array type. */
  JSDocTypeExpr getElementType(int i) { result = this.getChild(i) }

  /** Gets an element type of this array type. */
  JSDocTypeExpr getAnElementType() { result = this.getElementType(_) }
}

/**
 * A union type expression.
 *
 * Example:
 *
 * ```
 * number|string
 * ```
 */
class JSDocUnionTypeExpr extends @jsdoc_union_type_expr, JSDocTypeExpr {
  /** Gets one of the type alternatives of this union type. */
  JSDocTypeExpr getAnAlternative() { result = this.getChild(_) }

  override JSDocTypeExpr getAnUnderlyingType() {
    result = this.getAnAlternative().getAnUnderlyingType()
  }
}

/**
 * A function type expression.
 *
 * Example:
 *
 * ```
 * function(string): number
 * ```
 */
class JSDocFunctionTypeExpr extends @jsdoc_function_type_expr, JSDocTypeExpr {
  /** Gets the result type of this function type. */
  JSDocTypeExpr getResultType() { result = this.getChild(-1) }

  /** Gets the receiver type of this function type. */
  JSDocTypeExpr getReceiverType() { result = this.getChild(-2) }

  /** Gets the `i`th parameter type of this function type. */
  JSDocTypeExpr getParameterType(int i) { i >= 0 and result = this.getChild(i) }

  /** Gets a parameter type of this function type. */
  JSDocTypeExpr getAParameterType() { result = this.getParameterType(_) }

  /** Holds if this function type is a constructor type. */
  predicate isConstructorType() { jsdoc_has_new_parameter(this) }
}

/**
 * An optional parameter type.
 *
 * Example:
 *
 * ```
 * number=
 * ```
 */
class JSDocOptionalParameterTypeExpr extends @jsdoc_optional_type_expr, JSDocTypeExpr {
  /** Gets the underlying type of this optional type. */
  JSDocTypeExpr getUnderlyingType() { result = this.getChild(0) }

  override JSDocTypeExpr getAnUnderlyingType() {
    result = this.getUnderlyingType().getAnUnderlyingType()
  }

  override DataFlow::ClassNode getClass() { result = this.getUnderlyingType().getClass() }
}

/**
 * A rest parameter type.
 *
 * Example:
 *
 * ```
 * string...
 * ```
 */
class JSDocRestParameterTypeExpr extends @jsdoc_rest_type_expr, JSDocTypeExpr {
  /** Gets the underlying type of this rest parameter type. */
  JSDocTypeExpr getUnderlyingType() { result = this.getChild(0) }
}

/**
 * An error encountered while parsing a JSDoc comment.
 */
class JSDocError extends @jsdoc_error {
  /** Gets the tag that triggered the error. */
  JSDocTag getTag() { jsdoc_errors(this, result, _, _) }

  /** Gets the message associated with the error. */
  string getMessage() { jsdoc_errors(this, _, result, _) }

  /** Gets a textual representation of this element. */
  string toString() { jsdoc_errors(this, _, _, result) }
}

module JSDoc {
  /**
   * A statement container which may declare JSDoc name aliases.
   */
  class Environment extends StmtContainer {
    /**
     * Gets the fully qualified name aliased by the given unqualified name
     * within this container.
     */
    string resolveAlias(string alias) {
      this.getNodeFromAlias(alias) = AccessPath::getAReferenceOrAssignmentTo(result)
    }

    /**
     * Gets a data flow node from which the type name `alias` should
     * be resolved.
     */
    DataFlow::Node getNodeFromAlias(string alias) {
      exists(VarDef def, VarRef ref |
        def.getContainer() = this and
        ref = def.getTarget().(BindingPattern).getABindingVarRef() and
        ref.getName() = alias and
        isTypenamePrefix(ref.getName()) // restrict size of predicate
      |
        exists(PropertyPattern p |
          ref = p.getValuePattern() and
          result.getAstNode() = p
        )
        or
        result = DataFlow::valueNode(def.(Stmt))
        or
        ref = def.getTarget() and
        result = def.getSource().flow()
        or
        result = DataFlow::parameterNode(def)
      )
    }

    /**
     * Holds if the aliases declared in this environment should be in scope
     * within the given container.
     *
     * Specifically, this holds if this environment declares at least one
     * alias and is an ancestor of `container`.
     */
    final predicate isContainerInScope(StmtContainer container) {
      exists(this.resolveAlias(_)) and // restrict size of predicate
      container = this
      or
      this.isContainerInScope(container.getEnclosingContainer())
    }
  }

  pragma[noinline]
  private predicate isTypenamePrefix(string name) {
    any(JSDocNamedTypeExpr expr).hasNameParts(name, _)
  }
}
