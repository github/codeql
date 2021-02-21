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

// string foo(ProtocolRestriction r) { result = r.getRestriction() }
// The idea is to track flow from the creation of an insecure context to a use
// such as `wrap_socket`. There should be a data-flow path for each insecure version
// and each path should have a version specific sanitizer. This will allow fluent api
// style code to block the paths one by one.
from DataFlow::Node node, string insecure_version
where
  unsafe_connection_creation(node, insecure_version)
  or
  unsafe_context_creation(node, insecure_version)
select node, "Insecure SSL/TLS protocol version " + insecure_version //+ " specified in call to " + method_name + "."
// from CallNode call, string method_name, string insecure_version
// where
//   unsafe_ssl_wrap_socket_call(call, method_name, insecure_version, _)
//   or
//   unsafe_pyOpenSSL_Context_call(call, insecure_version) and method_name = "pyOpenSSL.SSL.Context"
// select call,
//   "Insecure SSL/TLS protocol version " + insecure_version + " specified in call to " + method_name +
//     "."
