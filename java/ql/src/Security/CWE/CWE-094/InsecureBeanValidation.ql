/**
 * @name Insecure Bean validation
 * @description User-controlled data may be evaluated as a Java EL expressions, leading to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-eval
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class BeanValidationSource extends RemoteFlowSource {
  BeanValidationSource() {
    exists(Method m, Parameter v |
      this.asParameter() = v and
      m.getParameter(0) = v and
      m
          .getDeclaringType()
          .getASourceSupertype+()
          .hasQualifiedName("javax.validation", "ConstraintValidator") and
      m.hasName("isValid") and
      m.fromSource()
    )
  }

  override string getSourceType() { result = "BeanValidation source" }
}

class BuildConstraintViolationWithTemplateMethod extends Method {
  BuildConstraintViolationWithTemplateMethod() {
    this.getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("javax.validation", "ConstraintValidatorContext") and
    this.hasName("buildConstraintViolationWithTemplate")
  }
}

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
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Custom constraint error message contains unsanitized user data"
