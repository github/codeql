import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.internal.ContainerFlow

class TargetAPI extends Callable {
  TargetAPI() {
    this.isPublic() and
    this.fromSource() and
    this.getDeclaringType().isPublic() and
    isRelevantForModels(this)
  }
}

private string isExtensible(RefType ref) {
  if ref.isFinal() then result = "false" else result = "true"
}

predicate isRelevantForModels(Callable api) {
  not isInTestFile(api.getCompilationUnit().getFile()) and
  not isJdkInternal(api.getCompilationUnit())
}

private predicate isInTestFile(File file) {
  file.getAbsolutePath().matches("%src/test/%") or
  file.getAbsolutePath().matches("%/guava-tests/%") or
  file.getAbsolutePath().matches("%/guava-testlib/%")
}

private predicate isJdkInternal(CompilationUnit cu) {
  cu.getPackage().getName().matches("com.sun") or
  cu.getPackage().getName().matches("sun") or
  cu.getPackage().getName().matches("")
}

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

bindingset[output, kind]
string asSourceModel(Callable api, string output, string kind) {
  result =
    asPartialModel(api) + output + ";" //
      + kind + ";" //
}

/**
 * Computes the first 6 columns for CSV rows.
 */
private string asPartialModel(Callable api) {
  result =
    asModelName(api) + ";" //
      + isExtensible(api.getDeclaringType()).toString() + ";" //
      + api.getName() + ";" //
      + paramsString(api) + ";" //
      + /* ext + */ ";" //
}

/**
 * Returns the appropriate type name for the model. Either the type
 * declaring the method or the supertype introducing the method.
 */
private string asModelName(Callable api) {
  if api.(Method).getASourceOverriddenMethod().fromSource()
  then result = typeAsModel(api.(Method).getASourceOverriddenMethod().getDeclaringType())
  else result = typeAsModel(api.getDeclaringType())
}

private string typeAsModel(RefType type) {
  result = type.getCompilationUnit().getPackage().getName() + ";" + type.nestedName()
}

string parameterAccess(Parameter p) {
  if p.getType() instanceof Array
  then result = "ArrayElement of Argument[" + p.getPosition() + "]"
  else
    if p.getType() instanceof ContainerType
    then result = "Element of Argument[" + p.getPosition() + "]"
    else result = "Argument[" + p.getPosition() + "]"
}
