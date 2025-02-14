import semmle.code.cpp.models.interfaces.FlowSource

/**
 * The `CAtlFile` class from Microsoft's Active Template Library.
 */
class CAtlTemporaryFile extends Class {
  CAtlTemporaryFile() { this.hasGlobalName("CAtlTemporaryFile") }
}

private class CAtlTemporaryFileRead extends MemberFunction, LocalFlowSourceFunction {
  CAtlTemporaryFileRead() { this.getClassAndName("Read") instanceof CAtlTemporaryFile }

  override predicate hasLocalFlowSource(FunctionOutput output, string description) {
    output.isParameterDeref(0) and
    description = "string read by " + this.getName()
  }
}
