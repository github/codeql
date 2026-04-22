/**
 * Defines extensible predicates for contributing library models from data extensions.
 *
 * The extensible relations have the following columns:
 *
 * - Sources:
 *   `path; output; kind; provenance`
 * - Sinks:
 *   `path; input; kind; provenance`
 * - Summaries:
 *   `path; input; output; kind; provenance`
 *
 * The interpretation of a row is similar to API-graphs with a left-to-right
 * reading.
 *
 * 1. The `path` column selects a function with the given canonical path.
 * 2. The `input` column specifies how data enters the element selected by the
 *    first column, and the `output` column specifies how data leaves the
 *    element selected by the first column. Both `input` and `output` are
 *    `.`-separated lists of "access path tokens" to resolve, starting at the
 *    selected function.
 *
 *    The following tokens are supported:
 *     - `Argument[n]`: the `n`-th argument to a call. May be a range of form `x..y` (inclusive)
 *                      and/or a comma-separated list.
 *     - `Parameter[n]`: the `n`-th parameter of a callback. May be a range of form `x..y` (inclusive)
 *                       and/or a comma-separated list.
 *     - `ReturnValue`: the value returned by a function call.
 *     - `Element`: an element in a collection.
 *     - `Field[t::f]`: field `f` of the variant/struct with canonical path `t`, for example
 *                      `Field[ihex::Record::Data::value]`.
 *     - `Field[t(i)]`: position `i` inside the variant/struct with canonical path `v`, for example
 *                      `Field[core::option::Option::Some(0)]`.
 *     - `Field[i]`: the `i`th element of a tuple.
 *     - `Reference`: the referenced value.
 *     - `Future`: the value being computed asynchronously.
 * 3. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources `"remote"` indicates a default remote flow source, and for summaries
 *    `"taint"` indicates a default additional taint step and `"value"` indicates a
 *    globally applicable value-preserving step.
 * 4. The `provenance` column is mainly used internally, and should be set to `"manual"` for
 *    all custom models.
 */

private import rust
private import codeql.rust.dataflow.FlowSummary
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.dataflow.FlowSink

/**
 * Holds if in a call to the function with canonical path `path`, the value referred
 * to by `output` is a flow source of the given `kind` and `madId` is the data
 * extension row number.
 *
 * `output = "ReturnValue"` simply means the result of the call itself.
 *
 * For more information on the `kind` parameter, see
 * https://github.com/github/codeql/blob/main/docs/codeql/reusables/threat-model-description.rst.
 */
extensible predicate sourceModel(
  string path, string output, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if in a call to the function with canonical path `path`, the value referred
 * to by `input` is a flow sink of the given `kind` and `madId` is the data
 * extension row number.
 *
 * For example, `input = Argument[0]` means the first argument of the call.
 *
 * The sink kinds supported by queries can be found by searching for uses of
 * the `sinkNode` predicate.
 */
extensible predicate sinkModel(
  string path, string input, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if in a call to the function with canonical path `path`, the value referred
 * to by `input` can flow to the value referred to by `output` and `madId` is the data
 * extension row number.
 *
 * `kind` should be either `value` or `taint`, for value-preserving or taint-preserving
 * steps, respectively.
 */
extensible predicate summaryModel(
  string path, string input, string output, string kind, string provenance,
  QlBuiltins::ExtensionId madId
);

/**
 * Holds if a neutral model exists for the function with canonical path `path`.  The only
 * effect of a neutral model is to prevent generated and inherited models of the corresponding
 * `kind` (`source`, `sink` or `summary`) from being applied to that function.
 */
extensible predicate neutralModel(
  string path, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if the given extension tuple `madId` should pretty-print as `model`.
 *
 * This predicate should only be used in tests.
 */
predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) {
  exists(string path, string output, string kind |
    sourceModel(path, output, kind, _, madId) and
    model = "Source: " + path + "; " + output + "; " + kind
  )
  or
  exists(string path, string input, string kind |
    sinkModel(path, input, kind, _, madId) and
    model = "Sink: " + path + "; " + input + "; " + kind
  )
  or
  exists(string path, string input, string output, string kind |
    summaryModel(path, input, output, kind, _, madId) and
    model = "Summary: " + path + "; " + input + "; " + output + "; " + kind
  )
  or
  exists(string path, string kind |
    neutralModel(path, kind, _, madId) and
    model = "Neutral: " + path + "; " + kind
  )
}

private class SummarizedCallableFromModel extends SummarizedCallable::Range {
  string input_;
  string output_;
  string kind;
  Provenance p_;
  boolean isExact_;
  QlBuiltins::ExtensionId madId;

  SummarizedCallableFromModel() {
    exists(string path, Function f, Provenance p |
      summaryModel(path, input_, output_, kind, p, madId) and
      f.getCanonicalPath() = path
    |
      this = f and
      isExact_ = true and
      p_ = p
      or
      this.implements(f) and
      isExact_ = false and
      // making inherited models generated means that source code definitions and
      // exact generated models take precedence
      p_ = "hq-generated"
    )
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance p, boolean isExact, string model
  ) {
    input = input_ and
    output = output_ and
    (if kind = "value" then preservesValue = true else preservesValue = false) and
    p = p_ and
    isExact = isExact_ and
    model = "MaD:" + madId.toString()
  }
}

private class FlowSourceFromModel extends FlowSource::Range {
  private string path;

  FlowSourceFromModel() {
    sourceModel(path, _, _, _, _) and
    this.callResolvesTo(path)
  }

  override predicate isSource(string output, string kind, Provenance provenance, string model) {
    exists(QlBuiltins::ExtensionId madId |
      sourceModel(path, output, kind, provenance, madId) and
      model = "MaD:" + madId.toString()
    ) and
    // Only apply generated models when no neutral model exists
    // (the shared code only applies neutral models to summaries at present)
    not (
      provenance.isGenerated() and
      neutralModel(path, "source", _, _)
    )
  }
}

private class FlowSinkFromModel extends FlowSink::Range {
  private string path;

  FlowSinkFromModel() {
    sinkModel(path, _, _, _, _) and
    this.callResolvesTo(path)
  }

  override predicate isSink(string input, string kind, Provenance provenance, string model) {
    exists(QlBuiltins::ExtensionId madId |
      sinkModel(path, input, kind, provenance, madId) and
      model = "MaD:" + madId.toString()
    ) and
    // Only apply generated models when no neutral model exists
    // (the shared code only applies neutral models to summaries at present)
    not (
      provenance.isGenerated() and
      neutralModel(path, "sink", _, _)
    )
  }
}

private module Debug {
  private import FlowSummaryImpl
  private import Private
  private import Content
  private import codeql.rust.dataflow.internal.DataFlowImpl
  private import codeql.rust.internal.typeinference.TypeMention
  private import codeql.rust.internal.typeinference.Type

  private predicate relevantManualModel(SummarizedCallableImpl sc, string can) {
    exists(Provenance manual |
      can = sc.getCanonicalPath() and
      sc.(SummarizedCallableFromModel).propagatesFlow(_, _, _, manual, true, _) and
      manual.isManual()
    )
  }

  predicate manualModelMissingParameterReference(
    SummarizedCallableImpl sc, string can, SummaryComponentStack input, ParamBase p
  ) {
    exists(RustDataFlow::ParameterPosition pos, TypeMention tm |
      relevantManualModel(sc, can) and
      sc.propagatesFlow(input, _, _, _, _, _) and
      input.head() = SummaryComponent::argument(pos) and
      p = pos.getParameterIn(sc.getParamList()) and
      tm.getType() instanceof RefType and
      not input.tail().head() = SummaryComponent::content(TSingletonContentSet(TReferenceContent()))
    |
      tm = p.getTypeRepr()
      or
      tm = getSelfParamTypeMention(p)
    )
  }

  predicate manualModelMissingReturnReference(
    SummarizedCallableImpl sc, string can, SummaryComponentStack output
  ) {
    exists(TypeMention tm |
      relevantManualModel(sc, can) and
      sc.propagatesFlow(_, output, _, _, _, _) and
      tm.getType() instanceof RefType and
      output.head() = SummaryComponent::return(_) and
      not output.tail().head() =
        SummaryComponent::content(TSingletonContentSet(TReferenceContent())) and
      tm = getReturnTypeMention(sc) and
      not can =
        [
          "<& as core::ops::deref::Deref>::deref",
          "<&mut as core::ops::deref::Deref>::deref"
        ]
    )
  }
}
