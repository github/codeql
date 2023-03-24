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
import RsaWithoutOaepFlow::PathGraph

from RsaWithoutOaepFlow::PathNode source, RsaWithoutOaepFlow::PathNode sink
where RsaWithoutOaepFlow::flowPath(source, sink)
select source, source, sink, "This specification is used to $@ without OAEP padding.", sink,
  "initialize an RSA cipher"
