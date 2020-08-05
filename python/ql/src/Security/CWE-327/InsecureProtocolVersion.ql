/**
 * @name Default version of SSL/TLS may be insecure
 * @description Leaving the SSL/TLS version unspecified may result in an insecure
 *              default protocol being used.
 * @id py/insecure-default-protocol
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import python
import semmle.python.security.Paths

ModuleValue the_ssl_module() { result = Module::named("ssl") }

ClassValue ssl_Context_class() { result = the_ssl_module().attr("SSLContext") }

FunctionValue wrap_socket() { result = ssl_Context_class().lookup("wrap_socket") }

class AllowsTLSv1 extends TaintKind {
  AllowsTLSv1() { this = "allows TLS 1.0" }
}

class AllowsTLSv1_1 extends TaintKind {
  AllowsTLSv1_1() { this = "allows TLS 1.1" }
}

private predicate isSSLContextConstructor(CallNode node) {
  node = Value::named("ssl.SSLContext").getACall()
}

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
  result = "PROTOCOL_TLS" or // could be fine since 3.6
  result = "PROTOCOL_TLSv1"
}

// TODO: this is a big table since it includes all calls with no arguments
private predicate usesDefaultValues(CallNode node) {
  not exists(node.getArgByName("protocol")) and
  not exists(node.getArg(0))
  or
  exists(AttrNode arg |
    arg = node.getArgByName("protocol")
    or
    arg = node.getArg(0)
  |
    arg.getObject(insecure_version_name()).pointsTo(the_ssl_module()) // TODO: Is it OK to use pointsto?
  )
}

class SSLContextConstructor extends TaintSource {
  SSLContextConstructor() {
    isSSLContextConstructor(this) and
    usesDefaultValues(this)
    or
    this = Value::named("ssl.create_default_context").getACall()
  }

  override predicate isSourceOf(TaintKind kind) {
    kind instanceof AllowsTLSv1
    or
    kind instanceof AllowsTLSv1_1
  }
}

class SSLContextUse extends TaintSink {
  SSLContextUse() {
    this = wrap_socket().getACall() // TODO: This does not seem to give any results?
    or
    this.(AttrNode).getName() = wrap_socket().getName()
    or
    this.(AttrNode).getName() = "load_default_certs"
    or
    this.(AttrNode).getName() = "load_cert_chain"
  }

  override predicate sinks(TaintKind kind) {
    kind instanceof AllowsTLSv1
    or
    kind instanceof AllowsTLSv1_1
  }
}

class DisallowsTLSVersion extends Sanitizer {
  DisallowsTLSVersion() { this = "disallows TLS version" }
}

class InsecureProtocolVersionConfiguration extends TaintTracking::Configuration {
  InsecureProtocolVersionConfiguration() { this = "Insecure protocol configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof SSLContextConstructor
  }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof SSLContextUse }

  override predicate isSanitizer(Sanitizer sanitizer) { sanitizer instanceof DisallowsTLSVersion }
}

/** Assume that an object stays tainted when attributes are modified */
class AttributeModificationFlow extends DataFlowExtension::DataFlowNode {
  ControlFlowNode mod;

  AttributeModificationFlow() {
    exists(BinaryExprNode bin |
      bin.getOp() instanceof BitOr and
      bin.getLeft() = this and
      this.(AttrNode).getObject() = mod
    )
  }

  override ControlFlowNode getASuccessorNode() { result = mod }
}

/** Assume that an object stays tainted when attributes are modified */
class AttributeModificationVarFlow extends DataFlowExtension::DataFlowVariable {
  ControlFlowNode use;

  AttributeModificationVarFlow() {
    exists(BinaryExpr mod |
      mod.getOp() instanceof BitOr and
      mod.getLeft().getAFlowNode() = use and
      use = this.getAUse()
    )
  }

  override ControlFlowNode getASuccessorNode() { result = use }
}

/** Assume that taint flows from argument to result for *any* call */
class AnyCallFlow extends DataFlowExtension::DataFlowNode {
  ControlFlowNode obj;
  Attribute attr;

  AnyCallFlow() {
    exists(AttrNode a |
      a = this and
      a.getNode() = attr and
      a.getName() = "load_cert_chain" and
      obj = a.getObject()
    )
  }

  override ControlFlowNode getASuccessorNode() { result = obj }
}

from
  InsecureProtocolVersionConfiguration config,
  // TaintedPathSource src, TaintedPathSink sink
  TaintTrackingNode node
where
  // config.hasFlowPath(src, sink)
  node.getConfiguration() = config
select node,
  // sink.getSink(), src, sink, "$@ is used here.", src.getSource(), "Insecure SSLContext"
  node.getNode()
