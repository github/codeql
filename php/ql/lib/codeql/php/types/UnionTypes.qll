/**
 * @name Union Types
 * @description Support for PHP 8.0+ union types
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A union type declaration.
 */
class UnionTypeDeclaration extends TS::PHP::UnionType {
  /** Gets a type in this union by index */
  TS::PHP::AstNode getTypeAt(int i) {
    result = this.getChild(i)
  }

  /** Gets the number of types in this union */
  int getTypeCount() {
    result = count(int i | exists(this.getChild(i)))
  }

  /** Gets a type name in this union */
  string getATypeName() {
    result = this.getChild(_).(TS::PHP::PrimitiveType).toString() or
    result = this.getChild(_).(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }

  /** Checks if this union contains null */
  predicate containsNull() {
    this.getChild(_).(TS::PHP::PrimitiveType).toString() = "null"
  }

  /** Checks if this is a nullable union (contains null) */
  predicate isNullable() {
    this.containsNull()
  }
}

/**
 * An intersection type declaration (PHP 8.1+).
 */
class IntersectionTypeDeclaration extends TS::PHP::IntersectionType {
  /** Gets a type in this intersection by index */
  TS::PHP::AstNode getTypeAt(int i) {
    result = this.getChild(i)
  }

  /** Gets the number of types in this intersection */
  int getTypeCount() {
    result = count(int i | exists(this.getChild(i)))
  }

  /** Gets a type name in this intersection */
  string getATypeName() {
    result = this.getChild(_).(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }
}

/**
 * A disjunctive normal form (DNF) type (PHP 8.2+).
 * Represents types like (A&B)|C or (A&B)|(C&D)
 */
class DnfTypeDeclaration extends TS::PHP::UnionType {
  DnfTypeDeclaration() {
    this.getChild(_) instanceof TS::PHP::IntersectionType
  }

  /** Gets an intersection group in this DNF type */
  TS::PHP::IntersectionType getIntersectionGroup(int i) {
    result = this.getChild(i)
  }

  /** Gets the number of groups in this DNF type */
  int getGroupCount() {
    result = count(int i | exists(this.getChild(i)))
  }
}

/**
 * Utilities for working with union types.
 */
module UnionTypeUtils {
  /** Checks if a type string represents a union */
  bindingset[typeStr]
  predicate isUnionTypeString(string typeStr) {
    typeStr.matches("%|%")
  }

  /** Splits a union type string into components */
  bindingset[unionStr]
  string splitUnionType(string unionStr, int index) {
    exists(string parts |
      unionStr.splitAt("|", index) = parts and
      result = parts.trim()
    )
  }

  /** Checks if two union types are equivalent (same members) */
  predicate areEquivalentUnions(UnionTypeDeclaration a, UnionTypeDeclaration b) {
    forall(string typeName | typeName = a.getATypeName() | typeName = b.getATypeName()) and
    forall(string typeName | typeName = b.getATypeName() | typeName = a.getATypeName())
  }
}
