import java
import semmle.code.java.dataflow.DataFlow
import experimental.Quantum.Language

/**
 * Flow from any function that appears to return a value
 * to an artifact node.
 * NOTE: TODO: need to handle call by refernece for now. Need to re-evaluate (see notes below)
 * Such functions may be 'wrappers' for some derived value.
 */
private module WrapperConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Call c |
      c = source.asExpr()
      // not handling references yet, I think we want to flat say references are only ok
      // if I know the source, otherwise, it has to be through an additional flow step, which
      // we filter as a source, i.e., references are only allowed as sources only,
      // no inferrece? Not sure if that would work
      //or
      //   source.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = c.getAnArgument()
    ) and
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

module WrapperFlow = DataFlow::Global<WrapperConfig>;

/**
 * Using a set approach to determine if reuse of an artifact exists.
 * This predicate produces a set of 'wrappers' that flow to the artifact node.
 * This set can be compared with the set to another artifact node to determine if they are the same.
 */
private DataFlow::Node getWrapperSet(Crypto::NonceArtifactNode a) {
  WrapperFlow::flow(result, DataFlow::exprNode(a.asElement()))
  or
  result.asExpr() = a.getSourceElement()
}

/**
 * Two different artifact nodes are considered reuse if any of the following conditions are met:
 * 1. The source for artifact `a` and artifact `b` are the same and the source is a literal.
 * 2. The source for artifact `a` and artifact `b` are not the same and the source is a literal of the same value.
 * 3. For all 'wrappers' that return the source of artifact `a`, and that wrapper also exists for artifact `b`.
 * 4. For all 'wrappers' that return the source of artifact `b`, and that wrapper also exists for artifact `a`.
 */
predicate isArtifactReuse(Crypto::ArtifactNode a, Crypto::ArtifactNode b) {
  a != b and
  (
    a.getSourceElement() = b.getSourceElement() and a.getSourceElement() instanceof Literal
    or
    a.getSourceElement().(Literal).getValue() = b.getSourceElement().(Literal).getValue()
    or
    forex(DataFlow::Node e | e = getWrapperSet(a) |
      exists(DataFlow::Node e2 | e2 = getWrapperSet(b) | e = e2)
    )
    or
    forex(DataFlow::Node e | e = getWrapperSet(b) |
      exists(DataFlow::Node e2 | e2 = getWrapperSet(a) | e = e2)
    )
  )
}
