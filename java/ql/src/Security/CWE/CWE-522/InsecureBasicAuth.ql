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
import InsecureBasicAuthFlow::PathGraph

from InsecureBasicAuthFlow::PathNode source, InsecureBasicAuthFlow::PathNode sink
where InsecureBasicAuthFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Insecure basic authentication from a $@.", source.getNode(),
  "HTTP URL"
