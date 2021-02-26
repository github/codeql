/**
 * @name Use of insecure SSL/TLS version
 * @description Using an insecure SSL/TLS version may leave the connection vulnerable to attacks.
 * @id py/insecure-protocol
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import python
import FluentApiModel

from DataFlow::Node node, string insecure_version
where
  unsafe_connection_creation(node, insecure_version)
  or
  unsafe_context_creation(node, insecure_version)
select node, "Insecure SSL/TLS protocol version " + insecure_version //+ " specified in call to " + method_name + "."
