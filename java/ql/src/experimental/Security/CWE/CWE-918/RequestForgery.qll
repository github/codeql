import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow
import DataFlow::PathGraph
import JavaURL as JavaURL
import GoogleHTTPClient as GoogleHTTPClient
import JxRs as JxRs
import SpringRestTemplate as SpringRestTemplate

abstract class UnsafeURLFlowConfiguration extends DataFlow::Configuration {
  bindingset[this]
  UnsafeURLFlowConfiguration() { any() }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    JavaURL::isUnsafeURLFlowSink(node)
    or
    GoogleHTTPClient::isUnsafeURLFlowSink(node)
    or
    JxRs::isUnsafeURLFlowSink(node)
    or
    SpringRestTemplate::isUnsafeURLFlowSink(node)
  }

  override predicate isBarrier(DataFlow::Node node) { TaintTracking::defaultTaintBarrier(node) }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    this.isAdditionalTaintStep(node1, node2)
    or
    TaintTracking::defaultAdditionalTaintStep(node1, node2) and
    not this.blockAdditionalTaintStep(node1, node2)
  }

  abstract predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2);

  predicate blockAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) { none() }
}

predicate endsLikeProtocol(Expr expr) {
  exists(string str | str = expr.(StringLiteral).getRepresentedString() | str.matches("%://"))
  or
  exists(Variable var | expr = var.getAnAccess() | endsLikeProtocol(var.getAnAssignedValue()))
  or
  endsLikeProtocol(expr.(AddExpr).getRightOperand())
}

class UnsafeURLSpecFlowConfiguration extends UnsafeURLFlowConfiguration {
  UnsafeURLSpecFlowConfiguration() { this = "RequestForgery::UnsafeURLSpecFlowConfiguration" }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    JavaURL::unsafeURLSpecFlowTaintStep(node1, node2)
    or
    GoogleHTTPClient::unsafeURLSpecFlowTaintStep(node1, node2)
    or
    JxRs::unsafeURLSpecFlowTaintStep(node1, node2)
    or
    SpringRestTemplate::unsafeURLSpecFlowTaintStep(node1, node2)
  }

  override predicate blockAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(AddExpr e |
      node2.asExpr() = e and
      // user controlled suffix in URL spec is usually okay
      e.getRightOperand() = node1.asExpr() and
      // left operand ending with :// usually means it is only protocol part
      not endsLikeProtocol(e.getLeftOperand())
    )
  }
}

class UnsafeURLHostFlowConfiguration extends UnsafeURLFlowConfiguration {
  UnsafeURLHostFlowConfiguration() { this = "RequestForgery::UnsafeURLHostFlowConfiguration" }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    JavaURL::unsafeURLHostFlowTaintStep(node1, node2)
    or
    GoogleHTTPClient::unsafeURLHostFlowTaintStep(node1, node2)
    or
    JxRs::unsafeURLHostFlowTaintStep(node1, node2)
    or
    SpringRestTemplate::unsafeURLHostFlowTaintStep(node1, node2)
  }

  override predicate blockAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // user controlled prefix in URL host is usually okay
    node2.asExpr().(AddExpr).getLeftOperand() = node1.asExpr()
  }
}
