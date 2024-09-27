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
     * The model is lifted in case `lift` is true.
     */
    bindingset[input, output, kind]
    private string asSummaryModel(
      Printing::SummaryApi api, string input, string output, string kind, boolean lift
    ) {
      exists(Lang::Callable c |
        lift = true and c = api.lift()
        or
        lift = false and c = api
      |
        result =
          asPartialModel(c) + input + ";" //
            + output + ";" //
            + kind + ";" //
            + Printing::getProvenance()
      )
    }

    string asNeutralSummaryModel(Printing::SummaryApi api) {
      result =
        asPartialNeutralModel(api) //
          + "summary" + ";" //
          + Printing::getProvenance()
    }

    /**
     * Gets the lifted value summary model for `api` with `input` and `output`.
     */
    bindingset[input, output]
    string asLiftedValueModel(Printing::SummaryApi api, string input, string output) {
      result = asModel(api, input, output, true, true)
    }

    /**
     * Gets the lifted taint summary model for `api` with `input` and `output`.
     */
    bindingset[input, output]
    string asLiftedTaintModel(Printing::SummaryApi api, string input, string output) {
      result = asModel(api, input, output, false, true)
    }

    /**
     * Gets the summary model for `api` with `input` and `output`.
     * (1) If `preservesValue` is true a "value" model is created.
     * (2) If `lift` is true the model is lifted to the best possible type.
     */
    bindingset[input, output, preservesValue]
    string asModel(
      Printing::SummaryApi api, string input, string output, boolean preservesValue, boolean lift
    ) {
      preservesValue = true and
      result = asSummaryModel(api, input, output, "value", lift)
      or
      preservesValue = false and
      result = asSummaryModel(api, input, output, "taint", lift)
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
