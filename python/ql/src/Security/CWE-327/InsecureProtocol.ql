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
import semmle.python.ApiGraphs

// The idea is to track flow from the creation of an insecure context to a use
// such as `wrap_socket`. There should be a data-flow path for each insecure version
// and each path should have a version specific sanitizer. This will allow fluent api
// style code to block the paths one by one.
//
// class InsecureContextCreation extends DataFlow::CfgNode {
//   override CallNode node;
//   InsecureContextCreation() {
//     this = API::moduleImport("ssl").getMember("SSLContext").getACall() and
//     insecure_version().asCfgNode() in [node.getArg(0), node.getArgByName("protocol")]
//   }
// }
// class InsecureSSLContextCreation extends DataFlow::CfgNode {
//   override CallNode node;
//   InsecureSSLContextCreation() {
//     this = API::moduleImport("ssl").getMember("create_default_context").getACall()
//     or
//     this = API::moduleImport("ssl").getMember("SSLContext").getACall() and
//     API::moduleImport("ssl").getMember("PROTOCOL_TLS").getAUse().asCfgNode() in [
//         node.getArg(0), node.getArgByName("protocol")
//       ]
//   }
// }
abstract class ContextCreation extends DataFlow::CfgNode {
  abstract DataFlow::CfgNode getProtocol();
}

class SSLContextCreation extends ContextCreation {
  override CallNode node;

  SSLContextCreation() { this = API::moduleImport("ssl").getMember("SSLContext").getACall() }

  override DataFlow::CfgNode getProtocol() {
    result.getNode() in [node.getArg(0), node.getArgByName("protocol")]
  }
}

class PyOpenSSLContextCreation extends ContextCreation {
  override CallNode node;

  PyOpenSSLContextCreation() {
    this = API::moduleImport("pyOpenSSL").getMember("SSL").getMember("Context").getACall()
  }

  override DataFlow::CfgNode getProtocol() {
    result.getNode() in [node.getArg(0), node.getArgByName("method")]
  }
}

abstract class ConnectionCreation extends DataFlow::CfgNode {
  abstract DataFlow::CfgNode getContext();
}

class WrapSocketCall extends ConnectionCreation {
  override CallNode node;

  WrapSocketCall() { node.getFunction().(AttrNode).getName() = "wrap_socket" }

  override DataFlow::CfgNode getContext() {
    result.getNode() = node.getFunction().(AttrNode).getObject()
  }
}

class ConnectionCall extends ConnectionCreation {
  override CallNode node;

  ConnectionCall() {
    this = API::moduleImport("pyOpenSSL").getMember("SSL").getMember("Connection").getACall()
  }

  override DataFlow::CfgNode getContext() {
    result.getNode() in [node.getArg(0), node.getArgByName("context")]
  }
}

abstract class TlsLibrary extends string {
  TlsLibrary() { this in ["ssl"] }

  abstract string specific_insecure_version_name();

  abstract string unspecific_version_name();

  abstract API::Node version_constants();

  DataFlow::Node insecure_version() {
    result = version_constants().getMember(specific_insecure_version_name()).getAUse()
  }

  DataFlow::Node unspecific_version() {
    result = version_constants().getMember(unspecific_version_name()).getAUse()
  }

  abstract DataFlow::CfgNode default_context_creation();

  abstract ContextCreation specific_context_creation();

  ContextCreation insecure_context_creation() {
    result = specific_context_creation() and
    result.getProtocol() = insecure_version()
  }

  DataFlow::CfgNode unspecific_context_creation() {
    result = default_context_creation()
    or
    result = specific_context_creation() and
    result.(ContextCreation).getProtocol() = unspecific_version()
  }

  abstract ConnectionCreation connection_creation();
}

class Ssl extends TlsLibrary {
  Ssl() { this = "ssl" }

  override string specific_insecure_version_name() {
    result in [
        "PROTOCOL_SSLv2", "PROTOCOL_SSLv3", "PROTOCOL_SSLv23", "PROTOCOL_TLSv1", "PROTOCOL_TLSv1_1"
      ]
  }

  override string unspecific_version_name() { result = "PROTOCOL_TLS" }

  override API::Node version_constants() { result = API::moduleImport("ssl") }

  override DataFlow::CfgNode default_context_creation() {
    result = API::moduleImport("ssl").getMember("create_default_context").getACall()
  }

  override ContextCreation specific_context_creation() { result instanceof SSLContextCreation }

  override ConnectionCreation connection_creation() { result instanceof WrapSocketCall }
}

class PyOpenSSL extends TlsLibrary {
  PyOpenSSL() { this = "pyOpenSSL" }

  override string specific_insecure_version_name() {
    result in ["SSLv2_METHOD", "SSLv23_METHOD", "SSLv3_METHOD", "TLSv1_METHOD", "TLSv1_1_METHOD"]
  }

  override string unspecific_version_name() { result = "TLS_METHOD" }

  override API::Node version_constants() {
    result = API::moduleImport("pyOpenSSL").getMember("SSL")
  }

  override DataFlow::CfgNode default_context_creation() { none() }

  override ContextCreation specific_context_creation() {
    result instanceof PyOpenSSLContextCreation
  }

  override ConnectionCreation connection_creation() { result instanceof ConnectionCall }
}

module ssl {
  string insecure_version_name() {
    result = "PROTOCOL_SSLv2" or
    result = "PROTOCOL_SSLv3" or
    result = "PROTOCOL_SSLv23" or
    result = "PROTOCOL_TLSv1" or
    result = "PROTOCOL_TLSv1_1"
  }

  DataFlow::Node insecure_version() {
    result = API::moduleImport("ssl").getMember(insecure_version_name()).getAUse()
  }
}

module pyOpenSSL {
  string insecure_version_name() {
    result = "SSLv2_METHOD" or
    result = "SSLv23_METHOD" or
    result = "SSLv3_METHOD" or
    result = "TLSv1_METHOD" or
    result = "TLSv1_1_METHOD"
  }

  DataFlow::Node insecure_version() {
    result =
      API::moduleImport("pyOpenSSL").getMember("SSL").getMember(insecure_version_name()).getAUse()
  }
}

class InsecureContextConfiguration extends DataFlow::Configuration {
  TlsLibrary library;

  InsecureContextConfiguration() { this = library + ["AllowsTLSv1", "AllowsTLSv1_1"] }

  override predicate isSource(DataFlow::Node source) {
    source = library.unspecific_context_creation()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = library.connection_creation().getContext()
  }

  abstract string flag();

  override predicate isBarrierOut(DataFlow::Node node) {
    exists(AugAssign aa, AttrNode attr |
      aa.getOperation().getOp() instanceof BitOr and
      aa.getTarget() = attr.getNode() and
      attr.getName() = "options" and
      attr.getObject() = node.asCfgNode() and
      aa.getValue() = API::moduleImport("ssl").getMember(flag()).getAUse().asExpr()
    )
  }
}

class AllowsTLSv1 extends InsecureContextConfiguration {
  AllowsTLSv1() { this = library + "AllowsTLSv1" }

  override string flag() { result = "OP_NO_TLSv1" }
}

class AllowsTLSv1_1 extends InsecureContextConfiguration {
  AllowsTLSv1_1() { this = library + "AllowsTLSv1_1" }

  override string flag() { result = "OP_NO_TLSv1_2" }
}

predicate unsafe_connection_creation(DataFlow::Node node) {
  exists(AllowsTLSv1 c | c.hasFlowTo(node)) or
  exists(AllowsTLSv1_1 c | c.hasFlowTo(node)) //or
  // node = API::moduleImport("ssl").getMember("wrap_socket").getACall()
}

predicate unsafe_context_creation(DataFlow::Node node) {
  exists(TlsLibrary l | l.insecure_context_creation() = node)
}

// class InsecureTLSContextConfiguration extends DataFlow::Configuration {
//   InsecureTLSContextConfiguration() { this in ["AllowsTLSv1", "AllowsTLSv1_1"] }
//   override predicate isSource(DataFlow::Node source) {
//     source instanceof InsecureSSLContextCreation
//   }
//   override predicate isSink(DataFlow::Node sink) { sink = any(WrapSocketCall c).getContext() }
//   abstract string flag();
//   override predicate isBarrierOut(DataFlow::Node node) {
//     exists(AugAssign aa, AttrNode attr |
//       aa.getOperation().getOp() instanceof BitOr and
//       aa.getTarget() = attr.getNode() and
//       attr.getName() = "options" and
//       attr.getObject() = node.asCfgNode() and
//       aa.getValue() = API::moduleImport("ssl").getMember(flag()).getAUse().asExpr()
//     )
//   }
// }
// class AllowsTLSv1 extends InsecureTLSContextConfiguration {
//   AllowsTLSv1() { this = "AllowsTLSv1" }
//   override string flag() { result = "OP_NO_TLSv1" }
// }
// class AllowsTLSv1_1 extends InsecureTLSContextConfiguration {
//   AllowsTLSv1_1() { this = "AllowsTLSv1_1" }
//   override string flag() { result = "OP_NO_TLSv1_1" }
// }
// predicate unsafe_wrap_socket_call(DataFlow::Node node) {
//   exists(AllowsTLSv1 c | c.hasFlowTo(node)) or
//   exists(AllowsTLSv1_1 c | c.hasFlowTo(node)) or
//   node = API::moduleImport("ssl").getMember("wrap_socket").getACall()
// }
private ModuleValue the_ssl_module() { result = Module::named("ssl") }

FunctionValue ssl_wrap_socket() { result = the_ssl_module().attr("wrap_socket") }

ClassValue ssl_Context_class() { result = the_ssl_module().attr("SSLContext") }

private ModuleValue the_pyOpenSSL_module() { result = Value::named("pyOpenSSL.SSL") }

ClassValue the_pyOpenSSL_Context_class() { result = Value::named("pyOpenSSL.SSL.Context") }

// Since version 3.6, it is fine to call `ssl.SSLContext(protocol=PROTOCOL_TLS)`
// if one also specifies either OP_NO_TLSv1 (introduced in 3.2)
// or SSLContext.minimum_version other than TLSVersion.TLSv1 (introduced in 3.7)
// See https://docs.python.org/3/library/ssl.html?highlight=ssl#ssl.SSLContext
// and https://docs.python.org/3/library/ssl.html?highlight=ssl#protocol-versions
// FP reported here: https://github.com/github/codeql/issues/2554
// string insecure_version_name() {
//   // For `pyOpenSSL.SSL`
//   result = "SSLv2_METHOD" or
//   result = "SSLv23_METHOD" or
//   result = "SSLv3_METHOD" or
//   result = "TLSv1_METHOD" or
//   // For the `ssl` module
//   result = "PROTOCOL_SSLv2" or
//   result = "PROTOCOL_SSLv3" or
//   result = "PROTOCOL_SSLv23" or
//   result = "PROTOCOL_TLSv1"
// }
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
  insecure_version = ssl::insecure_version_name() and
  (
    call.getArgByName(named_argument).pointsTo(the_ssl_module().attr(insecure_version))
    or
    probable_insecure_ssl_constant(call, insecure_version, named_argument)
  )
}

predicate unsafe_pyOpenSSL_Context_call(CallNode call, string insecure_version) {
  call = the_pyOpenSSL_Context_class().getACall() and
  insecure_version = pyOpenSSL::insecure_version_name() and
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
