private import javascript
private import semmle.javascript.dataflow.internal.StepSummary

private newtype TLabel =
  MkMemberLabel(PropertyName prop) or
  MkArgumentLabel(int n) { exists(any(DataFlow::InvokeNode i).getArgument(n)) } or
  MkParameterLabel(int n) { exists(any(DataFlow::FunctionNode i).getParameter(n)) }

class Label extends TLabel {
  string asMember() { this = MkMemberLabel(result) }

  int asArgumentIndex() { this = MkArgumentLabel(result) }

  int asParameterIndex() { this = MkParameterLabel(result) }

  string toString() {
    result = "Member[" + this.asMember() + "]" or
    result = "Argument[" + this.asArgumentIndex() + "]" or
    result = "Parameter[" + this.asParameterIndex() + "]"
  }
}

module API {
  private class Node = DataFlow::Node;

  predicate useToUseStep(Node node1, Label label, Node node2) {
    exists(DataFlow::PropRead read |
      node1 = read.getBase() and
      node2 = read and
      label.asMember() = read.getPropertyName()
    )
  }

  predicate defToDefStep(Node node1, Label label, Node node2) {
    exists(DataFlow::PropWrite write |
      node1 = write.getBase().getALocalSource() and
      node2 = write.getRhs() and
      label.asMember() = write.getPropertyName()
    )
  }

  predicate defToUseStep(Node node1, Label label, Node node2) {
    exists(DataFlow::FunctionNode fun, int i |
      node1 = fun and
      node2 = fun.getParameter(i) and
      label.asParameterIndex() = i
    )
  }

  predicate useToDefStep(Node node1, Label label, Node node2) {
    exists(DataFlow::InvokeNode node, int i |
      node1 = node.getCalleeNode() and
      node2 = node.getArgument(i) and
      label.asArgumentIndex() = i
    )
  }

  signature module DeepFlowInputSig {
    predicate isEntryPointUse(Node node);

    predicate isEntryPointDef(Node node);

    bindingset[node]
    predicate shouldInclude(Node node);
  }

  overlay[local?]
  module DeepFlow<DeepFlowInputSig S> {
    private import S

    private predicate isUseNodeRoot(DataFlow::SourceNode node) {
      isEntryPointUse(node)
      or
      useToUseStep(trackUse(_), _, node) and shouldInclude(node)
      or
      defToUseStep(trackDef(_), _, node) and shouldInclude(node)
    }

    DataFlow::SourceNode trackUse(DataFlow::SourceNode node, DataFlow::TypeTracker t) {
      isUseNodeRoot(node) and
      result = node and
      t.start()
      or
      exists(DataFlow::TypeTracker t2 | result = trackUse(node, t2).track(t2, t))
    }

    DataFlow::SourceNode trackUse(DataFlow::SourceNode node) {
      result = trackUse(node, DataFlow::TypeTracker::end())
    }

    private predicate isDefNodeRoot(DataFlow::Node node) {
      isEntryPointDef(node)
      or
      useToDefStep(trackUse(_), _, node) and shouldInclude(node)
      or
      defToDefStep(trackDef(_), _, node) and shouldInclude(node)
    }

    DataFlow::SourceNode trackDef(DataFlow::Node node, DataFlow::TypeBackTracker t) {
      isDefNodeRoot(node) and
      result = node.getALocalSource() and
      t.start()
      or
      exists(DataFlow::TypeBackTracker t2 | result = trackDef(node, t2).backtrack(t2, t))
    }

    DataFlow::SourceNode trackDef(DataFlow::Node node) {
      result = trackDef(node, DataFlow::TypeBackTracker::end())
    }
  }

  private module Input1 implements DeepFlowInputSig {
    predicate isEntryPointUse(Node node) {
      exists(Import imprt |
        imprt.getImportedPathString().regexpMatch("[^./].*") and
        node = imprt.getImportedModuleNode()
      )
    }

    predicate isEntryPointDef(Node node) {
      exists(PackageJson pkg |
        not pkg.isPrivate() and
        node =
          [pkg.getMainModule().getAnExportedValue(_), pkg.getMainModule().getABulkExportedNode()]
      )
    }

    bindingset[node]
    predicate shouldInclude(Node node) { any() }
  }

  private module DeepFlow1 = DeepFlow<Input1>;

  overlay[local]
  DataFlow::SourceNode trackUseLocal(DataFlow::SourceNode node) =
    forceLocal(DeepFlow1::trackUse/1)(node, result)

  overlay[local]
  DataFlow::SourceNode trackDefLocal(DataFlow::Node node) =
    forceLocal(DeepFlow1::trackDef/1)(node, result)

  bindingset[node]
  overlay[global]
  pragma[inline_late]
  private predicate isInOverlayChangedFile(DataFlow::Node node) {
    overlayChangedFiles(node.getFile().getAbsolutePath())
  }

  predicate stepIntoOverlay(Node node1, Node node2, StepSummary summary) {
    StepSummary::smallstep(node1, node2, summary) and
    not isInOverlayChangedFile(node1) and
    isInOverlayChangedFile(node2)
  }

  predicate stepOutOfOverlay(Node node1, Node node2, StepSummary summary) {
    StepSummary::smallstep(node1, node2, summary) and
    isInOverlayChangedFile(node1) and
    not isInOverlayChangedFile(node2)
  }

  private module Input2 implements DeepFlowInputSig {
    predicate isEntryPointUse(Node node) {
      stepIntoOverlay(trackUseLocal(node).getALocalUse(), _, _)
    }

    predicate isEntryPointDef(Node node) { stepOutOfOverlay(_, trackDefLocal(node), _) }

    predicate shouldInclude(Node node) { isInOverlayChangedFile(node) }
  }

  private module DeepFlow2 = DeepFlow<Input2>;

  DataFlow::SourceNode trackUseFinal(DataFlow::SourceNode node) {
    result = DeepFlow1::trackUse(node)
    or
    result = DeepFlow2::trackUse(node)
  }

  DataFlow::SourceNode trackDefFinal(DataFlow::Node node) {
    result = DeepFlow1::trackDef(node)
    or
    result = DeepFlow2::trackDef(node)
  }

  module Debug {
    query DataFlow::SourceNode trackUseLostAfterForceLocal(DataFlow::SourceNode node) {
      result = DeepFlow1::trackUse(node) and
      not result = trackUseLocal(node)
    }

    query DataFlow::SourceNode trackDefLostAfterForceLocal(DataFlow::Node node) {
      result = DeepFlow1::trackDef(node) and
      not result = trackDefLocal(node)
    }

    query predicate trackUseSecondPass = DeepFlow2::trackUse/1;

    query predicate trackDefSecondPass = DeepFlow2::trackDef/1;

    query DataFlow::SourceNode trackUseLost(DataFlow::SourceNode node) {
      result = DeepFlow1::trackUse(node) and
      not result = trackUseFinal(node)
    }

    query DataFlow::SourceNode trackDefLost(DataFlow::Node node) {
      result = DeepFlow1::trackDef(node) and
      not result = trackDefFinal(node)
    }

    query DataFlow::SourceNode trackUseGained(DataFlow::SourceNode node) {
      not result = DeepFlow1::trackUse(node) and
      result = trackUseFinal(node)
    }

    query DataFlow::SourceNode trackDefGained(DataFlow::Node node) {
      not result = DeepFlow1::trackDef(node) and
      result = trackDefFinal(node)
    }
  }
}
