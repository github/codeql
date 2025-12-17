/**
 * @name PHP 8.3+ Attributes
 * @description Analysis for PHP 8.0+ attributes and PHP 8.3 improvements
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * An attribute usage.
 */
class PhpAttribute extends TS::PHP::Attribute {
  /** Gets the attribute name */
  string getAttributeName() {
    result = this.getChild(_).(TS::PHP::Name).getValue() or
    result = this.getChild(_).(TS::PHP::QualifiedName).toString()
  }

  /** Checks if this is the Override attribute (PHP 8.3+) */
  predicate isOverrideAttribute() {
    this.getAttributeName() in ["Override", "\\Override"]
  }
}

/**
 * An attribute group (#[Attr1, Attr2]).
 */
class AttributeGroup extends TS::PHP::AttributeGroup {
  /** Gets an attribute in this group */
  PhpAttribute getAnAttribute() {
    result = this.getChild(_)
  }

  /** Gets the number of attributes in this group */
  int getNumAttributes() {
    result = count(this.getAnAttribute())
  }
}

/**
 * A method with the Override attribute (PHP 8.3+).
 */
class OverrideMethod extends TS::PHP::MethodDeclaration {
  OverrideMethod() {
    exists(PhpAttribute attr |
      attr.getParent+() = this and
      attr.isOverrideAttribute()
    )
  }
}
