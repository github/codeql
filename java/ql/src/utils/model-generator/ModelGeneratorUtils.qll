import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.internal.ContainerFlow

string isExtensible(RefType ref) { if ref.isFinal() then result = "false" else result = "true" }

bindingset[input, output]
string asTaintModel(Callable api, string input, string output) {
  result = asSummaryModel(api, input, output, "taint")
}

bindingset[input, output]
string asValueModel(Callable api, string input, string output) {
  result = asSummaryModel(api, input, output, "value")
}

bindingset[input, output, kind]
string asSummaryModel(Callable api, string input, string output, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + output + ";" //
      + kind + ";" //
}

bindingset[input, kind]
string asSinkModel(Callable api, string input, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + kind + ";" //
}

/**
 * Computes the first 6 columns for CSV rows.
 */
private string asPartialModel(Callable api) {
  result =
    api.getCompilationUnit().getPackage().getName() + ";" //
      + api.getDeclaringType().nestedName() + ";" //
      + isExtensible(api.getDeclaringType()).toString() + ";" //
      + api.getName() + ";" //
      + paramsString(api) + ";" //
      + /* ext + */ ";" //
}

string parameterAccess(Parameter p) {
  if p.getType() instanceof Array
  then result = "ArrayElement of Argument[" + p.getPosition() + "]"
  else
    if p.getType() instanceof ContainerType
    then result = "Element of Argument[" + p.getPosition() + "]"
    else result = "Argument[" + p.getPosition() + "]"
}
