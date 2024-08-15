import powershell

class Pipeline extends @pipeline, Chainable {
  override string toString() { result = "...|..." }

  override SourceLocation getLocation() { pipeline_location(this, result) }

  int getNumComponents() { pipeline(this, result) }

  CommandBase getComponent(int i) { pipeline_component(this, i, result) }

  CommandBase getAComponent() { result = this.getComponent(_) }
}
