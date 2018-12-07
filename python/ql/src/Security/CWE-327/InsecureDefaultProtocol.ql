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

FunctionObject ssl_wrap_socket() {
    result = any(ModuleObject ssl | ssl.getName() = "ssl").getAttribute("wrap_socket")
}

ClassObject ssl_Context_class() {
    result = any(ModuleObject ssl | ssl.getName() = "ssl").getAttribute("SSLContext")
}

CallNode unsafe_call(string method_name) {
    result = ssl_wrap_socket().getACall() and
    method_name = "deprecated method ssl.wrap_socket"
    or
    result = ssl_Context_class().getACall() and
    method_name = "ssl.SSLContext"
}

from CallNode call, string method_name
where 
    call = unsafe_call(method_name) and
    not exists(call.getArgByName("ssl_version"))
select call, "Call to " + method_name + " does not specify a protocol, which may result in an insecure default being used."




