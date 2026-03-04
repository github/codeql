/**
 * Provides classes for PHP variables and names.
 */

private import codeql.php.AST
private import internal.TreeSitter

/** A name token (identifier). */
class Name extends AstNode, @php_token_name {
  override string getAPrimaryQlClass() { result = "Name" }

  /** Gets the string value of this name. */
  string getValue() { php_tokeninfo(this, _, result) }

  override string toString() { result = this.getValue() }
}

/** A qualified name (`Namespace\ClassName`). */
class QualifiedName extends AstNode, @php_qualified_name {
  override string getAPrimaryQlClass() { result = "QualifiedName" }

  /** Gets the terminal name part. */
  Name getNamePart() { php_qualified_name_def(this, result) }

  /** Gets the string value of the terminal name. */
  string getValue() { result = this.getNamePart().getValue() }

  override string toString() { result = this.getValue() }
}

/** A namespace name. */
class NamespaceName extends AstNode, @php_namespace_name {
  override string getAPrimaryQlClass() { result = "NamespaceName" }

  /** Gets the i-th component name. */
  Name getComponent(int i) { php_namespace_name_child(this, i, result) }

  /** Gets a component name. */
  Name getAComponent() { result = this.getComponent(_) }

  override string toString() { result = "namespace_name" }
}

/** A variable name (`$x`). */
class VariableName extends AstNode, @php_variable_name {
  override string getAPrimaryQlClass() { result = "VariableName" }

  /** Gets the inner name token. */
  Name getName() { php_variable_name_def(this, result) }

  /** Gets the full variable name including the `$` prefix. */
  string getValue() { result = "$" + this.getName().getValue() }

  /** Gets the name without the `$` prefix. */
  string getSimpleName() { result = this.getName().getValue() }

  override string toString() { result = this.getValue() }
}

/**
 * A type node in a type annotation.
 *
 * This covers named types (`ClassName`), primitive types (`int`, `string`),
 * nullable types (`?int`), union types (`int|string`), and intersection types.
 */
class TypeNode extends AstNode, @php_type__ {
  override string getAPrimaryQlClass() { result = "TypeNode" }
}

/** A named type (`ClassName`). */
class NamedType extends TypeNode, @php_named_type {
  override string getAPrimaryQlClass() { result = "NamedType" }

  AstNode getNameNode() { php_named_type_def(this, result) }

  override string toString() { result = "named_type" }
}

/** A primitive type (`int`, `string`, `bool`, etc.). */
class PrimitiveType extends TypeNode, @php_token_primitive_type {
  override string getAPrimaryQlClass() { result = "PrimitiveType" }

  string getValue() { php_tokeninfo(this, _, result) }

  override string toString() { result = this.getValue() }
}

/** A nullable (optional) type (`?int`). */
class OptionalType extends TypeNode, @php_optional_type {
  override string getAPrimaryQlClass() { result = "OptionalType" }

  TypeNode getInnerType() { php_optional_type_def(this, result) }

  override string toString() { result = "?..." }
}

/** A union type (`int|string`). */
class UnionType extends TypeNode, @php_union_type {
  override string getAPrimaryQlClass() { result = "UnionType" }

  TypeNode getMember(int i) { php_union_type_child(this, i, result) }

  TypeNode getAMember() { result = this.getMember(_) }

  override string toString() { result = "...|..." }
}

/** An intersection type (`Foo&Bar`). */
class IntersectionType extends TypeNode, @php_intersection_type {
  override string getAPrimaryQlClass() { result = "IntersectionType" }

  TypeNode getMember(int i) { php_intersection_type_child(this, i, result) }

  TypeNode getAMember() { result = this.getMember(_) }

  override string toString() { result = "...&..." }
}
