/**
 * @name PHP Type System
 * @description Core type system for PHP CodeQL analysis
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A PHP type annotation or declaration.
 * This wraps the tree-sitter type representation.
 */
class TypeAnnotation extends TS::PHP::AstNode {
  TypeAnnotation() {
    this instanceof TS::PHP::PrimitiveType or
    this instanceof TS::PHP::NamedType or
    this instanceof TS::PHP::OptionalType or
    this instanceof TS::PHP::UnionType or
    this instanceof TS::PHP::IntersectionType
  }

  /** Gets a string representation of this type */
  string getTypeName() {
    result = this.(TS::PHP::PrimitiveType).getValue() or
    result = this.(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue() or
    result = this.(TS::PHP::NamedType).getChild().(TS::PHP::QualifiedName).toString()
  }
}

/**
 * A primitive/built-in PHP type.
 */
class PrimitiveType extends TS::PHP::PrimitiveType {
  /** Gets the canonical name of this primitive type */
  string getCanonicalName() {
    exists(string v | v = this.getValue() |
      // Normalize type aliases
      v = "double" and result = "float" or
      v = "real" and result = "float" or
      v = "boolean" and result = "bool" or
      v = "integer" and result = "int" or
      v != "double" and v != "real" and v != "boolean" and v != "integer" and result = v
    )
  }

  /** Checks if this is a scalar type */
  predicate isScalar() {
    this.getCanonicalName() in ["int", "float", "string", "bool"]
  }

  /** Checks if this is a numeric type */
  predicate isNumeric() {
    this.getCanonicalName() in ["int", "float"]
  }
}

/**
 * A named type reference (class, interface, or trait name).
 */
class PhpNamedTypeRef extends TS::PHP::NamedType {
  /** Gets the simple name of this type */
  string getSimpleName() {
    result = this.getChild().(TS::PHP::Name).getValue()
  }

  /** Gets the qualified name if present */
  string getQualifiedName() {
    result = this.getChild().(TS::PHP::QualifiedName).toString()
  }
}

/**
 * An optional/nullable type (?T).
 */
class PhpOptionalTypeRef extends TS::PHP::OptionalType {
  /** Gets the inner type being made nullable */
  TypeAnnotation getInnerType() {
    result = this.getChild()
  }
}

/**
 * A union type (T|U|V).
 */
class PhpUnionType extends TS::PHP::UnionType {
  /** Gets a type alternative in this union */
  TypeAnnotation getAlternative(int i) {
    result = this.getChild(i)
  }

  /** Gets the number of alternatives */
  int getAlternativeCount() {
    result = count(int i | exists(this.getChild(i)))
  }
}

/**
 * An intersection type (T&U&V).
 */
class PhpIntersectionType extends TS::PHP::IntersectionType {
  /** Gets a type in this intersection */
  TypeAnnotation getMember(int i) {
    result = this.getChild(i)
  }
}

/**
 * Represents a PHP type hint in a parameter or return type.
 */
class TypeHint extends TS::PHP::AstNode {
  TypeHint() {
    this = any(TS::PHP::SimpleParameter p).getType() or
    this = any(TS::PHP::PropertyPromotionParameter p).getType() or
    this = any(TS::PHP::PropertyDeclaration p).getType()
  }
}

/**
 * Built-in type constants for comparison.
 */
module TypeConstants {
  /** String type name */
  string stringType() { result = "string" }

  /** Integer type name */
  string intType() { result = "int" }

  /** Float type name */
  string floatType() { result = "float" }

  /** Boolean type name */
  string boolType() { result = "bool" }

  /** Array type name */
  string arrayType() { result = "array" }

  /** Object type name */
  string objectType() { result = "object" }

  /** Mixed type name */
  string mixedType() { result = "mixed" }

  /** Void type name */
  string voidType() { result = "void" }

  /** Null type name */
  string nullType() { result = "null" }

  /** Never type name */
  string neverType() { result = "never" }

  /** Callable type name */
  string callableType() { result = "callable" }

  /** Iterable type name */
  string iterableType() { result = "iterable" }
}

/**
 * Checks if a type name represents a scalar type.
 */
predicate isScalarTypeName(string typeName) {
  typeName in ["int", "integer", "float", "double", "real", "string", "bool", "boolean"]
}

/**
 * Checks if a type name represents a numeric type.
 */
predicate isNumericTypeName(string typeName) {
  typeName in ["int", "integer", "float", "double", "real"]
}

/**
 * Normalizes a type name to its canonical form.
 */
bindingset[typeName]
string normalizeTypeName(string typeName) {
  typeName = "double" and result = "float" or
  typeName = "real" and result = "float" or
  typeName = "boolean" and result = "bool" or
  typeName = "integer" and result = "int" or
  not typeName in ["double", "real", "boolean", "integer"] and result = typeName
}
