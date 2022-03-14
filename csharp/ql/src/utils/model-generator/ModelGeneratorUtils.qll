import ModelGeneratorUtilsSpecific

/**
 * Holds if data can flow from `node1` to `node2` either via a read or a write of an intermediate field `f`.
 */
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
  exists(DataFlow::Content f | storeStep(node1, f, node2) | containerContent(f))
}

/**
 * Holds if content `c` is either a field or synthetic field of a relevant type
 * or a container like content.
 */
predicate isRelevantContent(DataFlow::Content c) {
  isRelevantType(c.(DataFlow::FieldContent).getField().getType()) or
  isRelevantType(c.(DataFlow::SyntheticFieldContent).getField().getType()) or
  containerContent(c)
}

/**
 * Gets the summary model for `api` with `input`, `output` and `kind`.
 */
bindingset[input, output, kind]
string asSummaryModel(TargetApi api, string input, string output, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + output + ";" //
      + kind
}

/**
 * Gets the value summary model for `api` with `input` and `output`.
 */
bindingset[input, output]
string asValueModel(TargetApi api, string input, string output) {
  result = asSummaryModel(api, input, output, "value")
}

/**
 * Gets the taint summary model for `api` with `input` and `output`.
 */
bindingset[input, output]
string asTaintModel(TargetApi api, string input, string output) {
  result = asSummaryModel(api, input, output, "taint")
}

/**
 * Gets the sink model for `api` with `input` and `kind`.
 */
bindingset[input, kind]
string asSinkModel(TargetApi api, string input, string kind) {
  result = asPartialModel(api) + input + ";" + kind
}

/**
 * Gets the source model for `api` with `output` and `kind`.
 */
bindingset[output, kind]
string asSourceModel(TargetApi api, string output, string kind) {
  result = asPartialModel(api) + output + ";" + kind
}
