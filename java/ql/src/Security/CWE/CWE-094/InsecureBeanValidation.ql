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
import semmle.code.java.security.InsecureBeanValidationQuery
import BeanValidationFlow::PathGraph

from BeanValidationFlow::PathNode source, BeanValidationFlow::PathNode sink
where
  (
    not exists(SetMessageInterpolatorCall c)
    or
    exists(SetMessageInterpolatorCall c | not c.isSafe())
  ) and
  BeanValidationFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Custom constraint error message contains an unsanitized $@.",
  source, "user-provided value"
