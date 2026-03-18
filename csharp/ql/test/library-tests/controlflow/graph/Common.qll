import csharp

class StubFile extends File {
  StubFile() { this.getAbsolutePath().matches("%resources/stubs/%") }
}

class SourceControlFlowElement extends ControlFlowElement {
  SourceControlFlowElement() {
    this.fromSource() and not this.getLocation().getFile() instanceof StubFile
  }
}

class SourceControlFlowNode extends ControlFlowNode {
  SourceControlFlowNode() {
    not this.getLocation().getFile() instanceof StubFile and
    not this.getLocation().getFile().fromLibrary()
  }
}

class SourceBasicBlock extends BasicBlock {
  SourceBasicBlock() {
    not this.getLocation().getFile() instanceof StubFile and
    not this.getLocation().getFile().fromLibrary()
  }
}
