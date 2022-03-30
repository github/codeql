/**
 * @name Hard-coded credential comparison
 * @description Comparing a parameter to a hard-coded credential may compromise security.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision low
 * @id java/hardcoded-credential-comparison
 * @tags security
 *       external/cwe/cwe-798
 */

import java
import HardcodedCredentials

class EqualsAccess extends MethodAccess {
  EqualsAccess() { getMethod() instanceof EqualsMethod }
}

from EqualsAccess sink, HardcodedExpr source, PasswordVariable p
where
  source = sink.getQualifier() and
  p.getAnAccess() = sink.getArgument(0)
  or
  source = sink.getArgument(0) and
  p.getAnAccess() = sink.getQualifier()
select source, "Hard-coded value is $@ with password variable $@.", sink, "compared", p, p.getName()
