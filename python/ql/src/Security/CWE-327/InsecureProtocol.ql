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

abstract class ConnectionCreation extends DataFlow::CfgNode {
  abstract DataFlow::CfgNode getContext();
}

class ProtocolRestriction extends DataFlow::CfgNode {
  abstract DataFlow::CfgNode getContext();

  abstract string getRestriction();
}

abstract class TlsLibrary extends string {
  TlsLibrary() { this in ["ssl", "pyOpenSSL"] }

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

  /** A connection is created in an outright insecure manner. */
  abstract DataFlow::CfgNode insecure_connection_creation();

  /** A connection is created from a context. */
  abstract ConnectionCreation connection_creation();

  abstract ProtocolRestriction protocol_restriction();
}

module ssl {
  class SSLContextCreation extends ContextCreation {
    override CallNode node;

    SSLContextCreation() { this = API::moduleImport("ssl").getMember("SSLContext").getACall() }

    override DataFlow::CfgNode getProtocol() {
      result.getNode() in [node.getArg(0), node.getArgByName("protocol")]
    }
  }

  class WrapSocketCall extends ConnectionCreation {
    override CallNode node;

    WrapSocketCall() { node.getFunction().(AttrNode).getName() = "wrap_socket" }

    override DataFlow::CfgNode getContext() {
      result.getNode() = node.getFunction().(AttrNode).getObject()
    }
  }

  class OptionsAugOr extends ProtocolRestriction {
    string restriction;

    OptionsAugOr() {
      exists(AugAssign aa, AttrNode attr |
        aa.getOperation().getOp() instanceof BitOr and
        aa.getTarget() = attr.getNode() and
        attr.getName() = "options" and
        attr.getObject() = node and
        aa.getValue() = API::moduleImport("ssl").getMember(restriction).getAUse().asExpr()
      )
    }

    override DataFlow::CfgNode getContext() { result = this }

    override string getRestriction() { result = restriction }
  }

  class Ssl extends TlsLibrary {
    Ssl() { this = "ssl" }

    override string specific_insecure_version_name() {
      result in [
          "PROTOCOL_SSLv2", "PROTOCOL_SSLv3", "PROTOCOL_SSLv23", "PROTOCOL_TLSv1",
          "PROTOCOL_TLSv1_1"
        ]
    }

    override string unspecific_version_name() { result = "PROTOCOL_TLS" }

    override API::Node version_constants() { result = API::moduleImport("ssl") }

    override DataFlow::CfgNode default_context_creation() {
      result = API::moduleImport("ssl").getMember("create_default_context").getACall()
    }

    override ContextCreation specific_context_creation() { result instanceof SSLContextCreation }

    override DataFlow::CfgNode insecure_connection_creation() {
      result = API::moduleImport("ssl").getMember("wrap_socket").getACall()
    }

    override ConnectionCreation connection_creation() { result instanceof WrapSocketCall }

    override ProtocolRestriction protocol_restriction() { result instanceof OptionsAugOr }
  }
}

module pyOpenSSL {
  class PyOpenSSLContextCreation extends ContextCreation {
    override CallNode node;

    PyOpenSSLContextCreation() {
      this = API::moduleImport("pyOpenSSL").getMember("SSL").getMember("Context").getACall()
    }

    override DataFlow::CfgNode getProtocol() {
      result.getNode() in [node.getArg(0), node.getArgByName("method")]
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

  class SetOptionsCall extends ProtocolRestriction {
    override CallNode node;

    SetOptionsCall() { node.getFunction().(AttrNode).getName() = "set_options" }

    override DataFlow::CfgNode getContext() {
      result.getNode() = node.getFunction().(AttrNode).getObject()
    }

    override string getRestriction() {
      API::moduleImport("PyOpenSSL").getMember("SSL").getMember(result).getAUse().asCfgNode() in [
          node.getArg(0), node.getArgByName("options")
        ]
    }
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

    override DataFlow::CfgNode insecure_connection_creation() { none() }

    override ConnectionCreation connection_creation() { result instanceof ConnectionCall }

    override ProtocolRestriction protocol_restriction() { result instanceof SetOptionsCall }
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
    exists(ProtocolRestriction r |
      r = library.protocol_restriction() and
      node = r.getContext() and
      r.getRestriction() = flag()
    )
  }
}

class AllowsTLSv1 extends InsecureContextConfiguration {
  AllowsTLSv1() { this = library + "AllowsTLSv1" }

  override string flag() { result = "OP_NO_TLSv1" }
}

class AllowsTLSv1_1 extends InsecureContextConfiguration {
  AllowsTLSv1_1() { this = library + "AllowsTLSv1_1" }

  override string flag() { result = "OP_NO_TLSv1_1" }
}

predicate unsafe_connection_creation(DataFlow::Node node, string insecure_version) {
  exists(AllowsTLSv1 c | c.hasFlowTo(node)) and
  insecure_version = "TLSv1"
  or
  exists(AllowsTLSv1_1 c | c.hasFlowTo(node)) and
  insecure_version = "TLSv1"
  or
  exists(TlsLibrary l | l.insecure_connection_creation() = node) and
  insecure_version = "[multiple]"
}

predicate unsafe_context_creation(DataFlow::Node node, string insecure_version) {
  exists(TlsLibrary l, ContextCreation cc | cc = l.insecure_context_creation() |
    cc = node and insecure_version = cc.getProtocol().toString()
  )
}

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
