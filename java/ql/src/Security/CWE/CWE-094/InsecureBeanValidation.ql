/**
 * @name Insecure Bean Validation
 * @description User-controlled data may be evaluated as a Java EL expression, leading to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/insecure-bean-validation
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/**
 * A message interpolator Type that perform Expression Language (EL) evaluations
 */
class ELMessageInterpolatorType extends RefType {
  ELMessageInterpolatorType() {
    this
        .getASourceSupertype*()
        .hasQualifiedName("org.hibernate.validator.messageinterpolation",
          ["ResourceBundleMessageInterpolator", "ValueFormatterMessageInterpolator"])
  }
}

/**
 * A method call that sets the application's default message interpolator.
 */
class SetMessageInterpolatorCall extends MethodAccess {
  SetMessageInterpolatorCall() {
    exists(Method m, RefType t |
      this.getMethod() = m and
      m.getDeclaringType().getASourceSupertype*() = t and
      (
        t.hasQualifiedName("javax.validation", ["Configuration", "ValidatorContext"]) and
        m.getName() = "messageInterpolator"
        or
        t
            .hasQualifiedName("org.springframework.validation.beanvalidation",
              ["CustomValidatorBean", "LocalValidatorFactoryBean"]) and
        m.getName() = "setMessageInterpolator"
      )
    )
  }

  /**
   * The message interpolator is likely to be safe, because it does not process Java Expression Language expressions.
   */
  predicate isSafe() { not this.getAnArgument().getType() instanceof ELMessageInterpolatorType }
}

/**
 * A method named `buildConstraintViolationWithTemplate` declared on a subtype
 * of `javax.validation.ConstraintValidatorContext`.
 */
class BuildConstraintViolationWithTemplateMethod extends Method {
  BuildConstraintViolationWithTemplateMethod() {
    this
        .getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("javax.validation", "ConstraintValidatorContext") and
    this.hasName("buildConstraintViolationWithTemplate")
  }
}

/**
 * Taint tracking BeanValidationConfiguration describing the flow of data from user input
 * to the argument of a method that builds constraint error messages.
 */
class BeanValidationConfig extends TaintTracking::Configuration {
  BeanValidationConfig() { this = "BeanValidationConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof BuildConstraintViolationWithTemplateMethod and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

from BeanValidationConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  (
    not exists(SetMessageInterpolatorCall c)
    or
    exists(SetMessageInterpolatorCall c | not c.isSafe())
  ) and
  cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Custom constraint error message contains unsanitized user data"
