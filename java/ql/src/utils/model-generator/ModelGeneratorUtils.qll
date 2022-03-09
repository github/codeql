import ModelGeneratorUtilsSpecific

predicate isRelevantTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(DataFlow::Content f |
    readStep(node1, f, node2) and
    if f instanceof DataFlow::FieldContent
    then isRelevantType(f.(DataFlow::FieldContent).getField().getType())
    else
      if f instanceof DataFlow::SyntheticFieldContent
      then isRelevantType(f.(DataFlow::SyntheticFieldContent).getField().getType())
      else any()
  )
  or
  exists(DataFlow::Content f | storeStep(node1, f, node2) | DataFlow::containerContent(f))
}

predicate isRelevantContent(DataFlow::Content f) {
  isRelevantType(f.(DataFlow::FieldContent).getField().getType()) or
  isRelevantType(f.(DataFlow::FieldContent).getField().getType()) or
  DataFlow::containerContent(f)
}

bindingset[input, output, kind]
string asSummaryModel(TargetApi api, string input, string output, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + output + ";" //
      + kind
}

bindingset[input, output]
string asValueModel(TargetApi api, string input, string output) {
  result = asSummaryModel(api, input, output, "value")
}

bindingset[input, output]
string asTaintModel(TargetApi api, string input, string output) {
  result = asSummaryModel(api, input, output, "taint")
}

bindingset[input, kind]
string asSinkModel(TargetApi api, string input, string kind) {
  result = asPartialModel(api) + input + ";" + kind
}

bindingset[output, kind]
string asSourceModel(TargetApi api, string output, string kind) {
  result = asPartialModel(api) + output + ";" + kind
}
