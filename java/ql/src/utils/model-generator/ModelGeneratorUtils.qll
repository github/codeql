import ModelGeneratorUtilsSpecific

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
