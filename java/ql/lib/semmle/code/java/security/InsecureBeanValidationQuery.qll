/** Provides classes and a taint tracking configuration to reason about insecure bean validation. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A message interpolator Type that perform Expression Language (EL) evaluations.
 */
private class ELMessageInterpolatorType extends RefType {
  ELMessageInterpolatorType() {
    this.getASourceSupertype*()
        .hasQualifiedName("org.hibernate.validator.messageinterpolation",
          ["ResourceBundleMessageInterpolator", "ValueFormatterMessageInterpolator"])
  }
}

/**
 * A method call that sets the application's default message interpolator.
 */
class SetMessageInterpolatorCall extends MethodCall {
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
   * Holds if the message interpolator is likely to be safe, because it does not process Java Expression Language expressions.
   */
  predicate isSafe() { not this.getAnArgument().getType() instanceof ELMessageInterpolatorType }
}

/**
 * Taint tracking BeanValidationConfiguration describing the flow of data from user input
 * to the argument of a method that builds constraint error messages.
 */
module BeanValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof BeanValidationSink }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow from user input to the argument of a method that builds constraint error messages. */
module BeanValidationFlow = TaintTracking::Global<BeanValidationConfig>;

/**
 * A bean validation sink, such as method `buildConstraintViolationWithTemplate`
 * declared on a subtype of `javax.validation.ConstraintValidatorContext`.
 */
private class BeanValidationSink extends DataFlow::Node {
  BeanValidationSink() { sinkNode(this, "bean-validation") }
}
