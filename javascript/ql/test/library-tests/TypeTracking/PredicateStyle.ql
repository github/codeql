import javascript
import CustomStep

string chainableMethod() {
  result = "chain1" or
  result = "chain2"
}

DataFlow::SourceNode apiObject(DataFlow::TypeTracker t) {
  t.start() and
  result = DataFlow::moduleImport("@test/myapi").getAnInstantiation()
  or
  t.start() and
  result = apiObject(DataFlow::TypeTracker::end()).getAMethodCall(chainableMethod())
  or
  exists(DataFlow::TypeTracker t2 | result = apiObject(t2).track(t2, t))
}

query DataFlow::SourceNode apiObject() { result = apiObject(DataFlow::TypeTracker::end()) }

query DataFlow::SourceNode connection(DataFlow::TypeTracker t) {
  t.start() and
  result = apiObject().getAMethodCall("createConnection")
  or
  exists(DataFlow::TypeTracker t2 | result = connection(t2).track(t2, t))
}

DataFlow::SourceNode connection() { result = connection(DataFlow::TypeTracker::end()) }

DataFlow::SourceNode dataCallback(DataFlow::TypeBackTracker t) {
  t.start() and
  result = connection().getAMethodCall("getData").getArgument(0).getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2 | result = dataCallback(t2).backtrack(t2, t))
}

query DataFlow::SourceNode dataCallback() {
  result = dataCallback(DataFlow::TypeBackTracker::end())
}

DataFlow::SourceNode dataValue(DataFlow::TypeTracker t) {
  t.start() and
  result = dataCallback().getAFunctionValue().getParameter(0)
  or
  exists(DataFlow::TypeTracker t2 | result = dataValue(t2).track(t2, t))
}

query DataFlow::SourceNode dataValue() { result = dataValue(DataFlow::TypeTracker::end()) }

DataFlow::SourceNode reexport(DataFlow::TypeTracker t, DataFlow::FunctionNode func) {
  t.start() and
  func = result and
  func.getFile().getParentContainer().getBaseName() = "reexport"
  or
  exists(DataFlow::TypeTracker t2 | result = reexport(t2, func).track(t2, t))
}

query DataFlow::SourceNode reexport(DataFlow::FunctionNode func) {
  result = reexport(DataFlow::TypeTracker::end(), func)
}
