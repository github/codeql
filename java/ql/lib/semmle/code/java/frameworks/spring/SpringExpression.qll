/**
 * Provides classes for working with the Spring Expression Language (SpEL).
 */

import java

/**
 * Methods that trigger the evaluation of a SpEL expression.
 */
class ExpressionEvaluationMethod extends Method {
  ExpressionEvaluationMethod() {
    this.getDeclaringType().getAnAncestor() instanceof Expression and
    this.hasName(["getValue", "getValueTypeDescriptor", "getValueType", "setValue"])
  }
}

/**
 * The class `org.springframework.expression.ExpressionParser`.
 */
class ExpressionParser extends RefType {
  ExpressionParser() { this.hasQualifiedName("org.springframework.expression", "ExpressionParser") }
}

/**
 * The class `org.springframework.expression.spel.support.SimpleEvaluationContext$Builder`.
 */
class SimpleEvaluationContextBuilder extends RefType {
  SimpleEvaluationContextBuilder() {
    this.hasQualifiedName("org.springframework.expression.spel.support",
      "SimpleEvaluationContext$Builder")
  }
}

/**
 * The class `org.springframework.expression.Expression`.
 */
class Expression extends RefType {
  Expression() { this.hasQualifiedName("org.springframework.expression", "Expression") }
}

/**
 * The class `org.springframework.expression.spel.support.SimpleEvaluationContext`.
 */
class SimpleEvaluationContext extends RefType {
  SimpleEvaluationContext() {
    this.hasQualifiedName("org.springframework.expression.spel.support", "SimpleEvaluationContext")
  }
}
