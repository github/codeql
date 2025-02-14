import semmle.code.cpp.models.interfaces.FlowSource

/**
 * The `CAtlFile` class from Microsoft's Active Template Library.
 */
class CAtlFile extends Class {
  CAtlFile() { this.hasGlobalName("CAtlFile") }
}

private class CAtlFileRead extends MemberFunction, LocalFlowSourceFunction {
  CAtlFileRead() { this.getClassAndName("Read") instanceof CAtlFile }

  override predicate hasLocalFlowSource(FunctionOutput output, string description) {
    output.isParameterDeref(0) and
    description = "string read by " + this.getName()
  }
}
