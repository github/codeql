/**
 * @name Certificate validation disabled
 * @description Disabling certificate validation may impose a security risk,
 *              for example allowing for man-in-the-middle attacks.
 * @kind path-problem
 * @id cs/certificate-validation-disabled
 * @problem.severity error
 * @tags security
 *       external/cwe/cwe-295
 */

import csharp
import DataFlow
import PathGraph

/** An expression assigned to `ServicePointManager.ServerCertificateValidationCallback`. */
class CallBackExpr extends Expr {
  CallBackExpr() {
    exists(AssignableDefinition def, Property p, Expr source |
      p = def.getTargetAccess().getTarget() and
      p.hasQualifiedName("System.Net.ServicePointManager", "ServerCertificateValidationCallback") and
      source = def.getSource()
    |
      // ServicePointManager.ServerCertificateValidationCallback = ...
      this = source and
      not source instanceof OperatorCall
      or
      // ServicePointManager.ServerCertificateValidationCallback += ...
      this = source.(OperatorCall).getArgument(1)
    )
  }
}

/** A source of flow for a delegate expression. */
class DelegateFlowSource extends ExprNode {
  private Callable c;

  DelegateFlowSource() {
    this.getExpr() = any(Expr e |
        c = e.(AnonymousFunctionExpr) or
        c = e.(CallableAccess).getTarget().getSourceDeclaration()
      )
  }

  /** Gets the callable that is referenced in this delegate flow source. */
  Callable getCallable() { result = c }
}

class DelegateFlowConfiguration extends Configuration {
  DelegateFlowConfiguration() { this = "DelegateFlowConfiguration" }

  override predicate isSource(Node source) { source instanceof DelegateFlowSource }

  override predicate isSink(Node sink) { sink.asExpr() instanceof CallBackExpr }

  override predicate isAdditionalFlowStep(Node node1, Node node2) {
    node1.asExpr() = node2.asExpr().(DelegateCreation).getArgument()
  }
}

/** A certificate validation callback. */
class CallBack extends Callable {
  private DelegateFlowSource source;

  CallBack() {
    any(DelegateFlowConfiguration c).hasFlow(source, _) and
    this = source.getCallable()
  }

  /** Gets a source that references this callback. */
  DelegateFlowSource getASource() { result = source }

  /** Holds if this callback disables certificate validation. */
  predicate disablesValidation() {
    forex(Expr e | this.canReturn(e) and e.isLive() | e.(BoolLiteral).getBoolValue() = true)
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, CallBackExpr cbe, CallBack c,
  DelegateFlowConfiguration conf
where
  conf.hasFlowPath(source, sink) and
  source.getNode() = c.getASource() and
  sink.getNode().asExpr() = cbe and
  c.disablesValidation()
select cbe, source, sink, "Certificate validation disabled for $@ callback.", c, "this"
