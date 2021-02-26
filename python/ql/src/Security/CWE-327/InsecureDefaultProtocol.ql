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

// This query is based on the premise that default constructors are always a security concern.
// This has become untrue since Python 3.4 where flags such as `OP_NO_TLSv1_1` were introduced
// on the `options` field to modify contexts created with default values. These flags are now,
// since OpenSSL1.1.0, themselves deprecated in favor of the `minimum_version` field (and its
// counterpart `maximum_version`).
//
// Detecting that a connection is created with a context that has not been suitably modified is
// handled by the data-flow query py/insecure-protocol, while the present query is restricted
// to alerting on default constructors when the Python version is earlier than 3.4.
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
  // in version 3.4, flags were introduced to modify contexts created with default values
  (
    major_version() = 2
    or
    major_version() = 3 and minor_version() < 4
  )
}

from CallNode call, string method_name
where call = unsafe_call(method_name)
select call,
  "Call to " + method_name +
    " does not specify a protocol, which may result in an insecure default being used."
