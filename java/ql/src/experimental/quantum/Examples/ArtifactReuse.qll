import java
import semmle.code.java.dataflow.DataFlow
import experimental.quantum.Language

/**
 * Flow from any function that appears to return a value
 * to an artifact node.
 * NOTE: TODO: need to handle call by refernece for now. Need to re-evaluate (see notes below)
 * Such functions may be 'wrappers' for some derived value.
 */
private module ArtifactGeneratingWrapperConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof Call and
    // not handling references yet, I think we want to flat say references are only ok
    // if I know the source, otherwise, it has to be through an additional flow step, which
    // we filter as a source, i.e., references are only allowed as sources only,
    // no inferrece? Not sure if that would work
    // Filter out sources that are known additional flow steps, as these are likely not the
    // kind of wrapper source we are looking for.
    not exists(AdditionalFlowInputStep s | s.getOutput() = source)
  }

  // Flow through additional flow steps
  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.(AdditionalFlowInputStep).getOutput() = node2
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(Crypto::ArtifactNode i).asElement() }
}

module ArtifactGeneratingWrapperFlow = TaintTracking::Global<ArtifactGeneratingWrapperConfig>;

/**
 * Using a set approach to determine if reuse of an artifact exists.
 * This predicate produces a set of 'wrappers' that flow to the artifact node.
 * This set can be compared with the set to another artifact node to determine if they are the same.
 */
private DataFlow::Node getGeneratingWrapperSet(Crypto::NonceArtifactNode a) {
  ArtifactGeneratingWrapperFlow::flow(result, DataFlow::exprNode(a.asElement()))
  or
  result.asExpr() = a.getSourceElement()
}

private predicate ancestorOfArtifact(
  Crypto::ArtifactNode a, Callable enclosingCallable, ControlFlow::Node midOrTarget
) {
  a.asElement().(Expr).getEnclosingCallable() = enclosingCallable and
  (
    midOrTarget.asExpr() = a.asElement() or
    midOrTarget.asExpr().(Call).getCallee().calls*(a.asElement().(Expr).getEnclosingCallable())
  )
}

/**
 * Two different artifact nodes are considered reuse if any of the following conditions are met:
 * 1. The source for artifact `a` and artifact `b` are the same and the source is a literal.
 * 2. The source for artifact `a` and artifact `b` are not the same and the source is a literal of the same value.
 * 3. For all 'wrappers' that return the source of artifact `a`, and each wrapper also exists for artifact `b`.
 * 4. For all 'wrappers' that return the source of artifact `b`, and each wrapper also exists for artifact `a`.
 *
 * The above conditions determine that the use of the IV is from the same source, but the use may
 * be on separate code paths that do not occur sequentially. We must therefore also find a common callable ancestor
 * for both uses, and in that ancestor, there must be control flow from the call or use of one to the call or use of the other.
 * Note that if no shared ancestor callable exists, it means the flow is more nuanced and ignore the shared ancestor
 * use flow.
 */
predicate isArtifactReuse(Crypto::ArtifactNode a, Crypto::ArtifactNode b) {
  a != b and
  (
    a.getSourceElement() = b.getSourceElement() and a.getSourceElement() instanceof Literal
    or
    a.getSourceElement().(Literal).getValue() = b.getSourceElement().(Literal).getValue()
    or
    forex(DataFlow::Node e | e = getGeneratingWrapperSet(a) |
      exists(DataFlow::Node e2 | e2 = getGeneratingWrapperSet(b) | e = e2)
    )
    or
    forex(DataFlow::Node e | e = getGeneratingWrapperSet(b) |
      exists(DataFlow::Node e2 | e2 = getGeneratingWrapperSet(a) | e = e2)
    )
  ) and
  // If there is a common parent, there is control flow between the two uses in the parent
  // TODO: this logic needs to be examined/revisited to ensure it is correct
  (
    exists(Callable commonParent |
      ancestorOfArtifact(a, commonParent, _) and
      ancestorOfArtifact(b, commonParent, _)
    )
    implies
    exists(Callable commonParent, ControlFlow::Node aMid, ControlFlow::Node bMid |
      ancestorOfArtifact(a, commonParent, aMid) and
      ancestorOfArtifact(b, commonParent, bMid) and
      a instanceof Crypto::NonceArtifactNode and
      b instanceof Crypto::NonceArtifactNode and
      (
        aMid.getASuccessor*() = bMid
        or
        bMid.getASuccessor*() = aMid
      )
    )
  )
}
