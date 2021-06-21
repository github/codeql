/**
 * @name Default version of SSL/TLS may be insecure
 * @description Leaving the SSL/TLS version unspecified may result in an insecure
 *              default protocol being used.
 * @id py/insecure-default-protocol
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

// Connections are generally created based on a context which controls the range of acceptable
// protocols. This query reports the deprecated way of creating connections without referring
// to a context (via `ssl.wrap_socket`). Doing this and not specifying which protocols are
// acceptable means that connections will be created with the insecure default settings.
//
// Detecting that a connection is created with a context that has not been suitably configured
// is handled by the data-flow query py/insecure-protocol.
import python
import semmle.python.ApiGraphs

from DataFlow::CallCfgNode call
where
  call = API::moduleImport("ssl").getMember("wrap_socket").getACall() and
  not exists(call.getArgByName("ssl_version"))
select call,
  "Call to deprecated method ssl.wrap_socket does not specify a protocol, which may result in an insecure default being used."
