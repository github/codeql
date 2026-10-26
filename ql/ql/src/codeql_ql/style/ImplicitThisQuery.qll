import ql

PredicateCall implicitThisCallInFile(File f) {
  result.getLocation().getFile() = f and
  exists(result.getTarget().getDeclaringType().getASuperType()) and
  // Exclude `SomeModule::whatever(...)`
  not exists(result.getQualifier())
}

PredicateCall confusingImplicitThisCall(File f) { result = implicitThisCallInFile(f) }
