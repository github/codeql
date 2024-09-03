import powershell

class Pipeline extends @pipeline, Chainable {
  override string toString() {
    if this.getNumberOfComponents() = 1
    then result = this.getComponent(0).toString()
    else result = "...|..."
  }

  override SourceLocation getLocation() { pipeline_location(this, result) }

  int getNumberOfComponents() { result = count(this.getAComponent()) }

  CmdBase getComponent(int i) { pipeline_component(this, i, result) }

  CmdBase getAComponent() { result = this.getComponent(_) }
}
