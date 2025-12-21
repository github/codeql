/**
 * @name PHP 8.2+ Disjunctive Normal Form Types
 * @description Provides analysis for PHP 8.2+ DNF types
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A union type expression (A|B).
 */
class PhpUnionType extends TS::PHP::UnionType {
  /** Gets a component type of this union */
  TS::PHP::AstNode getAComponent() {
    result = this.getChild(_)
  }

  /** Gets the number of components in this union */
  int getNumComponents() {
    result = count(int i | exists(this.getChild(i)))
  }
}

/**
 * An intersection type expression (A&B).
 */
class PhpIntersectionType extends TS::PHP::IntersectionType {
  /** Gets a component type of this intersection */
  TS::PHP::AstNode getAComponent() {
    result = this.getChild(_)
  }

  /** Gets the number of components in this intersection */
  int getNumComponents() {
    result = count(int i | exists(this.getChild(i)))
  }
}

/**
 * Checks if a type is a DNF type (union containing intersections).
 */
predicate isDnfType(TS::PHP::UnionType ut) {
  exists(TS::PHP::IntersectionType it | it.getParent() = ut)
}

/**
 * Gets the complexity of a DNF type based on number of components.
 */
int getDnfComplexity(TS::PHP::UnionType ut) {
  result = count(TS::PHP::AstNode n | n.getParent+() = ut)
}
