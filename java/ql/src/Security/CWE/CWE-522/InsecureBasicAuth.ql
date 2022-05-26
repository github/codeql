/**
 * @name Insecure basic authentication
 * @description Basic authentication only obfuscates username/password in
 *              Base64 encoding, which can be easily recognized and reversed.
 *              Transmitting sensitive information without using HTTPS makes
 *              the data vulnerable to packet sniffing.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision medium
 * @id java/insecure-basic-auth
 * @tags security
 *       external/cwe/cwe-522
 *       external/cwe/cwe-319
 */

import java
import semmle.code.java.security.InsecureBasicAuthQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, BasicAuthFlowConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Insecure basic authentication from $@.", source.getNode(),
  "HTTP URL"
