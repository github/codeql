signature module ModelPrintingLangSig {
  /**
   * A class of callables.
   */
  class Callable;

  /**
   * Holds if `container`, `type`, `name`, and `parameters` contain the type signature of `api`
   * and `extensible` is the string representation of a boolean that is true, if
   * `api` can be overridden (otherwise false).
   */
  predicate partialModel(
    Callable api, string container, string type, string extensible, string name, string parameters
  );
}

module ModelPrintingImpl<ModelPrintingLangSig Lang> {
  signature module ModelPrintingSig {
    /**
     * The class of APIs relevant for model generation.
     */
    class SummaryApi extends Lang::Callable {
      Lang::Callable lift();
    }

    class SourceOrSinkApi extends Lang::Callable;

    /**
     * Gets the string representation of the provenance of the models.
     */
    string getProvenance();
  }

  module ModelPrinting<ModelPrintingSig Printing> {
    /**
     * Computes the first 6 columns for MaD rows used for summaries, sources and sinks.
     */
    private string asPartialModel(Lang::Callable api) {
      exists(string container, string type, string extensible, string name, string parameters |
        Lang::partialModel(api, container, type, extensible, name, parameters) and
        result =
          container + ";" //
            + type + ";" //
            + extensible + ";" //
            + name + ";" //
            + parameters + ";" //
            + /* ext + */ ";" //
      )
    }

    /**
     * Computes the first 4 columns for neutral MaD rows.
     */
    private string asPartialNeutralModel(Printing::SummaryApi api) {
      exists(string container, string type, string name, string parameters |
        Lang::partialModel(api, container, type, _, name, parameters) and
        result =
          container + ";" //
            + type + ";" //
            + name + ";" //
            + parameters + ";" //
      )
    }

    /**
     * Gets the summary model for `api` with `input`, `output` and `kind`.
     */
    bindingset[input, output, kind]
    private string asSummaryModel(Printing::SummaryApi api, string input, string output, string kind) {
      result =
        asPartialModel(api.lift()) + input + ";" //
          + output + ";" //
          + kind + ";" //
          + Printing::getProvenance()
    }

    string asNeutralSummaryModel(Printing::SummaryApi api) {
      result =
        asPartialNeutralModel(api) //
          + "summary" + ";" //
          + Printing::getProvenance()
    }

    /**
     * Gets the value summary model for `api` with `input` and `output`.
     */
    bindingset[input, output]
    string asValueModel(Printing::SummaryApi api, string input, string output) {
      result = asSummaryModel(api, input, output, "value")
    }

    /**
     * Gets the taint summary model for `api` with `input` and `output`.
     */
    bindingset[input, output]
    string asTaintModel(Printing::SummaryApi api, string input, string output) {
      result = asSummaryModel(api, input, output, "taint")
    }

    /**
     * Gets the sink model for `api` with `input` and `kind`.
     */
    bindingset[input, kind]
    string asSinkModel(Printing::SourceOrSinkApi api, string input, string kind) {
      result =
        asPartialModel(api) + input + ";" //
          + kind + ";" //
          + Printing::getProvenance()
    }

    /**
     * Gets the source model for `api` with `output` and `kind`.
     */
    bindingset[output, kind]
    string asSourceModel(Printing::SourceOrSinkApi api, string output, string kind) {
      result =
        asPartialModel(api) + output + ";" //
          + kind + ";" //
          + Printing::getProvenance()
    }
  }
}
