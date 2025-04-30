signature module ModelPrintingLangSig {
  /**
   * A class of callables.
   */
  class Callable;

  /**
   * Gets the string representation for the `i`th column in the MaD row for `api`.
   */
  string partialModelRow(Callable api, int i);

  /**
   * Gets the string representation for the `i`th column in the neutral MaD row for `api`.
   */
  string partialNeutralModelRow(Callable api, int i);
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
     * Computes the first columns for MaD rows used for summaries, sources and sinks.
     */
    private string asPartialModel(Lang::Callable api) {
      result = strictconcat(int i | | Lang::partialModelRow(api, i), ";" order by i) + ";"
    }

    /**
     * Computes the first columns for neutral MaD rows.
     */
    private string asPartialNeutralModel(Printing::SummaryApi api) {
      result = strictconcat(int i | | Lang::partialNeutralModelRow(api, i), ";" order by i) + ";"
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
