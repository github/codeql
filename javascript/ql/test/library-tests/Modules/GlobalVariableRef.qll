import javascript

query predicate test_GlobalVariableRef(VarAccess access) {
  access.getVariable() instanceof GlobalVariable
}
