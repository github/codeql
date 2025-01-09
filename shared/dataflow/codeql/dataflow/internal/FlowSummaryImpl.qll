/**
 * Provides classes and predicates for defining flow summaries.
 */

private import codeql.dataflow.DataFlow as DF
private import codeql.util.Location
private import AccessPathSyntax as AccessPathSyntax

/**
 * Provides language-specific parameters.
 */
signature module InputSig<LocationSig Location, DF::InputSig<Location> Lang> {
  /**
   * A base class of callables that are candidates for flow summary modeling.
   */
  bindingset[this]
  class SummarizedCallableBase {
    bindingset[this]
    string toString();
  }

  /**
   * A base class of elements that are candidates for flow source modeling.
   */
  bindingset[this]
  class SourceBase {
    bindingset[this]
    string toString();
  }

  /**
   * A base class of elements that are candidates for flow sink modeling.
   */
  bindingset[this]
  class SinkBase {
    bindingset[this]
    string toString();
  }

  /**
   * Holds if a neutral (MaD) model exists for `c` of kind `kind`
   * with provenance `provenance` and `isExact` is true if the model
   * signature matches `c` exactly - otherwise false.
   */
  default predicate neutralElement(
    SummarizedCallableBase c, string kind, string provenance, boolean isExact
  ) {
    none()
  }

  /** Gets the parameter position representing a callback itself, if any. */
  default Lang::ArgumentPosition callbackSelfParameterPosition() { none() }

  /** Gets the return kind corresponding to specification `"ReturnValue"`. */
  Lang::ReturnKind getStandardReturnValueKind();

  /** Gets the textual representation of parameter position `pos` used in MaD. */
  string encodeParameterPosition(Lang::ParameterPosition pos);

  /** Gets the textual representation of argument position `pos` used in MaD. */
  string encodeArgumentPosition(Lang::ArgumentPosition pos);

  /**
   * Gets the textual representation of content `c` used in MaD.
   *
   * `arg` will be printed in square brackets (`[]`) after the result, unless
   * `arg` is the empty string.
   */
  default string encodeContent(Lang::ContentSet c, string arg) { none() }

  /**
   * Gets the textual representation of return kind `rk` used in MaD.
   *
   * `arg` will be printed in square brackets (`[]`) after the result, unless
   * `arg` is the empty string.
   */
  default string encodeReturn(Lang::ReturnKind rk, string arg) { none() }

  /**
   * Gets the textual representation of without-content `c` used in MaD.
   *
   * `arg` will be printed in square brackets (`[]`) after the result, unless
   * `arg` is the empty string.
   */
  default string encodeWithoutContent(Lang::ContentSet c, string arg) { none() }

  /**
   * Gets the textual representation of with-content `c` used in MaD.
   *
   * `arg` will be printed in square brackets (`[]`) after the result, unless
   * `arg` is the empty string.
   */
  default string encodeWithContent(Lang::ContentSet c, string arg) { none() }

  /**
   * Gets a parameter position corresponding to the unknown token `token`.
   *
   * The token is unknown because it could not be reverse-encoded using the
   * `encodeParameterPosition` predicate. This is useful for example when a
   * single token gives rise to multiple parameter positions, such as ranges
   * `0..n`.
   */
  bindingset[token]
  default Lang::ParameterPosition decodeUnknownParameterPosition(
    AccessPathSyntax::AccessPathTokenBase token
  ) {
    none()
  }

  /**
   * Gets an argument position corresponding to the unknown token `token`.
   *
   * The token is unknown because it could not be reverse-encoded using the
   * `encodeArgumentPosition` predicate. This is useful for example when a
   * single token gives rise to multiple argument positions, such as ranges
   * `0..n`.
   */
  bindingset[token]
  default Lang::ArgumentPosition decodeUnknownArgumentPosition(
    AccessPathSyntax::AccessPathTokenBase token
  ) {
    none()
  }

  /**
   * Gets a content corresponding to the unknown token `token`.
   *
   * The token is unknown because it could not be reverse-encoded using the
   * `encodeContent` predicate.
   */
  bindingset[token]
  default Lang::ContentSet decodeUnknownContent(AccessPathSyntax::AccessPathTokenBase token) {
    none()
  }

  /**
   * Gets a return kind corresponding to the unknown token `token`.
   *
   * The token is unknown because it could not be reverse-encoded using the
   * `encodeReturn` predicate.
   */
  bindingset[token]
  default Lang::ReturnKind decodeUnknownReturn(AccessPathSyntax::AccessPathTokenBase token) {
    none()
  }

  /**
   * Gets a without-content corresponding to the unknown token `token`.
   *
   * The token is unknown because it could not be reverse-encoded using the
   * `encodeWithoutContent` predicate.
   */
  bindingset[token]
  default Lang::ContentSet decodeUnknownWithoutContent(AccessPathSyntax::AccessPathTokenBase token) {
    none()
  }

  /**
   * Gets a with-content corresponding to the unknown token `token`.
   *
   * The token is unknown because it could not be reverse-encoded using the
   * `encodeWithContent` predicate.
   */
  bindingset[token]
  default Lang::ContentSet decodeUnknownWithContent(AccessPathSyntax::AccessPathTokenBase token) {
    none()
  }
}

module Make<
  LocationSig Location, DF::InputSig<Location> DataFlowLang, InputSig<Location, DataFlowLang> Input>
{
  private import DataFlowLang
  private import Input
  private import codeql.dataflow.internal.DataFlowImplCommon::MakeImplCommon<Location, DataFlowLang>
  private import codeql.util.Unit

  final private class SummarizedCallableBaseFinal = SummarizedCallableBase;

  final private class SourceBaseFinal = SourceBase;

  final private class SinkBaseFinal = SinkBase;

  /** Provides classes and predicates for defining flow summaries. */
  module Public {
    private import Private

    /**
     * Gets the valid model origin values.
     */
    private string getValidModelOrigin() {
      result =
        [
          "ai", // AI (machine learning)
          "df", // Dataflow (model generator)
          "dfc", // Content dataflow (model generator)
          "tb", // Type based (model generator)
          "hq", // Heuristic query
        ]
    }

    /**
     * A class used to represent provenance values for MaD models.
     *
     * The provenance value is a string of the form `origin-verification`
     * (or just `manual`), where `origin` is a value indicating the
     * origin of the model, and `verification` is a value indicating, how
     * the model was verified.
     *
     * Examples could be:
     * - `df-generated`: A model produced by the model generator, but not verified by a human.
     * - `ai-manual`: A model produced by AI, but verified by a human.
     */
    class Provenance extends string {
      private string verification;

      Provenance() {
        exists(string origin | origin = getValidModelOrigin() |
          this = origin + "-" + verification and
          verification = ["manual", "generated"]
        )
        or
        this = verification and verification = "manual"
      }

      /**
       * Holds if this is a valid generated provenance value.
       */
      predicate isGenerated() { verification = "generated" }

      /**
       * Holds if this is a valid manual provenance value.
       */
      predicate isManual() { verification = "manual" }
    }

    /** A callable with a flow summary. */
    abstract class SummarizedCallable extends SummarizedCallableBaseFinal {
      bindingset[this]
      SummarizedCallable() { any() }

      /**
       * Holds if data may flow from `input` to `output` through this callable.
       *
       * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
       *
       * If `model` is non-empty then it indicates the provenance of the model
       * defining this flow.
       */
      pragma[nomagic]
      abstract predicate propagatesFlow(
        string input, string output, boolean preservesValue, string model
      );

      /**
       * Holds if there exists a generated summary that applies to this callable.
       */
      final predicate hasGeneratedModel() {
        exists(Provenance p | p.isGenerated() and this.hasProvenance(p))
      }

      /**
       * Holds if all the summaries that apply to this callable are auto generated and not manually created.
       * That is, only apply generated models, when there are no manual models.
       */
      final predicate applyGeneratedModel() {
        this.hasGeneratedModel() and
        not this.hasManualModel()
      }

      /**
       * Holds if there exists a manual summary that applies to this callable.
       */
      final predicate hasManualModel() {
        exists(Provenance p | p.isManual() and this.hasProvenance(p))
      }

      /**
       * Holds if there exists a manual summary that applies to this callable.
       * Always apply manual models if they exist.
       */
      final predicate applyManualModel() { this.hasManualModel() }

      /**
       * Holds if there exists a summary that applies to this callable
       * that has provenance `provenance`.
       */
      predicate hasProvenance(Provenance provenance) { provenance = "manual" }

      /**
       * Holds if there exists a model for which this callable is an exact
       * match, that is, no overriding was used to identify this callable from
       * the model.
       */
      predicate hasExactModel() { none() }
    }

    /** A source element. */
    abstract class SourceElement extends SourceBaseFinal {
      bindingset[this]
      SourceElement() { any() }

      /**
       * Holds if this element is a flow source of kind `kind`, where data
       * flows out as described by `output`.
       */
      pragma[nomagic]
      abstract predicate isSource(string output, string kind, Provenance provenance, string model);
    }

    /** A sink element. */
    abstract class SinkElement extends SinkBaseFinal {
      bindingset[this]
      SinkElement() { any() }

      /**
       * Holds if this element is a flow sink of kind `kind`, where data
       * flows in as described by `input`.
       */
      pragma[nomagic]
      abstract predicate isSink(string input, string kind, Provenance provenance, string model);
    }

    private signature predicate hasKindSig(string kind);

    signature class NeutralCallableSig extends SummarizedCallableBaseFinal {
      /**
       * Holds if the neutral has provenance `p`.
       */
      predicate hasProvenance(Provenance p);

      /**
       * Gets the kind of the neutral.
       */
      string getKind();

      /**
       * Holds if the neutral is auto generated.
       */
      predicate hasGeneratedModel();

      /**
       * Holds if there exists a manual neutral that applies to this callable.
       */
      predicate hasManualModel();
    }

    /**
     * A module for constructing classes of neutral callables.
     */
    private module MakeNeutralCallable<hasKindSig/1 hasKind> {
      class NeutralCallable extends SummarizedCallableBaseFinal {
        private string kind;
        private string provenance_;
        private boolean exact;

        NeutralCallable() {
          hasKind(kind) and
          neutralElement(this, kind, provenance_, exact)
        }

        /**
         * Gets the kind of the neutral.
         */
        string getKind() { result = kind }

        /**
         * Holds if the neutral has provenance `p`.
         */
        predicate hasProvenance(Provenance provenance) { provenance = provenance_ }

        /**
         * Holds if the neutral is auto generated.
         */
        final predicate hasGeneratedModel() {
          any(Provenance p | this.hasProvenance(p)).isGenerated()
        }

        /**
         * Holds if there exists a manual neutral that applies to this callable.
         */
        final predicate hasManualModel() { any(Provenance p | this.hasProvenance(p)).isManual() }

        /**
         * Holds if there exists a model for which this callable is an exact
         * match, that is, no overriding was used to identify this callable from
         * the model.
         */
        predicate hasExactModel() { exact = true }
      }
    }

    private predicate neutralSummaryKind(string kind) { kind = "summary" }

    /**
     * A callable where there exists a MaD neutral summary model that applies to it.
     */
    class NeutralSummaryCallable = MakeNeutralCallable<neutralSummaryKind/1>::NeutralCallable;

    private predicate neutralSourceKind(string kind) { kind = "source" }

    /**
     * A callable where there exists a MaD neutral source model that applies to it.
     */
    class NeutralSourceCallable = MakeNeutralCallable<neutralSourceKind/1>::NeutralCallable;

    private predicate neutralSinkKind(string kind) { kind = "sink" }

    /**
     * A callable where there exists a MaD neutral sink model that applies to it.
     */
    class NeutralSinkCallable = MakeNeutralCallable<neutralSinkKind/1>::NeutralCallable;

    /**
     * A callable where there exist a MaD neutral (summary, source or sink) model
     * that applies to it.
     */
    class NeutralCallable extends SummarizedCallableBaseFinal {
      NeutralCallable() {
        this instanceof NeutralSummaryCallable or
        this instanceof NeutralSourceCallable or
        this instanceof NeutralSinkCallable
      }
    }
  }

  /**
   * Provides predicates for compiling flow summaries down to atomic local steps,
   * read steps, and store steps.
   */
  module Private {
    private import Public

    /**
     * A synthetic global. This represents some form of global state, which
     * summaries can read and write individually.
     */
    abstract class SyntheticGlobal extends string {
      bindingset[this]
      SyntheticGlobal() { any() }
    }

    private newtype TSummaryComponent =
      TContentSummaryComponent(ContentSet c) or
      TParameterSummaryComponent(ArgumentPosition pos) or
      TArgumentSummaryComponent(ParameterPosition pos) or
      TReturnSummaryComponent(ReturnKind rk) or
      TSyntheticGlobalSummaryComponent(SyntheticGlobal sg) or
      TWithoutContentSummaryComponent(ContentSet c) or
      TWithContentSummaryComponent(ContentSet c)

    bindingset[name, arg]
    private string encodeArg(string name, string arg) {
      if arg = "" then result = name else result = name + "[" + arg + "]"
    }

    /**
     * A component used in a flow summary.
     *
     * Either a parameter or an argument at a given position, a specific
     * content type, or a return kind.
     */
    class SummaryComponent instanceof TSummaryComponent {
      /** Gets a textual representation of this component used for MaD models. */
      string getMadRepresentation() {
        exists(ContentSet c, string arg |
          this = TContentSummaryComponent(c) and
          result = encodeArg(encodeContent(c, arg), arg)
        )
        or
        exists(ArgumentPosition pos |
          this = TParameterSummaryComponent(pos) and
          result = "Parameter[" + encodeArgumentPosition(pos) + "]"
        )
        or
        exists(ParameterPosition pos |
          this = TArgumentSummaryComponent(pos) and
          result = "Argument[" + encodeParameterPosition(pos) + "]"
        )
        or
        exists(string synthetic |
          this = TSyntheticGlobalSummaryComponent(synthetic) and
          result = "SyntheticGlobal[" + synthetic + "]"
        )
        or
        exists(ReturnKind rk | this = TReturnSummaryComponent(rk) |
          rk = getStandardReturnValueKind() and result = "ReturnValue"
          or
          exists(string arg | result = encodeArg(encodeReturn(rk, arg), arg))
        )
        or
        exists(ContentSet c, string arg |
          this = TWithoutContentSummaryComponent(c) and
          result = encodeArg(encodeWithoutContent(c, arg), arg)
        )
        or
        exists(ContentSet c, string arg |
          this = TWithContentSummaryComponent(c) and
          result = encodeArg(encodeWithContent(c, arg), arg)
        )
      }

      /** Gets a textual representation of this summary component. */
      string toString() { result = this.getMadRepresentation() }
    }

    /** Provides predicates for constructing summary components. */
    module SummaryComponent {
      /** Gets a summary component for content `c`. */
      SummaryComponent content(ContentSet c) { result = TContentSummaryComponent(c) }

      /** Gets a summary component where data is not allowed to be stored in `c`. */
      SummaryComponent withoutContent(ContentSet c) { result = TWithoutContentSummaryComponent(c) }

      /** Gets a summary component where data must be stored in `c`. */
      SummaryComponent withContent(ContentSet c) { result = TWithContentSummaryComponent(c) }

      /** Gets a summary component for a parameter at position `pos`. */
      SummaryComponent parameter(ArgumentPosition pos) { result = TParameterSummaryComponent(pos) }

      /** Gets a summary component for an argument at position `pos`. */
      SummaryComponent argument(ParameterPosition pos) { result = TArgumentSummaryComponent(pos) }

      /** Gets a summary component for a return of kind `rk`. */
      SummaryComponent return(ReturnKind rk) { result = TReturnSummaryComponent(rk) }

      /** Gets a summary component for synthetic global `sg`. */
      SummaryComponent syntheticGlobal(SyntheticGlobal sg) {
        result = TSyntheticGlobalSummaryComponent(sg)
      }
    }

    private predicate summarySpec(string spec) {
      exists(SummarizedCallable c |
        c.propagatesFlow(spec, _, _, _)
        or
        c.propagatesFlow(_, spec, _, _)
      )
      or
      any(SourceElement s).isSource(spec, _, _, _)
      or
      any(SinkElement s).isSink(spec, _, _, _)
    }

    import AccessPathSyntax::AccessPath<summarySpec/1>

    /** Holds if specification component `token` parses as parameter `pos`. */
    predicate parseParam(AccessPathToken token, ArgumentPosition pos) {
      token.getName() = "Parameter" and
      token.getAnArgument() = encodeArgumentPosition(pos)
      or
      pos = decodeUnknownArgumentPosition(token)
    }

    /** Holds if specification component `token` parses as argument `pos`. */
    predicate parseArg(AccessPathToken token, ParameterPosition pos) {
      token.getName() = "Argument" and
      token.getAnArgument() = encodeParameterPosition(pos)
      or
      pos = decodeUnknownParameterPosition(token)
    }

    /** Holds if specification component `token` parses as synthetic global `sg`. */
    predicate parseSynthGlobal(AccessPathToken token, string sg) {
      token.getName() = "SyntheticGlobal" and
      sg = token.getAnArgument()
    }

    private class SyntheticGlobalFromAccessPath extends SyntheticGlobal {
      SyntheticGlobalFromAccessPath() { parseSynthGlobal(_, this) }
    }

    private TParameterSummaryComponent callbackSelfParam() {
      result = TParameterSummaryComponent(callbackSelfParameterPosition())
    }

    newtype TSummaryComponentStack =
      TSingletonSummaryComponentStack(SummaryComponent c) or
      TConsSummaryComponentStack(SummaryComponent head, SummaryComponentStack tail) {
        any(RequiredSummaryComponentStack x).required(head, tail)
        or
        any(RequiredSummaryComponentStack x).required(TParameterSummaryComponent(_), tail) and
        head = callbackSelfParam()
        or
        derivedFluentFlowPush(_, _, _, head, tail, _)
      }

    /**
     * A (non-empty) stack of summary components.
     *
     * A stack is used to represent where data is read from (input) or where it
     * is written to (output). For example, an input stack `[Field f, Argument 0]`
     * means that data is read from field `f` from the `0`th argument, while an
     * output stack `[Field g, Return]` means that data is written to the field
     * `g` of the returned object.
     */
    class SummaryComponentStack extends TSummaryComponentStack {
      /** Gets the head of this stack. */
      SummaryComponent head() {
        this = TSingletonSummaryComponentStack(result) or
        this = TConsSummaryComponentStack(result, _)
      }

      /** Gets the tail of this stack, if any. */
      SummaryComponentStack tail() { this = TConsSummaryComponentStack(_, result) }

      /** Gets the length of this stack. */
      int length() {
        this = TSingletonSummaryComponentStack(_) and result = 1
        or
        result = 1 + this.tail().length()
      }

      /** Gets the stack obtained by dropping the first `i` elements, if any. */
      SummaryComponentStack drop(int i) {
        i = 0 and result = this
        or
        result = this.tail().drop(i - 1)
      }

      /** Holds if this stack contains summary component `c`. */
      predicate contains(SummaryComponent c) { c = this.drop(_).head() }

      /** Gets the bottom element of this stack. */
      SummaryComponent bottom() {
        this = TSingletonSummaryComponentStack(result) or result = this.tail().bottom()
      }

      /** Gets a textual representation of this stack used for MaD models. */
      string getMadRepresentation() {
        exists(SummaryComponent head, SummaryComponentStack tail |
          head = this.head() and
          tail = this.tail() and
          result = tail.getMadRepresentation() + "." + head.getMadRepresentation()
        )
        or
        exists(SummaryComponent c |
          this = TSingletonSummaryComponentStack(c) and
          result = c.getMadRepresentation()
        )
      }

      /** Gets a textual representation of this stack. */
      string toString() { result = this.getMadRepresentation() }
    }

    /** Provides predicates for constructing stacks of summary components. */
    module SummaryComponentStack {
      /** Gets a singleton stack containing `c`. */
      SummaryComponentStack singleton(SummaryComponent c) {
        result = TSingletonSummaryComponentStack(c)
      }

      /**
       * Gets the stack obtained by pushing `head` onto `tail`.
       *
       * Make sure to override `RequiredSummaryComponentStack::required()` in order
       * to ensure that the constructed stack exists.
       */
      SummaryComponentStack push(SummaryComponent head, SummaryComponentStack tail) {
        result = TConsSummaryComponentStack(head, tail)
      }

      /** Gets a singleton stack for an argument at position `pos`. */
      SummaryComponentStack argument(ParameterPosition pos) {
        result = singleton(SummaryComponent::argument(pos))
      }

      /** Gets a singleton stack representing a return of kind `rk`. */
      SummaryComponentStack return(ReturnKind rk) {
        result = singleton(SummaryComponent::return(rk))
      }
    }

    /**
     * A class that exists for QL technical reasons only (the IPA type used
     * to represent component stacks needs to be bounded).
     */
    class RequiredSummaryComponentStack extends Unit {
      /**
       * Holds if the stack obtained by pushing `head` onto `tail` is required.
       */
      abstract predicate required(SummaryComponent head, SummaryComponentStack tail);
    }

    /**
     * A callable with a flow summary.
     *
     * This interface is not meant to be used directly, instead use the public
     * `SummarizedCallable` interface. However, _if_ you need to use this, make
     * sure that that all classes `C` that extend `SummarizedCallableImpl` also
     * extend `SummarizedCallable`, using the following adapter pattern:
     *
     * ```ql
     * private class CAdapter extends SummarizedCallable instanceof C {
     *   override predicate propagatesFlow(string input, string output, boolean preservesValue, string model) {
     *     none()
     *   }
     *
     *   override predicate hasProvenance(Provenance provenance) {
     *     C.super.hasProvenance(provenance)
     *   }
     * }
     * ```
     */
    abstract class SummarizedCallableImpl extends SummarizedCallableBaseFinal {
      bindingset[this]
      SummarizedCallableImpl() { any() }

      /**
       * Holds if data may flow from `input` to `output` through this callable.
       *
       * `preservesValue` indicates whether this is a value-preserving step
       * or a taint-step.
       *
       * If `model` is non-empty then it indicates the provenance of the model
       * defining this flow.
       *
       * Input specifications are restricted to stacks that end with
       * `SummaryComponent::argument(_)`, preceded by zero or more
       * `SummaryComponent::return(_)` or `SummaryComponent::content(_)` components.
       *
       * Output specifications are restricted to stacks that end with
       * `SummaryComponent::return(_)` or `SummaryComponent::argument(_)`.
       *
       * Output stacks ending with `SummaryComponent::return(_)` can be preceded by zero
       * or more `SummaryComponent::content(_)` components.
       *
       * Output stacks ending with `SummaryComponent::argument(_)` can be preceded by an
       * optional `SummaryComponent::parameter(_)` component, which in turn can be preceded
       * by zero or more `SummaryComponent::content(_)` components.
       */
      pragma[nomagic]
      abstract predicate propagatesFlow(
        SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue,
        string model
      );

      /**
       * Holds if there exists a summary that applies to this callable
       * that has provenance `provenance`.
       */
      abstract predicate hasProvenance(Provenance provenance);
    }

    pragma[nomagic]
    private predicate summary(
      SummarizedCallableImpl c, SummaryComponentStack input, SummaryComponentStack output,
      boolean preservesValue, string model
    ) {
      c.propagatesFlow(input, output, preservesValue, model)
      or
      // observe side effects of callbacks on input arguments
      c.propagatesFlow(output, input, preservesValue, model) and
      preservesValue = true and
      isCallbackParameter(input) and
      isContentOfArgument(output, _)
      or
      // flow from the receiver of a callback into the instance-parameter
      exists(SummaryComponentStack s, SummaryComponentStack callbackRef |
        c.propagatesFlow(s, _, _, model) or c.propagatesFlow(_, s, _, model)
      |
        callbackRef = s.drop(_) and
        (isCallbackParameter(callbackRef) or callbackRef.head() = TReturnSummaryComponent(_)) and
        input = callbackRef.tail() and
        output = TConsSummaryComponentStack(callbackSelfParam(), input) and
        preservesValue = true
      )
      or
      exists(SummaryComponentStack arg, SummaryComponentStack return |
        derivedFluentFlow(c, input, arg, return, preservesValue, model)
      |
        arg.length() = 1 and
        output = return
        or
        exists(SummaryComponent head, SummaryComponentStack tail |
          derivedFluentFlowPush(c, input, arg, head, tail, 0) and
          output = SummaryComponentStack::push(head, tail)
        )
      )
      or
      // Chain together summaries where values get passed into callbacks along the way
      exists(
        SummaryComponentStack mid, boolean preservesValue1, boolean preservesValue2, string model1,
        string model2
      |
        c.propagatesFlow(input, mid, preservesValue1, model1) and
        c.propagatesFlow(mid, output, preservesValue2, model2) and
        mid.drop(mid.length() - 2) =
          SummaryComponentStack::push(TParameterSummaryComponent(_),
            SummaryComponentStack::singleton(TArgumentSummaryComponent(_))) and
        preservesValue = preservesValue1.booleanAnd(preservesValue2) and
        model = mergeModels(model1, model2)
      )
    }

    /**
     * Holds if `c` has a flow summary from `input` to `arg`, where `arg`
     * writes to (contents of) arguments at (some) position `pos`, and `c` has a
     * value-preserving flow summary from the arguments at position `pos`
     * to a return value (`return`).
     *
     * In such a case, we derive flow from `input` to (contents of) the return
     * value.
     *
     * As an example, this simplifies modeling of fluent methods:
     * for `StringBuilder.append(x)` with a specified value flow from qualifier to
     * return value and taint flow from argument 0 to the qualifier, then this
     * allows us to infer taint flow from argument 0 to the return value.
     */
    pragma[nomagic]
    private predicate derivedFluentFlow(
      SummarizedCallable c, SummaryComponentStack input, SummaryComponentStack arg,
      SummaryComponentStack return, boolean preservesValue, string model
    ) {
      exists(ParameterPosition pos, string model1, string model2 |
        summary(c, input, arg, preservesValue, model1) and
        isContentOfArgument(arg, pos) and
        summary(c, SummaryComponentStack::argument(pos), return, true, model2) and
        return.bottom() = TReturnSummaryComponent(_) and
        model = mergeModels(model1, model2)
      )
    }

    bindingset[model1, model2]
    pragma[inline_late]
    private string mergeModels(string model1, string model2) {
      model1 = "" and result = model2
      or
      model2 = "" and result = model1
      or
      model1 != "" and model2 != "" and result = model1 + "+" + model2
    }

    pragma[nomagic]
    private predicate derivedFluentFlowPush(
      SummarizedCallable c, SummaryComponentStack input, SummaryComponentStack arg,
      SummaryComponent head, SummaryComponentStack tail, int i
    ) {
      derivedFluentFlow(c, input, arg, tail, _, _) and
      head = arg.drop(i).head() and
      i = arg.length() - 2
      or
      exists(SummaryComponent head0, SummaryComponentStack tail0 |
        derivedFluentFlowPush(c, input, arg, head0, tail0, i + 1) and
        head = arg.drop(i).head() and
        tail = SummaryComponentStack::push(head0, tail0)
      )
    }

    private predicate isCallbackParameter(SummaryComponentStack s) {
      s.head() = TParameterSummaryComponent(_) and exists(s.tail())
    }

    private predicate isContentOfArgument(SummaryComponentStack s, ParameterPosition pos) {
      s.head() = TContentSummaryComponent(_) and isContentOfArgument(s.tail(), pos)
      or
      s = SummaryComponentStack::argument(pos)
    }

    private predicate outputState(SummarizedCallable c, SummaryComponentStack s) {
      summary(c, _, s, _, _)
      or
      exists(SummaryComponentStack out |
        outputState(c, out) and
        out.head() = TContentSummaryComponent(_) and
        s = out.tail()
      )
      or
      // Add the argument node corresponding to the requested post-update node
      inputState(c, s) and isCallbackParameter(s)
    }

    private predicate inputState(SummarizedCallable c, SummaryComponentStack s) {
      summary(c, s, _, _, _)
      or
      exists(SummaryComponentStack inp | inputState(c, inp) and s = inp.tail())
      or
      exists(SummaryComponentStack out |
        outputState(c, out) and
        out.head() = TParameterSummaryComponent(_) and
        s = out.tail()
      )
      or
      // Add the post-update node corresponding to the requested argument node
      outputState(c, s) and isCallbackParameter(s)
      or
      // Add the parameter node for parameter side-effects
      outputState(c, s) and s = SummaryComponentStack::argument(_)
    }

    pragma[nomagic]
    private predicate sourceOutputStateEntry(
      SourceElement source, SummaryComponentStack s, string kind, string model
    ) {
      exists(string outSpec |
        source.isSource(outSpec, kind, _, model) and
        External::interpretSpec(outSpec, s)
      )
    }

    pragma[nomagic]
    private predicate sourceOutputState(
      SourceElement source, SummaryComponentStack s, string kind, string model
    ) {
      sourceOutputStateEntry(source, s, kind, model)
      or
      exists(SummaryComponentStack out |
        sourceOutputState(source, out, kind, model) and
        out.head() = TContentSummaryComponent(_) and
        s = out.tail()
      )
    }

    pragma[nomagic]
    private predicate sinkInputStateExit(
      SinkElement sink, SummaryComponentStack s, string kind, string model
    ) {
      exists(string inSpec |
        sink.isSink(inSpec, kind, _, model) and
        External::interpretSpec(inSpec, s)
      )
    }

    pragma[nomagic]
    private predicate sinkInputState(
      SinkElement sink, SummaryComponentStack s, string kind, string model
    ) {
      sinkInputStateExit(sink, s, kind, model)
      or
      exists(SummaryComponentStack inp |
        sinkInputState(sink, inp, kind, model) and
        inp.head() = TContentSummaryComponent(_) and
        s = inp.tail()
      )
    }

    private newtype TSummaryNodeState =
      TSummaryNodeInputState(SummaryComponentStack s) { inputState(_, s) } or
      TSummaryNodeOutputState(SummaryComponentStack s) { outputState(_, s) } or
      TSourceOutputState(SummaryComponentStack s) { sourceOutputState(_, s, _, _) } or
      TSinkInputState(SummaryComponentStack s) { sinkInputState(_, s, _, _) }

    /**
     * A state used to break up (complex) flow summaries into atomic flow steps.
     * For a flow summary
     *
     * ```ql
     * propagatesFlow(
     *   SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue, string model
     * )
     * ```
     *
     * the following states are used:
     *
     * - `TSummaryNodeInputState(SummaryComponentStack s)`:
     *   this state represents that the components in `s` _have been read_ from the
     *   input.
     * - `TSummaryNodeOutputState(SummaryComponentStack s)`:
     *   this state represents that the components in `s` _remain to be written_ to
     *   the output.
     */
    private class SummaryNodeState extends TSummaryNodeState {
      /** Holds if this state is a valid input state for `c`. */
      pragma[nomagic]
      predicate isInputState(SummarizedCallable c, SummaryComponentStack s) {
        this = TSummaryNodeInputState(s) and
        inputState(c, s)
      }

      /** Holds if this state is a valid output state for `c`. */
      pragma[nomagic]
      predicate isOutputState(SummarizedCallable c, SummaryComponentStack s) {
        this = TSummaryNodeOutputState(s) and
        outputState(c, s)
      }

      /** Holds if this state is a valid output state for `source`. */
      pragma[nomagic]
      predicate isSourceOutputState(
        SourceElement source, SummaryComponentStack s, string kind, string model
      ) {
        sourceOutputState(source, s, kind, model) and
        this = TSourceOutputState(s)
      }

      /** Holds if this state is a valid input state for `sink`. */
      pragma[nomagic]
      predicate isSinkInputState(
        SinkElement sink, SummaryComponentStack s, string kind, string model
      ) {
        sinkInputState(sink, s, kind, model) and
        this = TSinkInputState(s)
      }

      /** Gets a textual representation of this state. */
      string toString() {
        exists(SummaryComponentStack s |
          this = TSummaryNodeInputState(s) and
          result = "read: " + s
        )
        or
        exists(SummaryComponentStack s |
          this = TSummaryNodeOutputState(s) and
          result = "to write: " + s
        )
        or
        exists(SummaryComponentStack s |
          this = TSourceOutputState(s) and
          result = "to write source: " + s
        )
        or
        exists(SummaryComponentStack s |
          this = TSinkInputState(s) and
          result = "read sink: " + s
        )
      }
    }

    private newtype TSummaryNode =
      TSummaryInternalNode(SummarizedCallable c, SummaryNodeState state) {
        summaryNodeRange(c, state)
      } or
      TSummaryParameterNode(SummarizedCallable c, ParameterPosition pos) {
        summaryParameterNodeRange(c, pos)
      } or
      TSourceOutputNode(SourceElement source, SummaryNodeState state, string kind, string model) {
        state.isSourceOutputState(source, _, kind, model)
      } or
      TSinkInputNode(SinkElement sink, SummaryNodeState state, string kind, string model) {
        state.isSinkInputState(sink, _, kind, model)
      }

    abstract class SummaryNode extends TSummaryNode {
      abstract string toString();

      abstract SummarizedCallable getSummarizedCallable();

      abstract SourceElement getSourceElement();

      abstract SinkElement getSinkElement();

      predicate isHidden() { any() }
    }

    private class SummaryInternalNode extends SummaryNode, TSummaryInternalNode {
      private SummarizedCallable c;
      private SummaryNodeState state;

      SummaryInternalNode() { this = TSummaryInternalNode(c, state) }

      override string toString() { result = "[summary] " + state + " in " + c }

      override SummarizedCallable getSummarizedCallable() { result = c }

      override SourceElement getSourceElement() { none() }

      override SinkElement getSinkElement() { none() }
    }

    private class SummaryParamNode extends SummaryNode, TSummaryParameterNode {
      private SummarizedCallable c;
      private ParameterPosition pos;

      SummaryParamNode() { this = TSummaryParameterNode(c, pos) }

      override string toString() { result = "[summary param] " + pos + " in " + c }

      override SummarizedCallable getSummarizedCallable() { result = c }

      override SourceElement getSourceElement() { none() }

      override SinkElement getSinkElement() { none() }
    }

    class SourceOutputNode extends SummaryNode, TSourceOutputNode {
      private SourceElement source_;
      private SummaryNodeState state_;
      private string kind_;
      private string model_;

      SourceOutputNode() { this = TSourceOutputNode(source_, state_, kind_, model_) }

      /**
       * Holds if this node is an entry node, i.e. before any stores have been performed.
       *
       * This node should be used as the actual source node in data flow configurations.
       */
      predicate isEntry(string kind, string model) {
        model = model_ and
        exists(SummaryComponentStack out |
          sourceOutputStateEntry(source_, out, kind, model_) and
          state_.isSourceOutputState(source_, out, kind, model_)
        )
      }

      /**
       * Holds if this node is an exit node, i.e. after all stores have been performed.
       *
       * A local flow step should be added from this node to a data flow node representing
       * `sc` inside `source`.
       */
      predicate isExit(SourceElement source, SummaryComponent sc, string model) {
        source = source_ and
        model = model_ and
        state_.isSourceOutputState(source, TSingletonSummaryComponentStack(sc), _, model)
      }

      override predicate isHidden() { not this.isEntry(_, _) }

      override string toString() {
        if this.isEntry(_, _)
        then result = source_.toString()
        else result = "[source] " + state_ + " at " + source_
      }

      override SummarizedCallable getSummarizedCallable() { none() }

      override SourceElement getSourceElement() { result = source_ }

      override SinkElement getSinkElement() { none() }
    }

    class SinkInputNode extends SummaryNode, TSinkInputNode {
      private SinkElement sink_;
      private SummaryNodeState state_;
      private string kind_;
      private string model_;

      SinkInputNode() { this = TSinkInputNode(sink_, state_, kind_, model_) }

      /**
       * Holds if this node is an entry node, i.e. before any reads have been performed.
       *
       * A local flow step should be added to this node from a data flow node representing
       * `sc` inside `sink`.
       */
      predicate isEntry(SinkElement sink, SummaryComponent sc, string model) {
        sink = sink_ and
        model = model_ and
        state_.isSinkInputState(sink, TSingletonSummaryComponentStack(sc), _, model)
      }

      /**
       * Holds if this node is an exit node, i.e. after all reads have been performed.
       *
       * This node should be used as the actual sink node in data flow configurations.
       */
      predicate isExit(string kind, string model) {
        kind = kind_ and
        model = model_ and
        exists(SummaryComponentStack inp |
          sinkInputStateExit(sink_, inp, kind, model_) and
          state_.isSinkInputState(sink_, inp, kind, model_)
        )
      }

      override predicate isHidden() { not this.isExit(_, _) }

      override string toString() {
        if this.isExit(_, _)
        then result = sink_.toString()
        else result = "[sink] " + state_ + " at " + sink_
      }

      override SummarizedCallable getSummarizedCallable() { none() }

      override SourceElement getSourceElement() { none() }

      override SinkElement getSinkElement() { result = sink_ }
    }

    /**
     * Holds if `state` represents having read from a parameter at position
     * `pos` in `c`. In this case we are not synthesizing a data-flow node,
     * but instead assume that a relevant parameter node already exists.
     */
    private predicate parameterReadState(
      SummarizedCallable c, SummaryNodeState state, ParameterPosition pos
    ) {
      state.isInputState(c, SummaryComponentStack::argument(pos))
    }

    /**
     * Holds if a synthesized summary node is needed for the state `state` in summarized
     * callable `c`.
     */
    private predicate summaryNodeRange(SummarizedCallable c, SummaryNodeState state) {
      state.isInputState(c, _) and
      not parameterReadState(c, state, _)
      or
      state.isOutputState(c, _)
    }

    pragma[noinline]
    private SummaryNode summaryNodeInputState(SummarizedCallable c, SummaryComponentStack s) {
      exists(SummaryNodeState state | state.isInputState(c, s) |
        result = TSummaryInternalNode(c, state)
        or
        exists(ParameterPosition pos |
          parameterReadState(c, state, pos) and
          result = TSummaryParameterNode(c, pos)
        )
      )
    }

    pragma[noinline]
    private SummaryNode summaryNodeOutputState(SummarizedCallable c, SummaryComponentStack s) {
      exists(SummaryNodeState state |
        state.isOutputState(c, s) and
        result = TSummaryInternalNode(c, state)
      )
    }

    pragma[noinline]
    private SummaryNode sourceElementOutputState(SourceElement source, SummaryComponentStack s) {
      exists(SummaryNodeState state, string kind, string model |
        state.isSourceOutputState(source, s, kind, model) and
        result = TSourceOutputNode(source, state, kind, model)
      )
    }

    pragma[noinline]
    private SummaryNode sinkElementInputState(SinkElement sink, SummaryComponentStack s) {
      exists(SummaryNodeState state, string kind, string model |
        state.isSinkInputState(sink, s, kind, model) and
        result = TSinkInputNode(sink, state, kind, model)
      )
    }

    /**
     * Holds if a write targets `post`, which is a post-update node for a
     * parameter at position `pos` in `c`.
     */
    private predicate isParameterPostUpdate(
      SummaryNode post, SummarizedCallable c, ParameterPosition pos
    ) {
      post = summaryNodeOutputState(c, SummaryComponentStack::argument(pos))
    }

    /** Holds if a parameter node at position `pos` is required for `c`. */
    private predicate summaryParameterNodeRange(SummarizedCallable c, ParameterPosition pos) {
      parameterReadState(c, _, pos)
      or
      // Same as `isParameterPostUpdate(_, c, pos)`, but can be used in a negative context
      any(SummaryNodeState state).isOutputState(c, SummaryComponentStack::argument(pos))
    }

    private predicate callbackOutput(
      SummarizedCallable c, SummaryComponentStack s, SummaryNode receiver, ReturnKind rk
    ) {
      any(SummaryNodeState state).isInputState(c, s) and
      s.head() = TReturnSummaryComponent(rk) and
      receiver = summaryNodeInputState(c, s.tail())
    }

    private predicate callbackInput(
      SummarizedCallable c, SummaryComponentStack s, SummaryNode receiver, ArgumentPosition pos
    ) {
      any(SummaryNodeState state).isOutputState(c, s) and
      s.head() = TParameterSummaryComponent(pos) and
      receiver = summaryNodeInputState(c, s.tail())
    }

    /** Holds if a call targeting `receiver` should be synthesized inside `c`. */
    predicate summaryCallbackRange(SummarizedCallable c, SummaryNode receiver) {
      callbackOutput(c, _, receiver, _)
      or
      callbackInput(c, _, receiver, _)
    }

    /** Holds if summary node `p` is a parameter with position `pos`. */
    predicate summaryParameterNode(SummaryNode p, ParameterPosition pos) {
      p = TSummaryParameterNode(_, pos)
    }

    /** Holds if summary node `out` contains output of kind `rk` from a call targeting `receiver`. */
    predicate summaryOutNode(SummaryNode receiver, SummaryNode out, ReturnKind rk) {
      exists(SummarizedCallable callable, SummaryComponentStack s |
        callbackOutput(callable, s, receiver, rk) and
        out = summaryNodeInputState(callable, s)
      )
    }

    /** Holds if summary node `arg` is at position `pos` in a call targeting `receiver`. */
    predicate summaryArgumentNode(SummaryNode receiver, SummaryNode arg, ArgumentPosition pos) {
      exists(SummarizedCallable callable, SummaryComponentStack s |
        callbackInput(callable, s, receiver, pos) and
        arg = summaryNodeOutputState(callable, s)
      )
    }

    /** Holds if summary node `post` is a post-update node with pre-update node `pre`. */
    predicate summaryPostUpdateNode(SummaryNode post, SummaryNode pre) {
      exists(SummarizedCallable c, ParameterPosition pos |
        isParameterPostUpdate(post, c, pos) and
        pre = TSummaryParameterNode(c, pos)
      )
      or
      exists(SummarizedCallable callable, SummaryComponentStack s |
        callbackInput(callable, s, _, _) and
        pre = summaryNodeOutputState(callable, s) and
        post = summaryNodeInputState(callable, s)
      )
    }

    /** Holds if summary node `ret` is a return node of kind `rk`. */
    predicate summaryReturnNode(SummaryNode ret, ReturnKind rk) {
      exists(SummaryComponentStack s |
        ret = summaryNodeOutputState(_, s) and
        s = TSingletonSummaryComponentStack(TReturnSummaryComponent(rk))
      )
    }

    /**
     * Holds if flow is allowed to pass from the parameter at position `pos` of `c`,
     * to a return node, and back out to the parameter.
     */
    predicate summaryAllowParameterReturnInSelf(SummarizedCallable c, ParameterPosition ppos) {
      exists(SummaryComponentStack inputContents, SummaryComponentStack outputContents |
        summary(c, inputContents, outputContents, _, _) and
        inputContents.bottom() = pragma[only_bind_into](TArgumentSummaryComponent(ppos)) and
        outputContents.bottom() = pragma[only_bind_into](TArgumentSummaryComponent(ppos))
      )
    }

    signature module TypesInputSig {
      /** Gets the type of content `c`. */
      DataFlowType getContentType(ContentSet c);

      /** Gets the type of the parameter at the given position. */
      bindingset[c, pos]
      DataFlowType getParameterType(SummarizedCallable c, ParameterPosition pos);

      /** Gets the return type of kind `rk` for callable `c`. */
      bindingset[c, rk]
      DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk);

      /**
       * Gets the type of the `i`th parameter in a synthesized call that targets a
       * callback of type `t`.
       */
      bindingset[t, pos]
      DataFlowType getCallbackParameterType(DataFlowType t, ArgumentPosition pos);

      /**
       * Gets the return type of kind `rk` in a synthesized call that targets a
       * callback of type `t`.
       */
      bindingset[t, rk]
      DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk);

      DataFlowType getSyntheticGlobalType(SyntheticGlobal sg);

      DataFlowType getSourceType(SourceBase source, SummaryComponent sc);

      DataFlowType getSinkType(SinkBase sink, SummaryComponent sc);
    }

    /**
     * Provides the predicate `summaryNodeType` for associating types with summary nodes.
     *
     * Only relevant for typed languages.
     */
    module Types<TypesInputSig TypesInput> {
      private import TypesInput

      /**
       * Gets the type of synthesized summary node `n`.
       *
       * The type is computed based on the language-specific predicates
       * `getContentType()`, `getReturnType()`, `getCallbackParameterType()`, and
       * `getCallbackReturnType()`.
       */
      DataFlowType summaryNodeType(SummaryNode n) {
        exists(SummaryNode pre |
          summaryPostUpdateNode(n, pre) and
          result = summaryNodeType(pre)
        )
        or
        exists(SummarizedCallable c, SummaryComponentStack s, SummaryComponent head |
          head = s.head()
        |
          n = summaryNodeInputState(c, s) and
          (
            exists(ContentSet cont | result = getContentType(cont) |
              head = TContentSummaryComponent(cont) or
              head = TWithContentSummaryComponent(cont)
            )
            or
            head = TWithoutContentSummaryComponent(_) and
            result = summaryNodeType(summaryNodeInputState(c, s.tail()))
            or
            exists(ReturnKind rk |
              head = TReturnSummaryComponent(rk) and
              result =
                getCallbackReturnType(summaryNodeType(summaryNodeInputState(pragma[only_bind_out](c),
                      s.tail())), rk)
            )
            or
            exists(SyntheticGlobal sg |
              head = TSyntheticGlobalSummaryComponent(sg) and
              result = getSyntheticGlobalType(sg)
            )
            or
            exists(ParameterPosition pos |
              head = TArgumentSummaryComponent(pos) and
              result = getParameterType(c, pos)
            )
          )
          or
          n = summaryNodeOutputState(c, s) and
          (
            exists(ContentSet cont |
              head = TContentSummaryComponent(cont) and result = getContentType(cont)
            )
            or
            s.length() = 1 and
            exists(ReturnKind rk |
              head = TReturnSummaryComponent(rk) and
              result = getReturnType(c, rk)
            )
            or
            exists(ArgumentPosition pos | head = TParameterSummaryComponent(pos) |
              result =
                getCallbackParameterType(summaryNodeType(summaryNodeInputState(pragma[only_bind_out](c),
                      s.tail())), pos)
            )
            or
            exists(SyntheticGlobal sg |
              head = TSyntheticGlobalSummaryComponent(sg) and
              result = getSyntheticGlobalType(sg)
            )
          )
        )
        or
        exists(SourceElement source |
          exists(SummaryComponent sc |
            n.(SourceOutputNode).isExit(source, sc, _) and
            result = getSourceType(source, sc)
          )
          or
          exists(SummaryComponentStack s, ContentSet cont |
            n = sourceElementOutputState(source, s) and
            s.head() = TContentSummaryComponent(cont) and
            result = getContentType(cont)
          )
        )
        or
        exists(SinkElement sink |
          exists(SummaryComponent sc |
            n.(SinkInputNode).isEntry(sink, sc, _) and
            result = getSinkType(sink, sc)
          )
          or
          exists(SummaryComponentStack s, ContentSet cont |
            n = sinkElementInputState(sink, s) and
            s.head() = TContentSummaryComponent(cont) and
            result = getContentType(cont)
          )
        )
      }
    }

    signature module StepsInputSig {
      /** Gets a call that targets summarized callable `sc`. */
      DataFlowCall getACall(SummarizedCallable sc);

      /**
       * Gets a data flow node corresponding to the `sc` part of `source`.
       *
       * `sc` is typically `ReturnValue` and the result is the node that
       * represents the return value of `source`.
       */
      Node getSourceNode(SourceBase source, SummaryComponent sc);

      /**
       * Gets a data flow node corresponding to the `sc` part of `sink`.
       *
       * `sc` is typically `Argument[i]` and the result is the node that
       * represents the `i`th argument of `sink`.
       */
      Node getSinkNode(SinkBase sink, SummaryComponent sc);
    }

    /** Provides a compilation of flow summaries to atomic data-flow steps. */
    module Steps<StepsInputSig StepsInput> {
      /**
       * Holds if there is a local step from `pred` to `succ`, which is synthesized
       * from a flow summary.
       */
      predicate summaryLocalStep(
        SummaryNode pred, SummaryNode succ, boolean preservesValue, string model
      ) {
        exists(
          SummarizedCallable c, SummaryComponentStack inputContents,
          SummaryComponentStack outputContents
        |
          summary(c, inputContents, outputContents, preservesValue, model) and
          pred = summaryNodeInputState(pragma[only_bind_into](c), inputContents) and
          succ = summaryNodeOutputState(pragma[only_bind_into](c), outputContents)
        |
          preservesValue = true
          or
          preservesValue = false and not summary(c, inputContents, outputContents, true, _)
        )
        or
        exists(SummarizedCallable c, SummaryComponentStack s |
          pred = summaryNodeInputState(c, s.tail()) and
          succ = summaryNodeInputState(c, s) and
          s.head() = [SummaryComponent::withContent(_), SummaryComponent::withoutContent(_)] and
          preservesValue = true and
          model = ""
        )
      }

      predicate sourceLocalStep(SourceOutputNode nodeFrom, Node nodeTo, string model) {
        exists(SummaryComponent sc, SourceElement source |
          nodeFrom.isExit(source, sc, model) and
          nodeTo = StepsInput::getSourceNode(source, sc)
        )
      }

      predicate sinkLocalStep(Node nodeFrom, SinkInputNode nodeTo, string model) {
        exists(SummaryComponent sc, SinkElement sink |
          nodeFrom = StepsInput::getSinkNode(sink, sc) and
          nodeTo.isEntry(sink, sc, model)
        )
      }

      /** Holds if the value of `succ` is uniquely determined by the value of `pred`. */
      predicate summaryLocalMustFlowStep(SummaryNode pred, SummaryNode succ) {
        pred = unique(SummaryNode n1 | summaryLocalStep(n1, succ, true, _))
      }

      /**
       * Holds if there is a read step of content `c` from `pred` to `succ`, which
       * is synthesized from a flow summary.
       */
      predicate summaryReadStep(SummaryNode pred, ContentSet c, SummaryNode succ) {
        exists(SummarizedCallable sc, SummaryComponentStack s |
          pred = summaryNodeInputState(sc, s.tail()) and
          succ = summaryNodeInputState(sc, s) and
          SummaryComponent::content(c) = s.head()
        )
        or
        exists(SinkElement sink, SummaryComponentStack s |
          pred = sinkElementInputState(sink, s.tail()) and
          succ = sinkElementInputState(sink, s) and
          SummaryComponent::content(c) = s.head()
        )
      }

      /**
       * Holds if there is a store step of content `c` from `pred` to `succ`, which
       * is synthesized from a flow summary.
       */
      predicate summaryStoreStep(SummaryNode pred, ContentSet c, SummaryNode succ) {
        exists(SummarizedCallable sc, SummaryComponentStack s |
          pred = summaryNodeOutputState(sc, s) and
          succ = summaryNodeOutputState(sc, s.tail()) and
          SummaryComponent::content(c) = s.head()
        )
        or
        exists(SourceElement source, SummaryComponentStack s |
          pred = sourceElementOutputState(source, s) and
          succ = sourceElementOutputState(source, s.tail()) and
          SummaryComponent::content(c) = s.head()
        )
      }

      /**
       * Holds if there is a jump step from `pred` to `succ`, which is synthesized
       * from a flow summary.
       */
      predicate summaryJumpStep(SummaryNode pred, SummaryNode succ) {
        exists(SummaryComponentStack s |
          s = SummaryComponentStack::singleton(SummaryComponent::syntheticGlobal(_)) and
          pred = summaryNodeOutputState(_, s) and
          succ = summaryNodeInputState(_, s)
        )
      }

      /**
       * Holds if values stored inside content `c` are cleared at `n`. `n` is a
       * synthesized summary node, so in order for values to be cleared at calls
       * to the relevant method, it is important that flow does not pass over
       * the argument, either via use-use flow or def-use flow.
       *
       * Example:
       *
       * ```
       * a.b = taint;
       * a.clearB(); // assume we have a flow summary for `clearB` that clears `b` on the qualifier
       * sink(a.b);
       * ```
       *
       * In the above, flow should not pass from `a` on the first line (or the second
       * line) to `a` on the third line. Instead, there will be synthesized flow from
       * `a` on line 2 to the post-update node for `a` on that line (via an intermediate
       * node where field `b` is cleared).
       */
      predicate summaryClearsContent(SummaryNode n, ContentSet c) {
        exists(SummarizedCallable sc, SummaryNodeState state, SummaryComponentStack stack |
          n = TSummaryInternalNode(sc, state) and
          state.isInputState(sc, stack) and
          stack.head() = SummaryComponent::withoutContent(c)
        )
      }

      /**
       * Holds if the value that is being tracked is expected to be stored inside
       * content `c` at `n`.
       */
      predicate summaryExpectsContent(SummaryNode n, ContentSet c) {
        exists(SummarizedCallable sc, SummaryNodeState state, SummaryComponentStack stack |
          n = TSummaryInternalNode(sc, state) and
          state.isInputState(sc, stack) and
          stack.head() = SummaryComponent::withContent(c)
        )
      }

      pragma[noinline]
      private predicate viableParam(
        DataFlowCall call, SummarizedCallable sc, ParameterPosition ppos, SummaryParamNode p
      ) {
        p = TSummaryParameterNode(sc, ppos) and
        call = StepsInput::getACall(sc)
      }

      pragma[nomagic]
      private SummaryParamNode summaryArgParam(DataFlowCall call, ArgNode arg, SummarizedCallable sc) {
        exists(ParameterPosition ppos |
          argumentPositionMatch(call, arg, ppos) and
          viableParam(call, sc, ppos, result)
        )
      }

      /**
       * Holds if `p` can reach `n` in a summarized callable, using only value-preserving
       * local steps. `clearsOrExpects` records whether any node on the path from `p` to
       * `n` either clears or expects contents.
       */
      private predicate paramReachesLocal(SummaryParamNode p, SummaryNode n, boolean clearsOrExpects) {
        viableParam(_, _, _, p) and
        n = p and
        clearsOrExpects = false
        or
        exists(SummaryNode mid, boolean clearsOrExpectsMid |
          paramReachesLocal(p, mid, clearsOrExpectsMid) and
          summaryLocalStep(mid, n, true, _) and
          if
            summaryClearsContent(n, _) or
            summaryExpectsContent(n, _)
          then clearsOrExpects = true
          else clearsOrExpects = clearsOrExpectsMid
        )
      }

      /**
       * Holds if use-use flow starting from `arg` should be prohibited.
       *
       * This is the case when `arg` is the argument of a call that targets a
       * flow summary where the corresponding parameter either clears contents
       * or expects contents.
       */
      pragma[nomagic]
      predicate prohibitsUseUseFlow(ArgNode arg, SummarizedCallable sc) {
        exists(SummaryParamNode p, ParameterPosition ppos, SummaryNode ret |
          paramReachesLocal(p, ret, true) and
          p = summaryArgParam(_, arg, sc) and
          p = TSummaryParameterNode(_, pragma[only_bind_into](ppos)) and
          isParameterPostUpdate(ret, _, pragma[only_bind_into](ppos))
        )
      }

      pragma[nomagic]
      private predicate summaryReturnNodeExt(SummaryNode ret, ReturnKindExt rk) {
        summaryReturnNode(ret, rk.(ValueReturnKind).getKind())
        or
        exists(SummaryParamNode p, SummaryNode pre, ParameterPosition pos |
          paramReachesLocal(p, pre, _) and
          summaryPostUpdateNode(ret, pre) and
          p = TSummaryParameterNode(_, pos) and
          rk.(ParamUpdateReturnKind).getPosition() = pos
        )
      }

      bindingset[ret]
      private SummaryParamNode summaryArgParamRetOut(
        ArgNode arg, SummaryNode ret, OutNodeExt out, SummarizedCallable sc
      ) {
        exists(DataFlowCall call, ReturnKindExt rk |
          result = summaryArgParam(call, arg, sc) and
          summaryReturnNodeExt(ret, pragma[only_bind_into](rk)) and
          out = getAnOutNodeExt(call, pragma[only_bind_into](rk))
        )
      }

      /**
       * Holds if `arg` flows to `out` using a simple value-preserving flow
       * summary, that is, a flow summary without reads and stores.
       *
       * NOTE: This step should not be used in global data-flow/taint-tracking, but may
       * be useful to include in the exposed local data-flow/taint-tracking relations.
       */
      predicate summaryThroughStepValue(ArgNode arg, Node out, SummarizedCallable sc) {
        exists(SummaryNode ret |
          summaryLocalStep(summaryArgParamRetOut(arg, ret, out, sc), ret, true, _)
        )
      }

      /**
       * Holds if `arg` flows to `out` using a simple flow summary involving taint
       * step, that is, a flow summary without reads and stores.
       *
       * NOTE: This step should not be used in global data-flow/taint-tracking, but may
       * be useful to include in the exposed local data-flow/taint-tracking relations.
       */
      predicate summaryThroughStepTaint(ArgNode arg, Node out, SummarizedCallable sc) {
        exists(SummaryNode ret |
          summaryLocalStep(summaryArgParamRetOut(arg, ret, out, sc), ret, false, _)
        )
      }

      /**
       * Holds if there is a read(+taint) of `c` from `arg` to `out` using a
       * flow summary.
       *
       * NOTE: This step should not be used in global data-flow/taint-tracking, but may
       * be useful to include in the exposed local data-flow/taint-tracking relations.
       */
      predicate summaryGetterStep(ArgNode arg, ContentSet c, Node out, SummarizedCallable sc) {
        exists(SummaryNode mid, SummaryNode ret |
          summaryReadStep(summaryArgParamRetOut(arg, ret, out, sc), c, mid) and
          summaryLocalStep(mid, ret, _, _)
        )
      }

      /**
       * Holds if there is a (taint+)store of `arg` into content `c` of `out` using a
       * flow summary.
       *
       * NOTE: This step should not be used in global data-flow/taint-tracking, but may
       * be useful to include in the exposed local data-flow/taint-tracking relations.
       */
      predicate summarySetterStep(ArgNode arg, ContentSet c, Node out, SummarizedCallable sc) {
        exists(SummaryNode mid, SummaryNode ret |
          summaryLocalStep(summaryArgParamRetOut(arg, ret, out, sc), mid, _, _) and
          summaryStoreStep(mid, c, ret)
        )
      }
    }

    /**
     * Provides a means of translating externally (e.g., MaD) defined flow
     * summaries into a `SummarizedCallable`s.
     */
    module External {
      private ContentSet decodeContent(AccessPathToken token) {
        exists(string name | name = encodeContent(result, token.getAnArgument(name)))
        or
        token = encodeContent(result, "")
      }

      private ReturnKind decodeReturn(AccessPathToken token) {
        exists(string name | name = encodeReturn(result, token.getAnArgument(name))) or
        token = encodeReturn(result, "")
      }

      private ContentSet decodeWithoutContent(AccessPathToken token) {
        exists(string name | name = encodeWithoutContent(result, token.getAnArgument(name)))
        or
        token = encodeWithoutContent(result, "")
      }

      private ContentSet decodeWithContent(AccessPathToken token) {
        exists(string name | name = encodeWithContent(result, token.getAnArgument(name))) or
        token = encodeWithContent(result, "")
      }

      private SummaryComponent interpretComponent(AccessPathToken token) {
        exists(ContentSet c |
          c = decodeContent(token)
          or
          not exists(decodeContent(token)) and
          c = decodeUnknownContent(token)
        |
          result = SummaryComponent::content(c)
        )
        or
        exists(ParameterPosition pos |
          parseArg(token, pos) and
          result = SummaryComponent::argument(pos)
        )
        or
        exists(ArgumentPosition pos |
          parseParam(token, pos) and
          result = SummaryComponent::parameter(pos)
        )
        or
        token = "ReturnValue" and result = SummaryComponent::return(getStandardReturnValueKind())
        or
        exists(ReturnKind rk |
          rk = decodeReturn(token)
          or
          not exists(decodeReturn(token)) and
          rk = decodeUnknownReturn(token)
        |
          result = SummaryComponent::return(rk)
        )
        or
        exists(string sg |
          parseSynthGlobal(token, sg) and result = SummaryComponent::syntheticGlobal(sg)
        )
        or
        exists(ContentSet c |
          c = decodeWithoutContent(token)
          or
          not exists(decodeWithoutContent(token)) and
          c = decodeUnknownWithoutContent(token)
        |
          result = SummaryComponent::withoutContent(c)
        )
        or
        exists(ContentSet c |
          c = decodeWithContent(token)
          or
          not exists(decodeWithContent(token)) and
          c = decodeUnknownWithContent(token)
        |
          result = SummaryComponent::withContent(c)
        )
      }

      /**
       * Holds if `spec` specifies summary component stack `stack`.
       */
      predicate interpretSpec(AccessPath spec, SummaryComponentStack stack) {
        interpretSpec(spec, spec.getNumToken(), stack)
      }

      /** Holds if the first `n` tokens of `spec` resolves to `stack`. */
      private predicate interpretSpec(AccessPath spec, int n, SummaryComponentStack stack) {
        n = 1 and
        stack = SummaryComponentStack::singleton(interpretComponent(spec.getToken(0)))
        or
        exists(SummaryComponent head, SummaryComponentStack tail |
          interpretSpec(spec, n, head, tail) and
          stack = SummaryComponentStack::push(head, tail)
        )
      }

      /** Holds if the first `n` tokens of `spec` resolves to `head` followed by `tail` */
      private predicate interpretSpec(
        AccessPath spec, int n, SummaryComponent head, SummaryComponentStack tail
      ) {
        interpretSpec(spec, n - 1, tail) and
        head = interpretComponent(spec.getToken(n - 1))
      }

      private class MkStack extends RequiredSummaryComponentStack {
        override predicate required(SummaryComponent head, SummaryComponentStack tail) {
          interpretSpec(_, _, head, tail)
        }
      }

      // adapter class for converting `SummarizedCallable`s to `SummarizedCallableImpl`s
      private class SummarizedCallableImplAdapter extends SummarizedCallableImpl instanceof SummarizedCallable
      {
        override predicate propagatesFlow(
          SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue,
          string model
        ) {
          exists(AccessPath inSpec, AccessPath outSpec |
            SummarizedCallable.super.propagatesFlow(inSpec, outSpec, preservesValue, model) and
            interpretSpec(inSpec, input) and
            interpretSpec(outSpec, output)
          )
        }

        override predicate hasProvenance(Provenance provenance) {
          SummarizedCallable.super.hasProvenance(provenance)
        }
      }

      /** Holds if component `c` of specification `spec` cannot be parsed. */
      predicate invalidSpecComponent(AccessPath spec, string c) {
        c = spec.getToken(_) and
        not exists(interpretComponent(c))
      }

      /** Holds if `provenance` is not a valid provenance value. */
      bindingset[provenance]
      predicate invalidProvenance(string provenance) { not provenance instanceof Provenance }

      /**
       * Holds if token `part` of specification `spec` has an invalid index.
       * E.g., `Argument[-1]`.
       */
      predicate invalidIndexComponent(AccessPath spec, AccessPathToken part) {
        part = spec.getToken(_) and
        part.getName() = ["Parameter", "Argument"] and
        AccessPathSyntax::parseInt(part.getArgumentList()) < 0
      }

      signature module SourceSinkInterpretationInputSig {
        class Element {
          string toString();

          Location getLocation();
        }

        /**
         * Holds if an external source specification exists for `n` with output specification
         * `output` and kind `kind`.
         */
        predicate sourceElement(
          Element n, string output, string kind, Provenance provenance, string model
        );

        /**
         * Holds if an external sink specification exists for `n` with input specification
         * `input` and kind `kind`.
         */
        predicate sinkElement(
          Element n, string input, string kind, Provenance provenance, string model
        );

        class SourceOrSinkElement extends Element;

        /** An entity used to interpret a source/sink specification. */
        class InterpretNode {
          string toString();

          Location getLocation();

          /** Gets the element that this node corresponds to, if any. */
          SourceOrSinkElement asElement();

          /** Gets the data-flow node that this node corresponds to, if any. */
          DataFlowLang::Node asNode();

          /** Gets the call that this node corresponds to, if any. */
          DataFlowLang::DataFlowCall asCall();

          /** Gets the callable that this node corresponds to, if any. */
          DataFlowLang::DataFlowCallable asCallable();

          /** Gets the target of this call, if any. */
          Element getCallTarget();
        }

        /** Provides additional sink specification logic. */
        bindingset[c]
        predicate interpretOutput(string c, InterpretNode mid, InterpretNode node);

        /** Provides additional source specification logic. */
        bindingset[c]
        predicate interpretInput(string c, InterpretNode mid, InterpretNode node);

        /** Holds if output specification component `c` needs a reference. */
        bindingset[c]
        default predicate outputNeedsReference(string c) { none() }

        /** Holds if input specification component `c` needs a reference. */
        bindingset[c]
        default predicate inputNeedsReference(string c) { none() }
      }

      /**
       * Legacy interface for interpreting source/sink specifications in static languages.
       *
       * Should eventually be replaced with API graphs like in dynamic languages.
       */
      module SourceSinkInterpretation<
        SourceSinkInterpretationInputSig SourceSinkInterpretationInput>
      {
        private import SourceSinkInterpretationInput

        private predicate sourceSinkSpec(string spec) {
          sourceElement(_, spec, _, _, _) or
          sinkElement(_, spec, _, _, _)
        }

        private module AccessPath = AccessPathSyntax::AccessPath<sourceSinkSpec/1>;

        private class SourceSinkAccessPathToken = AccessPath::AccessPathToken;

        private class SourceSinkAccessPath = AccessPath::AccessPath;

        private predicate parseParamSourceSink(SourceSinkAccessPathToken token, ArgumentPosition pos) {
          token.getName() = "Parameter" and
          token.getAnArgument() = encodeArgumentPosition(pos)
          or
          pos = decodeUnknownArgumentPosition(token)
        }

        private predicate parseArgSourceSink(SourceSinkAccessPathToken token, ParameterPosition pos) {
          token.getName() = "Argument" and
          token.getAnArgument() = encodeParameterPosition(pos)
          or
          pos = decodeUnknownParameterPosition(token)
        }

        private predicate outputNeedsReferenceExt(SourceSinkAccessPathToken c) {
          c.getName() = ["Argument", "ReturnValue"] or
          outputNeedsReference(c)
        }

        private predicate sourceElementRef(
          InterpretNode ref, SourceSinkAccessPath output, string kind, string model
        ) {
          exists(SourceOrSinkElement e |
            sourceElement(e, output, kind, _, model) and
            if outputNeedsReferenceExt(output.getToken(0))
            then e = ref.getCallTarget()
            else e = ref.asElement()
          )
        }

        private predicate inputNeedsReferenceExt(SourceSinkAccessPathToken c) {
          c.getName() = "Argument" or
          inputNeedsReference(c)
        }

        private predicate sinkElementRef(
          InterpretNode ref, SourceSinkAccessPath input, string kind, string model
        ) {
          exists(SourceOrSinkElement e |
            sinkElement(e, input, kind, _, model) and
            if inputNeedsReferenceExt(input.getToken(0))
            then e = ref.getCallTarget()
            else e = ref.asElement()
          )
        }

        /** Holds if the first `n` tokens of `output` resolve to the given interpretation. */
        private predicate interpretOutput(
          SourceSinkAccessPath output, int n, InterpretNode ref, InterpretNode node
        ) {
          sourceElementRef(ref, output, _, _) and
          n = 0 and
          (
            if output = ""
            then
              // Allow language-specific interpretation of the empty access path
              SourceSinkInterpretationInput::interpretOutput("", ref, node)
            else node = ref
          )
          or
          exists(InterpretNode mid, SourceSinkAccessPathToken c |
            interpretOutput(output, n - 1, ref, mid) and
            c = output.getToken(n - 1)
          |
            exists(ArgumentPosition apos |
              node.asNode()
                  .(PostUpdateNode)
                  .getPreUpdateNode()
                  .(ArgNode)
                  .argumentOf(mid.asCall(), apos)
            |
              c = "Argument"
              or
              exists(ParameterPosition ppos |
                parameterMatch(ppos, apos) and parseArgSourceSink(c, ppos)
              )
            )
            or
            exists(ParameterPosition ppos |
              node.asNode().(ParamNode).isParameterOf(mid.asCallable(), ppos)
            |
              c = "Parameter"
              or
              exists(ArgumentPosition apos |
                parameterMatch(ppos, apos) and parseParamSourceSink(c, apos)
              )
            )
            or
            c = "ReturnValue" and
            node.asNode() =
              getAnOutNodeExt(mid.asCall(), TValueReturn(getStandardReturnValueKind()))
            or
            SourceSinkInterpretationInput::interpretOutput(c, mid, node)
          )
        }

        /** Holds if the first `n` tokens of `input` resolve to the given interpretation. */
        private predicate interpretInput(
          SourceSinkAccessPath input, int n, InterpretNode ref, InterpretNode node
        ) {
          sinkElementRef(ref, input, _, _) and
          n = 0 and
          (
            if input = ""
            then
              // Allow language-specific interpretation of the empty access path
              SourceSinkInterpretationInput::interpretInput("", ref, node)
            else node = ref
          )
          or
          exists(InterpretNode mid, SourceSinkAccessPathToken c |
            interpretInput(input, n - 1, ref, mid) and
            c = input.getToken(n - 1)
          |
            exists(ArgumentPosition apos | node.asNode().(ArgNode).argumentOf(mid.asCall(), apos) |
              c = "Argument"
              or
              exists(ParameterPosition ppos |
                parameterMatch(ppos, apos) and parseArgSourceSink(c, ppos)
              )
            )
            or
            exists(ReturnNode ret, ValueReturnKind kind |
              c = "ReturnValue" and
              ret = node.asNode() and
              kind.getKind() = ret.getKind() and
              kind.getKind() = getStandardReturnValueKind() and
              mid.asCallable() = getNodeEnclosingCallable(ret)
            )
            or
            SourceSinkInterpretationInput::interpretInput(c, mid, node)
          )
        }

        /**
         * Holds if `node` is specified as a source with the given kind in a MaD flow
         * model.
         */
        predicate isSourceNode(InterpretNode node, string kind, string model) {
          exists(InterpretNode ref, SourceSinkAccessPath output |
            sourceElementRef(ref, output, kind, model) and
            interpretOutput(output, output.getNumToken(), ref, node)
          )
        }

        /**
         * Holds if `node` is specified as a sink with the given kind in a MaD flow
         * model.
         */
        predicate isSinkNode(InterpretNode node, string kind, string model) {
          exists(InterpretNode ref, SourceSinkAccessPath input |
            sinkElementRef(ref, input, kind, model) and
            interpretInput(input, input.getNumToken(), ref, node)
          )
        }

        final private class SourceOrSinkElementFinal = SourceOrSinkElement;

        signature predicate sourceOrSinkElementSig(
          Element e, string path, string kind, Provenance provenance, string model
        );

        private module MakeSourceOrSinkCallable<sourceOrSinkElementSig/5 sourceOrSinkElement> {
          class SourceSinkCallable extends SourceOrSinkElementFinal {
            private Provenance provenance;

            SourceSinkCallable() { sourceOrSinkElement(this, _, _, provenance, _) }

            /**
             * Holds if there exists a manual model that applies to this.
             */
            predicate hasManualModel() { any(Provenance p | this.hasProvenance(p)).isManual() }

            /**
             * Holds if this has provenance `p`.
             */
            predicate hasProvenance(Provenance p) { provenance = p }
          }
        }

        /**
         * A callable that has a source model.
         */
        class SourceModelCallable = MakeSourceOrSinkCallable<sourceElement/5>::SourceSinkCallable;

        /**
         * A callable that has a sink model.
         */
        class SinkModelCallable = MakeSourceOrSinkCallable<sinkElement/5>::SourceSinkCallable;

        /** A source or sink relevant for testing. */
        signature class RelevantSourceOrSinkElementSig extends SourceOrSinkElement {
          /** Gets the string representation of this callable used by `source/1` or `sink/1`. */
          string getCallableCsv();
        }

        /** Provides query predicates for outputting a set of relevant sources and sinks. */
        module TestSourceSinkOutput<
          RelevantSourceOrSinkElementSig RelevantSource, RelevantSourceOrSinkElementSig RelevantSink>
        {
          /**
           * Holds if there exists a relevant source callable with information roughly corresponding to `csv`.
           * Used for testing.
           * The syntax is: "namespace;type;overrides;name;signature;ext;outputspec;kind;provenance",
           * ext is hardcoded to empty.
           */
          query predicate source(string csv) {
            exists(RelevantSource s, string output, string kind, Provenance provenance |
              sourceElement(s, output, kind, provenance, _) and
              csv =
                s.getCallableCsv() // Callable information
                  + output + ";" // output
                  + kind + ";" // kind
                  + provenance // provenance
            )
          }

          /**
           * Holds if there exists a relevant sink callable with information roughly corresponding to `csv`.
           * Used for testing.
           * The syntax is: "namespace;type;overrides;name;signature;ext;inputspec;kind;provenance",
           * ext is hardcoded to empty.
           */
          query predicate sink(string csv) {
            exists(RelevantSink s, string input, string kind, Provenance provenance |
              sinkElement(s, input, kind, provenance, _) and
              csv =
                s.getCallableCsv() // Callable information
                  + input + ";" // input
                  + kind + ";" // kind
                  + provenance // provenance
            )
          }
        }
      }
    }

    /** A summarized callable relevant for testing. */
    signature class RelevantSummarizedCallableSig extends SummarizedCallableImpl {
      /** Gets the string representation of this callable used by `summary/1`. */
      string getCallableCsv();

      predicate relevantSummary(
        SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
      );
    }

    /** Provides a query predicate for outputting a set of relevant flow summaries. */
    module TestSummaryOutput<RelevantSummarizedCallableSig RelevantSummarizedCallable> {
      /** Render the kind in the format used in flow summaries. */
      private string renderKind(boolean preservesValue) {
        preservesValue = true and result = "value"
        or
        preservesValue = false and result = "taint"
      }

      private string renderProvenance(SummarizedCallable c) {
        exists(Provenance p | p.isManual() and c.hasProvenance(p) and result = p.toString())
        or
        not c.applyManualModel() and
        c.hasProvenance(result)
      }

      /**
       * Holds if there exists a relevant summary callable with information roughly corresponding to `csv`.
       * Used for testing.
       * The syntax is: "namespace;type;overrides;name;signature;ext;inputspec;outputspec;kind;provenance",
       * ext is hardcoded to empty.
       */
      query predicate summary(string csv) {
        exists(
          RelevantSummarizedCallable c, SummaryComponentStack input, SummaryComponentStack output,
          boolean preservesValue
        |
          c.relevantSummary(input, output, preservesValue) and
          csv =
            c.getCallableCsv() // Callable information
              + input.getMadRepresentation() + ";" // input
              + output.getMadRepresentation() + ";" // output
              + renderKind(preservesValue) + ";" // kind
              + renderProvenance(c) // provenance
        )
      }
    }

    /** A summarized callable relevant for testing. */
    signature module RelevantNeutralCallableSig<NeutralCallableSig NeutralCallableInput> {
      class RelevantNeutralCallable extends NeutralCallableInput {
        /** Gets the string representation of this callable used by `neutral/1`. */
        string getCallableCsv();
      }
    }

    module TestNeutralOutput<
      NeutralCallableSig NeutralCallableInput,
      RelevantNeutralCallableSig<NeutralCallableInput> RelevantNeutralCallableInput>
    {
      class RelevantNeutralCallable = RelevantNeutralCallableInput::RelevantNeutralCallable;

      private string renderProvenance(NeutralCallableInput c) {
        exists(Provenance p | p.isManual() and c.hasProvenance(p) and result = p.toString())
        or
        not c.hasManualModel() and
        c.hasProvenance(result)
      }

      /**
       * Holds if there exists a relevant neutral callable with information roughly corresponding to `csv`.
       * Used for testing.
       * The syntax is: "namespace;type;name;signature;kind;provenance"",
       */
      query predicate neutral(string csv) {
        exists(RelevantNeutralCallable c |
          csv =
            c.getCallableCsv() // Callable information
              + c.getKind() + ";" // kind
              + renderProvenance(c) // provenance
        )
      }
    }

    /**
     * Provides query predicates for rendering the generated data flow graph for
     * a summarized callable.
     *
     * Import this module into a `.ql` file of `@kind graph` to render the graph.
     * The graph is restricted to callables from `RelevantSummarizedCallable`.
     */
    module RenderSummarizedCallable<StepsInputSig StepsInput> {
      private module PrivateSteps = Private::Steps<StepsInput>;

      /** A summarized callable to include in the graph. */
      abstract class RelevantSummarizedCallable instanceof SummarizedCallable {
        string toString() { result = super.toString() }
      }

      private newtype TNodeOrCall =
        MkNode(SummaryNode n) {
          exists(RelevantSummarizedCallable c |
            n = TSummaryInternalNode(c, _)
            or
            n = TSummaryParameterNode(c, _)
          )
        } or
        MkCall(SummaryNode receiver) {
          receiver.getSummarizedCallable() instanceof RelevantSummarizedCallable and
          (
            callbackInput(_, _, receiver, _) or
            callbackOutput(_, _, receiver, _)
          )
        }

      private class NodeOrCall extends TNodeOrCall {
        SummaryNode asNode() { this = MkNode(result) }

        SummaryNode asCallReceiver() { this = MkCall(result) }

        string toString() {
          result = this.asNode().toString()
          or
          result = this.asCallReceiver().toString()
        }

        /**
         * Holds if this element is at the specified location.
         * The location spans column `startcolumn` of line `startline` to
         * column `endcolumn` of line `endline` in file `filepath`.
         * For more information, see
         * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
         */
        predicate hasLocationInfo(
          string filepath, int startline, int startcolumn, int endline, int endcolumn
        ) {
          filepath = "" and
          startline = 0 and
          startcolumn = 0 and
          endline = 0 and
          endcolumn = 0
        }
      }

      query predicate nodes(NodeOrCall n, string key, string val) {
        key = "semmle.label" and val = n.toString()
      }

      private predicate edgesComponent(NodeOrCall a, NodeOrCall b, string value) {
        exists(boolean preservesValue |
          PrivateSteps::summaryLocalStep(a.asNode(), b.asNode(), preservesValue, _) and
          if preservesValue = true then value = "value" else value = "taint"
        )
        or
        exists(ContentSet c |
          PrivateSteps::summaryReadStep(a.asNode(), c, b.asNode()) and
          value = "read (" + c + ")"
          or
          PrivateSteps::summaryStoreStep(a.asNode(), c, b.asNode()) and
          value = "store (" + c + ")"
          or
          PrivateSteps::summaryClearsContent(a.asNode(), c) and
          b = a and
          value = "clear (" + c + ")"
          or
          PrivateSteps::summaryExpectsContent(a.asNode(), c) and
          b = a and
          value = "expect (" + c + ")"
        )
        or
        summaryPostUpdateNode(b.asNode(), a.asNode()) and
        value = "post-update"
        or
        b.asCallReceiver() = a.asNode() and
        value = "receiver"
        or
        exists(ArgumentPosition pos |
          summaryArgumentNode(b.asCallReceiver(), a.asNode(), pos) and
          value = "argument (" + pos + ")"
        )
      }

      query predicate edges(NodeOrCall a, NodeOrCall b, string key, string value) {
        key = "semmle.label" and
        value = strictconcat(string s | edgesComponent(a, b, s) | s, " / ")
      }
    }
  }
}
