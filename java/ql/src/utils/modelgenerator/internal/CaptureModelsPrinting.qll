private import CaptureModelsSpecific

signature module PrintingSig {
  /**
   * The class of APIs relevant for model generation.
   */
  class Api extends TargetApiSpecific;

  /**
   * Gets the string representation of the provenance of the models.
   */
  string getProvenance();
}

module PrintingImpl<PrintingSig Printing> {
  /**
   * Gets the summary model for `api` with `input`, `output` and `kind`.
   */
  bindingset[input, output, kind]
  private string asSummaryModel(Printing::Api api, string input, string output, string kind) {
    result =
      asPartialModel(api) + input + ";" //
        + output + ";" //
        + kind + ";" //
        + Printing::getProvenance()
  }

  string asNeutralSummaryModel(Printing::Api api) {
    result =
      asPartialNeutralModel(api) //
        + "summary" + ";" //
        + Printing::getProvenance()
  }

  /**
   * Gets the value summary model for `api` with `input` and `output`.
   */
  bindingset[input, output]
  string asValueModel(Printing::Api api, string input, string output) {
    result = asSummaryModel(api, input, output, "value")
  }

  /**
   * Gets the taint summary model for `api` with `input` and `output`.
   */
  bindingset[input, output]
  string asTaintModel(Printing::Api api, string input, string output) {
    result = asSummaryModel(api, input, output, "taint")
  }

  /**
   * Gets the sink model for `api` with `input` and `kind`.
   */
  bindingset[input, kind]
  string asSinkModel(Printing::Api api, string input, string kind) {
    result =
      asPartialModel(api) + input + ";" //
        + kind + ";" //
        + Printing::getProvenance()
  }

  /**
   * Gets the source model for `api` with `output` and `kind`.
   */
  bindingset[output, kind]
  string asSourceModel(Printing::Api api, string output, string kind) {
    result =
      asPartialModel(api) + output + ";" //
        + kind + ";" //
        + Printing::getProvenance()
  }
}
