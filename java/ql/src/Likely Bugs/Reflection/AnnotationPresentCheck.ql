/**
 * @name AnnotationPresent check
 * @description If an annotation has not been annotated with a 'RUNTIME' retention policy, checking
 *              for its presence at runtime is not possible.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/ineffective-annotation-present-check
 * @tags correctness
 *       logic
 */

import java

from MethodCall c, Method m, ParameterizedClass p, AnnotationType t
where
  c.getMethod() = m and
  m.hasName("isAnnotationPresent") and
  m.getNumberOfParameters() = 1 and
  c.getArgument(0).getType() = p and
  p.getATypeArgument() = t and
  t.getRetentionPolicy() != "RUNTIME"
select c, "Call to isAnnotationPresent where no annotation has the RUNTIME retention policy."
