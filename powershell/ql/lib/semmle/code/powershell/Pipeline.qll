import powershell

class Pipeline extends @pipeline, Chainable {
  override string toString() { result = "...|..." }

  override SourceLocation getLocation() { pipeline_location(this, result) }

  int getNumComponents() { pipeline(this, result) }

  CmdBase getComponent(int i) { pipeline_component(this, i, result) }

  CmdBase getAComponent() { result = this.getComponent(_) }
}
