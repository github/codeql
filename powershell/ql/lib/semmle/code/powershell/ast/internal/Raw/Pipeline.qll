private import Raw

class Pipeline extends @pipeline, Chainable {
  override SourceLocation getLocation() { pipeline_location(this, result) }

  int getNumberOfComponents() { result = count(this.getAComponent()) }

  CmdBase getComponent(int i) { pipeline_component(this, i, result) }

  CmdBase getAComponent() { result = this.getComponent(_) }

  final override Ast getChild(ChildIndex i) {
    exists(int index |
      i = PipelineComp(index) and
      result = this.getComponent(index)
    )
  }
}
