/**
 * @name PHP 8.1+ Readonly Properties
 * @description Analysis for readonly properties
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A readonly property declaration.
 */
class ReadonlyProperty extends TS::PHP::PropertyDeclaration {
  ReadonlyProperty() {
    exists(TS::PHP::ReadonlyModifier r | r = this.getChild(_))
  }

  /** Gets the property element */
  TS::PHP::PropertyElement getPropertyElement() {
    result = this.getChild(_)
  }

  /** Gets the type if declared */
  TS::PHP::AstNode getPropertyType() {
    result = this.getType()
  }
}

/**
 * Checks if a property is readonly.
 */
predicate isReadonlyProperty(TS::PHP::PropertyDeclaration p) {
  p instanceof ReadonlyProperty
}

/**
 * A class that has readonly properties.
 */
class ClassWithReadonlyProperties extends TS::PHP::ClassDeclaration {
  ClassWithReadonlyProperties() {
    exists(ReadonlyProperty p | p.getParent+() = this)
  }

  /** Gets a readonly property */
  ReadonlyProperty getAReadonlyProperty() {
    result.getParent+() = this
  }

  /** Gets the number of readonly properties */
  int getNumReadonlyProperties() {
    result = count(this.getAReadonlyProperty())
  }
}
