private import javascript
private import PreCallGraphStep as PCG

/**
 * Base class for calls whose first argument is an imported module.
 */
abstract private class ModuleInteropCall extends DataFlow::CallNode {
  private Import getImport() {
    this.getArgument(0).getALocalSource() = result.getImportedModuleNode()
  }

  /** Gets the module that is passed as the first argument. */
  Module getImportedModule() { result = this.getImport().getImportedModule() }

  /** Holds if the imported module is an ES2015 module or a compiled version thereof. */
  predicate isImportingESModule() {
    this.getImportedModule() instanceof ES2015Module
    or
    exists(this.getImportedModule().getAnExportedValue("__esModule"))
  }

  abstract predicate step(DataFlow::Node pred, DataFlow::Node succ);
}

/** A call that wraps the imported object in a `default` property, unless it is from an ES2015 module. */
private class InteropRequireCall extends ModuleInteropCall {
  InteropRequireCall() {
    this.getCalleeName() = ["_interopRequireDefault", "_interopRequireWildcard"]
  }

  DataFlow::SourceNode getImportedObjectRef() {
    this.isImportingESModule() and
    result = this
    or
    (not this.isImportingESModule() or this.getCalleeName() = "_interopRequireWildcard") and
    result = this.getAPropertyRead("default")
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = this.getArgument(0) and
    succ = this.getImportedObjectRef()
    or
    exists(string prop |
      pred = this.getImportedModule().getAnExportedValue(prop) and
      succ = this.getImportedObjectRef().getAPropertyRead(prop)
    )
  }
}

/**
 * A call that read the `default` property if it exists, otherwise returns the object as-is.
 */
private class InteropDefaultCall extends ModuleInteropCall {
  InteropDefaultCall() { this.getCalleeName() = "_interopDefault" }

  DataFlow::Node getDefaultExport() {
    result = this.getImportedModule().getAnExportedValue("default")
  }

  DataFlow::Node getImportedObjectSource() {
    result = this.getDefaultExport()
    or
    not exists(this.getDefaultExport()) and
    result = this.getArgument(0)
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = this.getImportedObjectSource() and
    succ = this
    or
    exists(string prop |
      pred = this.getDefaultExport().getALocalSource().getAPropertyWrite(prop).getRhs() and
      succ = this.getAPropertyRead(prop)
    )
  }
}

private class Step extends PCG::PreCallGraphStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    any(ModuleInteropCall call).step(pred, succ)
  }
}
