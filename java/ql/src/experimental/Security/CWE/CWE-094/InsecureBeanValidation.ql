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
          .getASupertype+()
          .getSourceDeclaration()
          .hasQualifiedName("javax.validation", "ConstraintValidator") and
      m.hasName("isValid") and
      m.fromSource()
    )
  }

  override string getSourceType() { result = "BeanValidation source" }
}

class ExceptionTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call, TryStmt t, CatchClause c, MethodAccess gm |
      call.getEnclosingStmt().getEnclosingStmt*() = t.getBlock() and
      t.getACatchClause() = c and
      (
        call.getCallee().getAThrownExceptionType().getASubtype*() = c.getACaughtType() or
        c.getACaughtType().getASupertype*() instanceof TypeRuntimeException
      ) and
      c.getVariable().getAnAccess() = gm.getQualifier() and
      gm.getMethod().getName().regexpMatch("get(Localized)?Message|toString") and
      n1.asExpr() = call.getAnArgument() and
      n2.asExpr() = gm
    )
  }
}

class BuildConstraintViolationWithTemplateMethod extends Method {
  BuildConstraintViolationWithTemplateMethod() {
    getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("javax.validation", "ConstraintValidatorContext") and
    hasName("buildConstraintViolationWithTemplate")
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
