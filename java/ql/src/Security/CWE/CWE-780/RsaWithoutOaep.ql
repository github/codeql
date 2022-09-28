/**
 * @name Use of RSA algorithm without OAEP
 * @description Using RSA encryption without OAEP padding can result in a padding oracle attack, leading to a weaker encryption.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id java/rsa-without-oaep
 * @tags security
 *       external/cwe/cwe-780
 */

import java
import semmle.code.java.security.RsaWithoutOaepQuery
import DataFlow::PathGraph

from RsaWithoutOaepConfig conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select source, source, sink,
  "This specification is used to initialize an RSA cipher without OAEP padding $@.", sink, "here"
