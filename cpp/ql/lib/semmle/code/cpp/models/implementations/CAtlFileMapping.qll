import semmle.code.cpp.models.interfaces.FlowSource

/**
 * The `CAtlFileMapping` class from Microsoft's Active Template Library.
 */
class CAtlFileMapping extends Class {
  CAtlFileMapping() { this.hasGlobalName("CAtlFileMapping") }
}

/**
 * The `CAtlFileMappingBase` class from Microsoft's Active Template Library.
 */
class CAtlFileMappingBase extends Class {
  CAtlFileMappingBase() { this.hasGlobalName("CAtlFileMappingBase") }
}

private class CAtlFileMappingBaseGetData extends MemberFunction, LocalFlowSourceFunction {
  CAtlFileMappingBaseGetData() {
    this.getClassAndName("GetData") = any(CAtlFileMappingBase fileMaping).getADerivedClass*()
  }

  override predicate hasLocalFlowSource(FunctionOutput output, string description) {
    output.isReturnValueDeref(1) and
    description = "data read by " + this.getName()
  }
}

private class CAtlFileMappingGetData extends MemberFunction, LocalFlowSourceFunction {
  CAtlFileMappingGetData() {
    this.(ConversionOperator).getDeclaringType() instanceof CAtlFileMapping
  }

  override predicate hasLocalFlowSource(FunctionOutput output, string description) {
    output.isReturnValueDeref(1) and
    description = "data read by " + this.getName()
  }
}
