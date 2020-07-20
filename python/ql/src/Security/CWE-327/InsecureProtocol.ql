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

private ModuleValue the_ssl_module() { result = Module::named("ssl") }

FunctionValue ssl_wrap_socket() { result = the_ssl_module().attr("wrap_socket") }

ClassValue ssl_Context_class() { result = the_ssl_module().attr("SSLContext") }

private ModuleValue the_pyOpenSSL_module() { result = Value::named("pyOpenSSL.SSL") }

ClassValue the_pyOpenSSL_Context_class() { result = Value::named("pyOpenSSL.SSL.Context") }

string insecure_version_name() {
  // For `pyOpenSSL.SSL`
  result = "SSLv2_METHOD" or
  result = "SSLv23_METHOD" or
  result = "SSLv3_METHOD" or
  result = "TLSv1_METHOD" or
  // For the `ssl` module
  result = "PROTOCOL_SSLv2" or
  result = "PROTOCOL_SSLv3" or
  result = "PROTOCOL_SSLv23" or
  result = "PROTOCOL_TLS" or
  result = "PROTOCOL_TLSv1"
}

/*
 * A syntactic check for cases where points-to analysis cannot infer the presence of
 * a protocol constant, e.g. if it has been removed in later versions of the `ssl`
 * library.
 */

bindingset[named_argument]
predicate probable_insecure_ssl_constant(
  CallNode call, string insecure_version, string named_argument
) {
  exists(ControlFlowNode arg |
    arg = call.getArgByName(named_argument) or
    arg = call.getArg(0)
  |
    arg.(AttrNode).getObject(insecure_version).pointsTo(the_ssl_module())
    or
    arg.(NameNode).getId() = insecure_version and
    exists(Import imp |
      imp.getAnImportedModuleName() = "ssl" and
      imp.getAName().getAsname().(Name).getId() = insecure_version
    )
  )
}

predicate unsafe_ssl_wrap_socket_call(
  CallNode call, string method_name, string insecure_version, string named_argument
) {
  (
    call = ssl_wrap_socket().getACall() and
    method_name = "deprecated method ssl.wrap_socket" and
    named_argument = "ssl_version"
    or
    call = ssl_Context_class().getACall() and
    named_argument = "protocol" and
    method_name = "ssl.SSLContext"
  ) and
  insecure_version = insecure_version_name() and
  (
    call.getArgByName(named_argument).pointsTo(the_ssl_module().attr(insecure_version))
    or
    probable_insecure_ssl_constant(call, insecure_version, named_argument)
  )
}

predicate unsafe_pyOpenSSL_Context_call(CallNode call, string insecure_version) {
  call = the_pyOpenSSL_Context_class().getACall() and
  insecure_version = insecure_version_name() and
  call.getArg(0).pointsTo(the_pyOpenSSL_module().attr(insecure_version))
}

from CallNode call, string method_name, string insecure_version
where
  unsafe_ssl_wrap_socket_call(call, method_name, insecure_version, _)
  or
  unsafe_pyOpenSSL_Context_call(call, insecure_version) and method_name = "pyOpenSSL.SSL.Context"
select call,
  "Insecure SSL/TLS protocol version " + insecure_version + " specified in call to " + method_name +
    "."
