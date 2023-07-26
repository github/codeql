private import codeql.ruby.AST
import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.ApiGraphs
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.ast.Operation
import codeql.ruby.TaintTracking
import ruby

/**
 * @kind problem
 */

// A call to OpenSSL::HMAC.hexdigest
class OpenSSLHMACHexdigest extends DataFlow::Node {
  OpenSSLHMACHexdigest() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAMethodCall("hexdigest")
  }
}

// A call to OpenSSL::HMAC.to_s (which is an alias for OpenSSL::HMAC.hexdigest)
class OpenSSLHMACtos extends DataFlow::Node {
  OpenSSLHMACtos() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAMethodCall("to_s")
  }
}

// A call to OpenSSL::HMAC.digest
class OpenSSLHMACdigest extends DataFlow::Node {
  OpenSSLHMACdigest() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAMethodCall("digest")
  }
}

// A call to OpenSSL::HMAC.new
class OpenSSLnewHMAC extends DataFlow::Node {
  OpenSSLnewHMAC() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAnInstantiation()
  }
}

// A call to OpenSSL::HMAC.base64digest
class OpenSSLHmacbase64digest extends DataFlow::Node {
  OpenSSLHmacbase64digest() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAMethodCall("base64digest")
  }
}

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "UnsafeHMACComparison" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof OpenSSLHMACHexdigest or
    source instanceof OpenSSLnewHMAC or
    source instanceof OpenSSLHmacbase64digest or
    source instanceof OpenSSLHMACdigest or
    source instanceof OpenSSLHMACtos
  }

  // Holds if a given sink is an Equality Operation (== or !=)
  override predicate isSink(DataFlow::Node sink) {
    exists(EqualityOperation eqOp |
      eqOp.getLeftOperand() = sink.asExpr().getExpr()
      or
      eqOp.getRightOperand() = sink.asExpr().getExpr()
    )
  }
}

from DataFlow::Node source, DataFlow::Node sink, Configuration config
where config.hasFlow(source, sink)
select sink,
  "An HMAC is being compared using the equality operator.  This may be vulnerable to a cryptographic timing attack because the equality operation does not occur in constant time."
