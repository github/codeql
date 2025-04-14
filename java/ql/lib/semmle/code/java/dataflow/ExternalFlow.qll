/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * Provides classes and predicates for dealing with flow models specified
 * in data extensions and CSV format.
 *
 * The CSV specification has the following columns:
 * - Sources:
 *   `package; type; subtypes; name; signature; ext; output; kind; provenance`
 * - Sinks:
 *   `package; type; subtypes; name; signature; ext; input; kind; provenance`
 * - Summaries:
 *   `package; type; subtypes; name; signature; ext; input; output; kind; provenance`
 * - Neutrals:
 *   `package; type; name; signature; kind; provenance`
 *   A neutral is used to indicate that a callable is neutral with respect to flow (no summary), source (is not a source) or sink (is not a sink).
 *
 * The interpretation of a row is similar to API-graphs with a left-to-right
 * reading.
 * 1. The `package` column selects a package.
 * 2. The `type` column selects a type within that package.
 * 3. The `subtypes` is a boolean that indicates whether to jump to an
 *    arbitrary subtype of that type.
 * 4. The `name` column optionally selects a specific named member of the type.
 * 5. The `signature` column optionally restricts the named member. If
 *    `signature` is blank then no such filtering is done. The format of the
 *    signature is a comma-separated list of types enclosed in parentheses. The
 *    types can be short names or fully qualified names (mixing these two options
 *    is not allowed within a single signature).
 * 6. The `ext` column specifies additional API-graph-like edges. Currently
 *    there are only two valid values: "" and "Annotated". The empty string has no
 *    effect. "Annotated" applies if `name` and `signature` were left blank and
 *    acts by selecting an element that is annotated by the annotation type
 *    selected by the first 4 columns. This can be another member such as a field
 *    or method, or a parameter.
 * 7. The `input` column specifies how data enters the element selected by the
 *    first 6 columns, and the `output` column specifies how data leaves the
 *    element selected by the first 6 columns. An `input` can be a dot separated
 *    path consisting of either "", "Argument[n]", "Argument[n1..n2]",
 *    "ReturnValue", "Element", "WithoutElement", or "WithElement":
 *    - "": Selects a write to the selected element in case this is a field.
 *    - "Argument[n]": Selects an argument in a call to the selected element.
 *      The arguments are zero-indexed, and `this` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects a value being returned by the selected element.
 *      This requires that the selected element is a method with a body.
 *    - "Element": Selects the collection elements of the selected element.
 *    - "WithoutElement": Selects the selected element but without
 *       its collection elements.
 *    - "WithElement": Selects the collection elements of the selected element, but
 *       points to the selected element.
 *
 *    An `output` can be can be a dot separated path consisting of either "",
 *    "Argument[n]", "Argument[n1..n2]", "Parameter", "Parameter[n]",
 *    "Parameter[n1..n2]", "ReturnValue", or "Element":
 *    - "": Selects a read of a selected field, or a selected parameter.
 *    - "Argument[n]": Selects the post-update value of an argument in a call to the
 *      selected element. That is, the value of the argument after the call returns.
 *      The arguments are zero-indexed, and `this` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "Parameter": Selects the value of a parameter of the selected element.
 *      "Parameter" is also allowed in case the selected element is already a
 *      parameter itself.
 *    - "Parameter[n]": Similar to "Parameter" but restricted to a specific
 *      numbered parameter (zero-indexed, and `this` specifies the value of `this`).
 *    - "Parameter[n1..n2]": Similar to "Parameter[n]" but selects any parameter
 *      in the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects the return value of a call to the selected element.
 *    - "Element": Selects the collection elements of the selected element.
 * 8. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources "remote" indicates a default remote flow source, and for summaries
 *    "taint" indicates a default additional taint step and "value" indicates a
 *    globally applicable value-preserving step. For neutrals the kind can be `summary`,
 *    `source` or `sink` to indicate that the neutral is neutral with respect to
 *    flow (no summary), source (is not a source) or sink (is not a sink).
 * 9. The `provenance` column is a tag to indicate the origin and verification of a model.
 *    The format is {origin}-{verification} or just "manual" where the origin describes
 *    the origin of the model and verification describes how the model has been verified.
 *    Some examples are:
 *    - "df-generated": The model has been generated by the model generator tool.
 *    - "df-manual": The model has been generated by the model generator and verified by a human.
 *    - "manual": The model has been written by hand.
 *    This information is used in a heuristic for dataflow analysis to determine, if a
 *    model or source code should be used for determining flow.
 */

import java
private import semmle.code.java.dataflow.DataFlow::DataFlow
private import FlowSummary as FlowSummary
private import internal.DataFlowPrivate
private import internal.FlowSummaryImpl
private import internal.FlowSummaryImpl::Public
private import internal.FlowSummaryImpl::Private
private import internal.FlowSummaryImpl::Private::External
private import internal.ExternalFlowExtensions as Extensions
private import codeql.mad.ModelValidation as SharedModelVal

/**
 * A class for activating additional model rows.
 *
 * Extend this class to include experimental model rows with `this` name
 * in data flow analysis.
 */
abstract private class ActiveExperimentalModelsInternal extends string {
  bindingset[this]
  ActiveExperimentalModelsInternal() { any() }

  /**
   * Holds if an experimental source model exists for the given parameters.
   */
  predicate sourceModel(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string output, string kind, string provenance, QlBuiltins::ExtensionId madId
  ) {
    Extensions::experimentalSourceModel(package, type, subtypes, name, signature, ext, output, kind,
      provenance, this, madId)
  }

  /**
   * Holds if an experimental sink model exists for the given parameters.
   */
  predicate sinkModel(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string input, string kind, string provenance, QlBuiltins::ExtensionId madId
  ) {
    Extensions::experimentalSinkModel(package, type, subtypes, name, signature, ext, input, kind,
      provenance, this, madId)
  }

  /**
   * Holds if an experimental summary model exists for the given parameters.
   */
  predicate summaryModel(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string input, string output, string kind, string provenance, QlBuiltins::ExtensionId madId
  ) {
    Extensions::experimentalSummaryModel(package, type, subtypes, name, signature, ext, input,
      output, kind, provenance, this, madId)
  }
}

deprecated class ActiveExperimentalModels = ActiveExperimentalModelsInternal;

/** Holds if a source model exists for the given parameters. */
predicate sourceModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, QlBuiltins::ExtensionId madId
) {
  (
    Extensions::sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance,
      madId)
    or
    any(ActiveExperimentalModelsInternal q)
        .sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance, madId)
  )
}

/** Holds if a sink model exists for the given parameters. */
predicate sinkModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance, QlBuiltins::ExtensionId madId
) {
  (
    Extensions::sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance,
      madId)
    or
    any(ActiveExperimentalModelsInternal q)
        .sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance, madId)
  )
}

/** Holds if a summary model exists for the given parameters. */
predicate summaryModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance, QlBuiltins::ExtensionId madId
) {
  (
    Extensions::summaryModel(package, type, subtypes, name, signature, ext, input, output, kind,
      provenance, madId)
    or
    any(ActiveExperimentalModelsInternal q)
        .summaryModel(package, type, subtypes, name, signature, ext, input, output, kind,
          provenance, madId)
  )
}

/**
 * Holds if the given extension tuple `madId` should pretty-print as `model`.
 *
 * This predicate should only be used in tests.
 */
predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) {
  exists(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string output, string kind, string provenance
  |
    sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance, madId) or
    Extensions::experimentalSourceModel(package, type, subtypes, name, signature, ext, output, kind,
      provenance, _, madId)
  |
    model =
      "Source: " + package + "; " + type + "; " + subtypes + "; " + name + "; " + signature + "; " +
        ext + "; " + output + "; " + kind + "; " + provenance
  )
  or
  exists(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string input, string kind, string provenance
  |
    sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance, madId) or
    Extensions::experimentalSinkModel(package, type, subtypes, name, signature, ext, input, kind,
      provenance, _, madId)
  |
    model =
      "Sink: " + package + "; " + type + "; " + subtypes + "; " + name + "; " + signature + "; " +
        ext + "; " + input + "; " + kind + "; " + provenance
  )
  or
  exists(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string input, string output, string kind, string provenance
  |
    summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance,
      madId) or
    Extensions::experimentalSummaryModel(package, type, subtypes, name, signature, ext, input,
      output, kind, provenance, _, madId)
  |
    model =
      "Summary: " + package + "; " + type + "; " + subtypes + "; " + name + "; " + signature + "; " +
        ext + "; " + input + "; " + output + "; " + kind + "; " + provenance
  )
}

/** Holds if a neutral model exists for the given parameters. */
predicate neutralModel = Extensions::neutralModel/6;

private predicate relevantPackage(string package) {
  sourceModel(package, _, _, _, _, _, _, _, _, _) or
  sinkModel(package, _, _, _, _, _, _, _, _, _) or
  summaryModel(package, _, _, _, _, _, _, _, _, _, _)
}

private predicate packageLink(string shortpkg, string longpkg) {
  relevantPackage(shortpkg) and
  relevantPackage(longpkg) and
  longpkg.prefix(longpkg.indexOf(".")) = shortpkg
}

private predicate canonicalPackage(string package) {
  relevantPackage(package) and not packageLink(_, package)
}

private predicate canonicalPkgLink(string package, string subpkg) {
  canonicalPackage(package) and
  (subpkg = package or packageLink(package, subpkg))
}

/**
 * Holds if MaD framework coverage of `package` is `n` api endpoints of the
 * kind `(kind, part)`, and `pkgs` is the number of subpackages of `package`
 * which have MaD framework coverage (including `package` itself).
 */
predicate modelCoverage(string package, int pkgs, string kind, string part, int n) {
  pkgs = strictcount(string subpkg | canonicalPkgLink(package, subpkg)) and
  (
    part = "source" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string output, string provenance |
        canonicalPkgLink(package, subpkg) and
        sourceModel(subpkg, type, subtypes, name, signature, ext, output, kind, provenance, _)
      )
    or
    part = "sink" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string provenance |
        canonicalPkgLink(package, subpkg) and
        sinkModel(subpkg, type, subtypes, name, signature, ext, input, kind, provenance, _)
      )
    or
    part = "summary" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string output, string provenance |
        canonicalPkgLink(package, subpkg) and
        summaryModel(subpkg, type, subtypes, name, signature, ext, input, output, kind, provenance,
          _)
      )
  )
}

/** Provides a query predicate to check the MaD models for validation errors. */
module ModelValidation {
  private import codeql.dataflow.internal.AccessPathSyntax as AccessPathSyntax

  private predicate getRelevantAccessPath(string path) {
    summaryModel(_, _, _, _, _, _, path, _, _, _, _) or
    summaryModel(_, _, _, _, _, _, _, path, _, _, _) or
    sinkModel(_, _, _, _, _, _, path, _, _, _) or
    sourceModel(_, _, _, _, _, _, path, _, _, _)
  }

  private module MkAccessPath = AccessPathSyntax::AccessPath<getRelevantAccessPath/1>;

  class AccessPath = MkAccessPath::AccessPath;

  class AccessPathToken = MkAccessPath::AccessPathToken;

  private string getInvalidModelInput() {
    exists(string pred, AccessPath input, AccessPathToken part |
      sinkModel(_, _, _, _, _, _, input, _, _, _) and pred = "sink"
      or
      summaryModel(_, _, _, _, _, _, input, _, _, _, _) and pred = "summary"
    |
      (
        invalidSpecComponent(input, part) and
        not part = "" and
        not (part = "Argument" and pred = "sink") and
        not parseArg(part, _) and
        not part.getName() = "Field"
        or
        part = input.getToken(0) and
        parseParam(part, _)
        or
        invalidIndexComponent(input, part)
      ) and
      result = "Unrecognized input specification \"" + part + "\" in " + pred + " model."
    )
  }

  private string getInvalidModelOutput() {
    exists(string pred, AccessPath output, AccessPathToken part |
      sourceModel(_, _, _, _, _, _, output, _, _, _) and pred = "source"
      or
      summaryModel(_, _, _, _, _, _, _, output, _, _, _) and pred = "summary"
    |
      (
        invalidSpecComponent(output, part) and
        not part = "" and
        not (part = ["Argument", "Parameter"] and pred = "source") and
        not part.getName() = "Field"
        or
        invalidIndexComponent(output, part)
      ) and
      result = "Unrecognized output specification \"" + part + "\" in " + pred + " model."
    )
  }

  private module KindValConfig implements SharedModelVal::KindValidationConfigSig {
    predicate summaryKind(string kind) { summaryModel(_, _, _, _, _, _, _, _, kind, _, _) }

    predicate sinkKind(string kind) { sinkModel(_, _, _, _, _, _, _, kind, _, _) }

    predicate sourceKind(string kind) { sourceModel(_, _, _, _, _, _, _, kind, _, _) }

    predicate neutralKind(string kind) { neutralModel(_, _, _, _, kind, _) }
  }

  private module KindVal = SharedModelVal::KindValidation<KindValConfig>;

  private string getInvalidModelSignature() {
    exists(
      string pred, string package, string type, string name, string signature, string ext,
      string provenance
    |
      sourceModel(package, type, _, name, signature, ext, _, _, provenance, _) and pred = "source"
      or
      sinkModel(package, type, _, name, signature, ext, _, _, provenance, _) and pred = "sink"
      or
      summaryModel(package, type, _, name, signature, ext, _, _, _, provenance, _) and
      pred = "summary"
      or
      neutralModel(package, type, name, signature, _, provenance) and
      ext = "" and
      pred = "neutral"
    |
      not package.regexpMatch("[a-zA-Z0-9_\\.]*") and
      result = "Dubious package \"" + package + "\" in " + pred + " model."
      or
      not type.regexpMatch("[a-zA-Z0-9_\\$<>]+") and
      result = "Dubious type \"" + type + "\" in " + pred + " model."
      or
      not name.regexpMatch("[a-zA-Z0-9_\\-]*") and
      result = "Dubious name \"" + name + "\" in " + pred + " model."
      or
      not signature.regexpMatch("|\\([a-zA-Z0-9_\\.\\$<>,\\[\\]]*\\)") and
      result = "Dubious signature \"" + signature + "\" in " + pred + " model."
      or
      not ext.regexpMatch("|Annotated") and
      result = "Unrecognized extra API graph element \"" + ext + "\" in " + pred + " model."
      or
      invalidProvenance(provenance) and
      result = "Unrecognized provenance description \"" + provenance + "\" in " + pred + " model."
    )
  }

  /** Holds if some row in a MaD flow model appears to contain typos. */
  query predicate invalidModelRow(string msg) {
    msg =
      [
        getInvalidModelSignature(), getInvalidModelInput(), getInvalidModelOutput(),
        KindVal::getInvalidModelKind()
      ]
  }
}

pragma[nomagic]
private predicate elementSpec(
  string package, string type, boolean subtypes, string name, string signature, string ext
) {
  sourceModel(package, type, subtypes, name, signature, ext, _, _, _, _)
  or
  sinkModel(package, type, subtypes, name, signature, ext, _, _, _, _)
  or
  summaryModel(package, type, subtypes, name, signature, ext, _, _, _, _, _)
  or
  neutralModel(package, type, name, signature, _, _) and ext = "" and subtypes = true
}

private string getNestedName(Type t) {
  not t instanceof RefType and result = t.toString()
  or
  not t.(Array).getElementType() instanceof NestedType and result = t.(RefType).getNestedName()
  or
  result =
    t.(Array).getElementType().(NestedType).getEnclosingType().getNestedName() + "$" + t.getName()
}

private string getQualifiedName(Type t) {
  not t instanceof RefType and result = t.toString()
  or
  result = t.(RefType).getQualifiedName()
  or
  exists(Array a, Type c | a = t and c = a.getElementType() |
    not c instanceof RefType and result = t.toString()
    or
    exists(string pkgName | pkgName = c.(RefType).getPackage().getName() |
      if pkgName = "" then result = getNestedName(a) else result = pkgName + "." + getNestedName(a)
    )
  )
}

/**
 * Gets a parenthesized string containing all parameter types of this callable, separated by a comma.
 *
 * Returns an empty parenthesized string if the callable has no parameters.
 * Parameter types are represented by their type erasure.
 */
cached
string paramsString(Callable c) {
  result =
    "(" + concat(int i | | getNestedName(c.getParameterType(i).getErasure()), "," order by i) + ")"
}

private string paramsStringQualified(Callable c) {
  result =
    "(" + concat(int i | | getQualifiedName(c.getParameterType(i).getErasure()), "," order by i) +
      ")"
}

private Element interpretElement0(
  string package, string type, boolean subtypes, string name, string signature, boolean isExact
) {
  elementSpec(package, type, subtypes, name, signature, _) and
  (
    exists(Member m |
      (
        result = m and isExact = true
        or
        subtypes = true and result.(SrcMethod).overridesOrInstantiates+(m) and isExact = false
      ) and
      m.hasQualifiedName(package, type, name)
    |
      signature = ""
      or
      paramsStringQualified(m) = signature
      or
      paramsString(m) = signature
    )
    or
    exists(RefType t |
      t.hasQualifiedName(package, type) and
      isExact = false and
      (if subtypes = true then result.(SrcRefType).getASourceSupertype*() = t else result = t) and
      name = "" and
      signature = ""
    )
  )
}

/** Gets the source/sink/summary/neutral element corresponding to the supplied parameters. */
cached
Element interpretElement(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  boolean isExact
) {
  elementSpec(package, type, subtypes, name, signature, ext) and
  exists(Element e, boolean isExact0 |
    e = interpretElement0(package, type, subtypes, name, signature, isExact0)
  |
    ext = "" and result = e and isExact = isExact0
    or
    ext = "Annotated" and result.(Annotatable).getAnAnnotation().getType() = e and isExact = false
  )
}

private predicate parseField(AccessPathToken c, FieldContent f) {
  exists(
    string fieldRegex, string qualifiedName, string package, string className, string fieldName
  |
    c.getName() = "Field" and
    qualifiedName = c.getAnArgument() and
    fieldRegex = "^(.*)\\.([^.]+)\\.([^.]+)$" and
    package = qualifiedName.regexpCapture(fieldRegex, 1) and
    className = qualifiedName.regexpCapture(fieldRegex, 2) and
    fieldName = qualifiedName.regexpCapture(fieldRegex, 3) and
    f.getField().hasQualifiedName(package, className, fieldName)
  )
}

/** A string representing a synthetic instance field. */
class SyntheticField extends string {
  SyntheticField() { parseSynthField(_, this) }

  /**
   * Gets the type of this field. The default type is `Object`, but this can be
   * overridden.
   */
  Type getType() { result instanceof TypeObject }
}

private predicate parseSynthField(AccessPathToken c, string f) {
  c.getName() = "SyntheticField" and
  f = c.getAnArgument()
}

/** Holds if the specification component parses as a `Content`. */
predicate parseContent(AccessPathToken component, Content content) {
  parseField(component, content)
  or
  parseSynthField(component, content.(SyntheticFieldContent).getField())
  or
  component = "ArrayElement" and content instanceof ArrayContent
  or
  component = "Element" and content instanceof CollectionContent
  or
  component = "MapKey" and content instanceof MapKeyContent
  or
  component = "MapValue" and content instanceof MapValueContent
}

cached
private module Cached {
  /**
   * Holds if `node` is specified as a source with the given kind in a MaD flow
   * model.
   */
  cached
  predicate sourceNode(Node node, string kind, string model) {
    exists(SourceSinkInterpretationInput::InterpretNode n |
      isSourceNode(n, kind, model) and n.asNode() = node
    )
  }

  /**
   * Holds if `node` is specified as a sink with the given kind in a MaD flow
   * model.
   */
  cached
  predicate sinkNode(Node node, string kind, string model) {
    exists(SourceSinkInterpretationInput::InterpretNode n |
      isSinkNode(n, kind, model) and n.asNode() = node
    )
  }
}

import Cached

/**
 * Holds if `node` is specified as a source with the given kind in a MaD flow
 * model.
 */
predicate sourceNode(Node node, string kind) { sourceNode(node, kind, _) }

/**
 * Holds if `node` is specified as a sink with the given kind in a MaD flow
 * model.
 */
predicate sinkNode(Node node, string kind) { sinkNode(node, kind, _) }

// adapter class for converting Mad summaries to `SummarizedCallable`s
private class SummarizedCallableAdapter extends SummarizedCallable {
  SummarizedCallableAdapter() { summaryElement(this, _, _, _, _, _, _) }

  private predicate relevantSummaryElementManual(
    string input, string output, string kind, string model
  ) {
    exists(Provenance provenance |
      summaryElement(this, input, output, kind, provenance, model, _) and
      provenance.isManual()
    )
  }

  private predicate relevantSummaryElementGenerated(
    string input, string output, string kind, string model
  ) {
    exists(Provenance provenance |
      summaryElement(this, input, output, kind, provenance, model, _) and
      provenance.isGenerated()
    ) and
    not exists(Provenance provenance |
      neutralElement(this, "summary", provenance, _) and
      provenance.isManual()
    )
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    exists(string kind |
      this.relevantSummaryElementManual(input, output, kind, model)
      or
      not this.relevantSummaryElementManual(_, _, _, _) and
      this.relevantSummaryElementGenerated(input, output, kind, model)
    |
      if kind = "value" then preservesValue = true else preservesValue = false
    )
  }

  override predicate hasProvenance(Provenance provenance) {
    summaryElement(this, _, _, _, provenance, _, _)
  }

  override predicate hasExactModel() { summaryElement(this, _, _, _, _, _, true) }
}

final class SinkCallable = SinkModelCallable;

final class SourceCallable = SourceModelCallable;
