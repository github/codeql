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

FunctionValue ssl_wrap_socket() { result = Value::named("ssl.wrap_socket") }

ClassValue ssl_Context_class() { result = Value::named("ssl.SSLContext") }

CallNode unsafe_call(string method_name) {
  result = ssl_wrap_socket().getACall() and
  not exists(result.getArgByName("ssl_version")) and
  method_name = "deprecated method ssl.wrap_socket"
  or
  result = ssl_Context_class().getACall() and
  not exists(result.getArgByName("protocol")) and
  not exists(result.getArg(0)) and
  method_name = "ssl.SSLContext"
}

from CallNode call, string method_name
where call = unsafe_call(method_name)
select call,
  "Call to " + method_name +
    " does not specify a protocol, which may result in an insecure default being used."
