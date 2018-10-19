import csharp

class Stub extends File {
  Stub() {
    this.getAbsolutePath().matches("%resources/stubs/%")
  }
}

class SourceControlFlowElement extends ControlFlowElement {
  SourceControlFlowElement() {
    not this.getLocation().getFile() instanceof Stub
  }
}

class SourceControlFlowNode extends ControlFlow::Node {
  SourceControlFlowNode() {
    not this.getLocation().getFile() instanceof Stub
  }
}

class SourceBasicBlock extends ControlFlow::BasicBlock {
  SourceBasicBlock() {
    not this.getLocation().getFile() instanceof Stub
  }
}
