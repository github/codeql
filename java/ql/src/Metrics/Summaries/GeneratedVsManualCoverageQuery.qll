private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.internal.ModelExclusions
private import TopJdkApis

/**
 * Returns the number of `ModelApi`s with Summary MaD models
 * for a given package and provenance.
 */
bindingset[package, apiSubset]
private int getNumMadModeledApis(string package, string provenance, string apiSubset) {
  provenance in ["generated", "manual", "both"] and
  result =
    count(SummarizedCallable sc |
      callableSubset(sc.asCallable(), apiSubset) and
      package = sc.asCallable().getCompilationUnit().getPackage().getName() and
      sc.asCallable() instanceof ModelApi and
      (
        // "auto-only"
        not sc.hasManualModel() and
        sc.hasGeneratedModel() and
        provenance = "generated"
        or
        sc.hasManualModel() and
        (
          if sc.hasGeneratedModel()
          then
            // "both"
            provenance = "both"
          else
            // "manual-only"
            provenance = "manual"
        )
      )
    )
}

/** Returns the total number of `ModelApi`s for a given package. */
private int getNumApis(string package, string apiSubset) {
  result =
    strictcount(ModelApi api |
      callableSubset(api, apiSubset) and
      package = api.getCompilationUnit().getPackage().getName()
    )
}

/** Holds if the given `callable` belongs to the specified `apiSubset`. */
private predicate callableSubset(Callable callable, string apiSubset) {
  apiSubset = "topJdkApis" and
  callable instanceof TopJdkApi
  or
  apiSubset = "allApis"
}

/**
 * Provides MaD summary model coverage information for the given `package`
 * on the given `apiSubset`.
 */
predicate modelCoverageGenVsMan(
  string package, int generatedOnly, int both, int manualOnly, int non, int all, float coverage,
  float generatedCoverage, float manualCoverage, float manualCoveredByGenerated,
  float generatedCoveredByManual, float match, string apiSubset
) {
  exists(int generated, int manual |
    // count the number of APIs with generated-only, both, and manual-only MaD models for each package
    generatedOnly = getNumMadModeledApis(package, "generated", apiSubset) and
    both = getNumMadModeledApis(package, "both", apiSubset) and
    manualOnly = getNumMadModeledApis(package, "manual", apiSubset) and
    // calculate the total generated and total manual numbers
    generated = generatedOnly + both and
    manual = manualOnly + both and
    // count the total number of `ModelApi`s for each package
    all = getNumApis(package, apiSubset) and
    non = all - (generatedOnly + both + manualOnly) and
    // Proportion of coverage
    coverage = (generatedOnly + both + manualOnly).(float) / all and
    generatedCoverage = generated.(float) / all and
    manualCoverage = manual.(float) / all and
    // Proportion of manual models covered by generated ones
    manualCoveredByGenerated = both.(float) / (both + manualOnly) and
    // Proportion of generated models covered by manual ones
    generatedCoveredByManual = both.(float) / (both + generatedOnly) and
    // Proportion of data points that match
    match = (both.(float) + non) / all
  )
}
