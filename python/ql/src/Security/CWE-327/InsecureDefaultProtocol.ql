/**
 * @name Default version of SSL/TLS may be insecure
 * @description Leaving the SSL/TLS version unspecified may result in an insecure
 *              default protocol being used.
 * @id py/insecure-default-protocol
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import python
import semmle.python.ApiGraphs

CallNode unsafe_call(string method_name) {
  result = API::moduleImport("ssl").getMember("wrap_socket").getACall().asCfgNode() and
  not exists(result.getArgByName("ssl_version")) and
  method_name = "deprecated method ssl.wrap_socket"
  or
  result = API::moduleImport("ssl").getMember("SSLContext").getACall().asCfgNode() and
  not exists(result.getArgByName("protocol")) and
  not exists(result.getArg(0)) and
  method_name = "ssl.SSLContext" and
  // in version 3.4, flags were introduced to modify cotexts created with default values
  (major_version() = 2 or major_version() = 3 and minor_version() < 4)
}

from CallNode call, string method_name
where call = unsafe_call(method_name)
select call,
  "Call to " + method_name +
    " does not specify a protocol, which may result in an insecure default being used."
