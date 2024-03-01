private import javascript
private import PreCallGraphStep as PCG

class ES2015InteropCall extends DataFlow::CallNode {
  ES2015InteropCall() {
    this.getCalleeName() = ["_interopRequireDefault", "_interopRequireWildcard"]
  }

  private Import getAnImport() {
    this.getArgument(0).getALocalSource() = result.getImportedModuleNode()
  }

  Module getImportedModule() { result = this.getAnImport().getImportedModule() }

  predicate isImportingESModule() {
    this.getImportedModule() instanceof ES2015Module
    or
    exists(this.getImportedModule().getAnExportedValue("__esModule"))
  }

  DataFlow::SourceNode getImportedObject() {
    this.isImportingESModule() and
    result = this
    or
    (not this.isImportingESModule() or this.getCalleeName() = "_interopRequireWildcard") and
    result = this.getAPropertyRead("default")
  }
}

predicate interopModuleStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(ES2015InteropCall call |
    pred = call.getArgument(0) and
    succ = call.getImportedObject()
    or
    exists(string prop |
      pred = call.getImportedModule().getAnExportedValue(prop) and
      succ = call.getImportedObject().getAPropertyRead(prop)
    )
  )
}

private class Step extends PCG::PreCallGraphStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    interopModuleStep(pred, succ)
  }
}
