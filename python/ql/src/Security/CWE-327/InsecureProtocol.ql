/**
 * @name Use of insecure SSL/TLS version
 * @description An insecure version of SSL/TLS has been specified. This may
 *              leave the connection open to attacks.
 * @id py/insecure-protocol
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

string insecure_version_name() {
    // For the `ssl` module
    result = "SSLv2_METHOD" or
    result = "SSLv23_METHOD" or
    result = "SSLv3_METHOD" or
    result = "TLSv1_METHOD" or
    // For `pyOpenSSL.SSL`
    result = "PROTOCOL_SSLv2" or
    result = "PROTOCOL_SSLv3" or
    result = "PROTOCOL_TLSv1"
}

private ModuleObject the_ssl_module() {
    result = any(ModuleObject m | m.getName() = "ssl")
}

private ModuleObject the_pyOpenSSL_module() {
    result = any(ModuleObject m | m.getName() = "pyOpenSSL").getAttribute("SSL")
}

predicate unsafe_ssl_wrap_method_call(CallNode call) {
    call = ssl_wrap_socket().getACall() and
    exists(ControlFlowNode arg | arg = call.getArgByName("ssl_version") |
        arg.(AttrNode).getObject(insecure_version_name()).refersTo(the_ssl_module())
    )
}

ClassObject the_pyOpenSSL_Context_class() {
    result = any(ModuleObject m | m.getName() = "pyOpenSSL.SSL").getAttribute("Context")
}

predicate unsafe_pyOpenSSL_Context_call(CallNode call) {
    call = the_pyOpenSSL_Context_class().getACall() and
    call.getArgByName("method").refersTo(the_pyOpenSSL_module().getAttribute(insecure_version_name()))
}

from CallNode call, string method_name
where
    unsafe_ssl_wrap_method_call(call) and method_name = "ssl.wrap_socket"
or
    unsafe_pyOpenSSL_Context_call(call) and method_name = "pyOpenSSL.SSL.Context"
select call, "Insecure SSL/TLS protocol version specified in call to " + method_name + "."
