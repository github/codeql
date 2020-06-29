/**
 * Provides a predicate for identifying formatting functions like `printf`.
 *
 * Consider using the newer model in
 * `semmle.code.cpp.models.interfaces.FormattingFunction` directly instead of
 * this library.
 */

import semmle.code.cpp.commons.Printf
import external.ExternalArtifact

/**
 * Holds if `func` is a `printf`-like formatting function and `formatArg` is
 * the index of the format string argument.
 */
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
