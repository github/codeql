import semmle.code.cpp.commons.Printf
import external.ExternalArtifact

predicate printfLikeFunction(Function func, int formatArg) {
  formatArg = func.(FormattingFunction).getFormatParameterIndex() and
  not func instanceof UserDefinedFormattingFunction
  or
  primitiveVariadicFormatter(func, formatArg)
  or
  exists(ExternalData data |
    // TODO Do this \ to / conversion in the toolchain?
    data.getDataPath().replaceAll("\\", "/") = "cert/formatingFunction.csv" and
    func.getName() = data.getField(0) and
    formatArg = data.getFieldAsInt(1)
  )
}
