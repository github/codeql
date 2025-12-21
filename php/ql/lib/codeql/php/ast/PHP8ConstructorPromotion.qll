/**
 * @name PHP 8.0+ Constructor Parameter Promotion
 * @description Analysis for constructor parameter promotion
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A constructor parameter that has a visibility modifier (promoted property).
 * In PHP 8.0+, constructor parameters with visibility modifiers automatically
 * become class properties.
 */
class PromotedConstructorParameter extends TS::PHP::PropertyPromotionParameter {
  /** Gets the visibility modifier */
  string getVisibility() {
    result = this.getChild(_).(TS::PHP::VisibilityModifier).toString()
  }

  /** Checks if this parameter is readonly */
  predicate isReadonly() {
    exists(TS::PHP::ReadonlyModifier r | r = this.getChild(_))
  }

  /** Gets the parameter name */
  string getParameterName() {
    result = this.getName().getChild().(TS::PHP::Name).getValue()
  }
}

/**
 * Checks if a parameter is a promoted property.
 */
predicate isPromotedProperty(TS::PHP::AstNode p) {
  p instanceof PromotedConstructorParameter
}

/**
 * A constructor method that uses parameter promotion.
 */
class ConstructorWithPromotion extends TS::PHP::MethodDeclaration {
  ConstructorWithPromotion() {
    this.getName().(TS::PHP::Name).getValue() = "__construct" and
    exists(PromotedConstructorParameter p | p.getParent+() = this)
  }

  /** Gets a promoted parameter */
  PromotedConstructorParameter getAPromotedParameter() {
    result.getParent+() = this
  }

  /** Gets the number of promoted parameters */
  int getNumPromotedParameters() {
    result = count(this.getAPromotedParameter())
  }
}
