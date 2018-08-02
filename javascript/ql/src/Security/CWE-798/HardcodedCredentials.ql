/**
 * @name Hard-coded credentials
 * @description Hard-coding credentials in source code may enable an attacker
 *              to gain unauthorized access.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import javascript
private import semmle.javascript.security.dataflow.HardcodedCredentials::HardcodedCredentials

from Configuration cfg, DataFlow::Node source, Sink sink, string value
where cfg.hasFlow(source, sink) and
      // use source value in message if it's available
      if source.asExpr() instanceof ConstantString then
        value = "The hard-coded value \"" + source.asExpr().(ConstantString).getStringValue() + "\""
      else
        value = "This hard-coded value"
select source, value + " is used as $@.", sink, sink.getKind()
