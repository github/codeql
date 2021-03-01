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
// This has become untrue since Python 3.2 where the `SSLContext` was introduced. Such contexts
// are designed to later be modified by flags such as `OP_NO_TLSv1_1`, and so the default values
// are not necessarity problematic.
//
// Detecting that a connection is created with a context that has not been suitably modified is
// handled by the data-flow query py/insecure-protocol, while the present query is restricted
// to alerting on the one deprecated default constructor whch does not refer to a contex, namely
// `ssl.wrap_socket`.
import python
import semmle.python.ApiGraphs

CallNode unsafe_call(string method_name) {
  result = API::moduleImport("ssl").getMember("wrap_socket").getACall().asCfgNode() and
  not exists(result.getArgByName("ssl_version")) and
  method_name = "deprecated method ssl.wrap_socket"
}

from CallNode call, string method_name
where call = unsafe_call(method_name)
select call,
  "Call to " + method_name +
    " does not specify a protocol, which may result in an insecure default being used."
