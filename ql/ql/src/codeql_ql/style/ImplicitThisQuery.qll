import ql

MemberCall explicitThisCallInFile(File f) {
  result.getLocation().getFile() = f and
  result.getBase() instanceof ThisAccess and
  // Exclude `this.(Type).whatever(...)`, as some files have that as their only instance of `this`.
  not result = any(InlineCast c).getBase()
}

PredicateCall implicitThisCallInFile(File f) {
  result.getLocation().getFile() = f and
  exists(result.getTarget().getDeclaringType().getASuperType()) and
  // Exclude `SomeModule::whatever(...)`
  not exists(result.getQualifier())
}

PredicateCall confusingImplicitThisCall(File f) {
  result = implicitThisCallInFile(f) and
  exists(explicitThisCallInFile(f))
}
