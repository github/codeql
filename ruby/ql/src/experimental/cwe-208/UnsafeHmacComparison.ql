private import codeql.ruby.AST
import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.ApiGraphs
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.TaintTracking
import ruby

// A call to OpenSSL::HMAC.hexdigest
class OpenSslHmacHexdigest extends DataFlow::Node {
  OpenSslHmacHexdigest() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAMethodCall("hexdigest")
  }
}

// A call to OpenSSL::HMAC.to_s (which is an alias for OpenSSL::HMAC.hexdigest)
class OpenSslHmactos extends DataFlow::Node {
  OpenSslHmactos() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAMethodCall("to_s")
  }
}

// A call to OpenSSL::HMAC.digest
class OpenSslHmacdigest extends DataFlow::Node {
  OpenSslHmacdigest() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAMethodCall("digest")
  }
}

// A call to OpenSSL::HMAC.new
class OpenSslnewHmac extends DataFlow::Node {
  OpenSslnewHmac() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAnInstantiation()
  }
}

// A call to OpenSSL::HMAC.base64digest
class OpenSslHmacbase64digest extends DataFlow::Node {
  OpenSslHmacbase64digest() {
    this = API::getTopLevelMember("OpenSSL").getMember("HMAC").getAMethodCall("base64digest")
  }
}

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "UnsafeHmacComparison" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof OpenSslHmacHexdigest or
    source instanceof OpenSslnewHmac or
    source instanceof OpenSslHmacbase64digest or
    source instanceof OpenSslHmacdigest or
    source instanceof OpenSslHmactos
  }

  // Holds if a given sink is an Equality Operation (== or !=)
  override predicate isSink(DataFlow::Node sink) {
    any(EqualityOperation eqOp).getAnOperand() = sink.asExpr().getExpr()
  }
}

from DataFlow::Node source, DataFlow::Node sink, Configuration config
where config.hasFlow(source, sink)
select sink,
  "An HMAC is being compared using the equality operator.  This may be vulnerable to a cryptographic timing attack because the equality operation does not occur in constant time."
