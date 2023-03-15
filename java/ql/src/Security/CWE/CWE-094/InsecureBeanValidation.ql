/**
 * @name Insecure Bean Validation
 * @description User-controlled data may be evaluated as a Java EL expression, leading to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id java/insecure-bean-validation
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A message interpolator Type that perform Expression Language (EL) evaluations
 */
class ELMessageInterpolatorType extends RefType {
  ELMessageInterpolatorType() {
    this.getASourceSupertype*()
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
        t.hasQualifiedName("org.springframework.validation.beanvalidation",
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
 * Taint tracking BeanValidationConfiguration describing the flow of data from user input
 * to the argument of a method that builds constraint error messages.
 */
private module BeanValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof BeanValidationSink }
}

module BeanValidationFlow = TaintTracking::Make<BeanValidationConfig>;

import BeanValidationFlow::PathGraph

/**
 * A bean validation sink, such as method `buildConstraintViolationWithTemplate`
 * declared on a subtype of `javax.validation.ConstraintValidatorContext`.
 */
private class BeanValidationSink extends DataFlow::Node {
  BeanValidationSink() { sinkNode(this, "bean-validation") }
}

from BeanValidationFlow::PathNode source, BeanValidationFlow::PathNode sink
where
  (
    not exists(SetMessageInterpolatorCall c)
    or
    exists(SetMessageInterpolatorCall c | not c.isSafe())
  ) and
  BeanValidationFlow::hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Custom constraint error message contains an unsanitized $@.",
  source, "user-provided value"
