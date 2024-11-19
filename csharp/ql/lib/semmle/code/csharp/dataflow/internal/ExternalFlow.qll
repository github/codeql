/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * Provides classes and predicates for dealing with MaD flow models specified
 * in data extensions and CSV format.
 *
 * The CSV specification has the following columns:
 * - Sources:
 *   `namespace; type; subtypes; name; signature; ext; output; kind; provenance`
 * - Sinks:
 *   `namespace; type; subtypes; name; signature; ext; input; kind; provenance`
 * - Summaries:
 *   `namespace; type; subtypes; name; signature; ext; input; output; kind; provenance`
 * - Neutrals:
 *   `namespace; type; name; signature; kind; provenance`
 *   A neutral is used to indicate that a callable is neutral with respect to flow (no summary), source (is not a source) or sink (is not a sink).
 *
 * The interpretation of a row is similar to API-graphs with a left-to-right
 * reading.
 * 1. The `namespace` column selects a namespace.
 * 2. The `type` column selects a type within that namespace.
 * 3. The `subtypes` is a boolean that indicates whether to jump to an
 *    arbitrary subtype of that type.
 * 4. The `name` column optionally selects a specific named member of the type.
 * 5. The `signature` column optionally restricts the named member. If
 *    `signature` is blank then no such filtering is done. The format of the
 *    signature is a comma-separated list of types enclosed in parentheses. The
 *    types can be short names or fully qualified names (mixing these two options
 *    is not allowed within a single signature).
 * 6. The `ext` column specifies additional API-graph-like edges. Currently
 *    there are only a few valid values: "", "Attribute", "Attribute.Getter" and "Attribute.Setter".
 *    The empty string has no effect. "Attribute" applies if `name` and `signature` were left blank
 *    and acts by selecting an element (except for properties and indexers) that is attributed with
 *    the attribute type selected by the first 4 columns. This can be another member such as
 *    a field, method, or parameter. "Attribute.Getter" and "Attribute.Setter" work similar to
 *    "Attribute", except that they can only be applied to properties and indexers.
 *    "Attribute.Setter" selects the setter element of a property/indexer and "Attribute.Getter"
 *    selects the getter.
 * 7. The `input` column specifies how data enters the element selected by the
 *    first 6 columns, and the `output` column specifies how data leaves the
 *    element selected by the first 6 columns. For sinks, an `input` can be either "",
 *    "Argument[n]", "Argument[n1..n2]", or "ReturnValue":
 *    - "": Selects a write to the selected element in case this is a field or property.
 *    - "Argument[n]": Selects an argument in a call to the selected element.
 *      The arguments are zero-indexed, and `this` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects a value being returned by the selected element.
 *      This requires that the selected element is a method with a body.
 *
 *    For sources, an `output` can be either "", "Argument[n]", "Argument[n1..n2]",
 *    "Parameter", "Parameter[n]", "Parameter[n1..n2]", or "ReturnValue":
 *    - "": Selects a read of a selected field or property.
 *    - "Argument[n]": Selects the post-update value of an argument in a call to the
 *      selected element. That is, the value of the argument after the call returns.
 *      The arguments are zero-indexed, and `this` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "Parameter": Selects the value of a parameter of the selected element.
 *    - "Parameter[n]": Similar to "Parameter" but restricted to a specific
 *      numbered parameter (zero-indexed, and `this` specifies the value of `this`).
 *    - "Parameter[n1..n2]": Similar to "Parameter[n]" but selects any parameter
 *      in the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects the return value of a call to the selected element.
 *
 *    For summaries, `input` and `output` may be suffixed by any number of the
 *    following, separated by ".":
 *    - "Element": Selects an element in a collection.
 *    - "Field[f]": Selects the contents of field `f`.
 *    - "Property[p]": Selects the contents of property `p`.
 *
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

import csharp
import ExternalFlowExtensions
private import DataFlowDispatch
private import DataFlowPrivate
private import DataFlowPublic
private import FlowSummaryImpl
private import FlowSummaryImpl::Public
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Private::External
private import semmle.code.csharp.commons.QualifiedName
private import semmle.code.csharp.dispatch.OverridableCallable
private import semmle.code.csharp.frameworks.System
private import codeql.dataflow.internal.AccessPathSyntax as AccessPathSyntax
private import codeql.mad.ModelValidation as SharedModelVal

/**
 * Holds if the given extension tuple `madId` should pretty-print as `model`.
 *
 * This predicate should only be used in tests.
 */
predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string output, string kind, string provenance
  |
    sourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance, madId) and
    model =
      "Source: " + namespace + "; " + type + "; " + subtypes + "; " + name + "; " + signature + "; "
        + ext + "; " + output + "; " + kind + "; " + provenance
  )
  or
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string input, string kind, string provenance
  |
    sinkModel(namespace, type, subtypes, name, signature, ext, input, kind, provenance, madId) and
    model =
      "Sink: " + namespace + "; " + type + "; " + subtypes + "; " + name + "; " + signature + "; " +
        ext + "; " + input + "; " + kind + "; " + provenance
  )
  or
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string input, string output, string kind, string provenance
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance,
      madId) and
    model =
      "Summary: " + namespace + "; " + type + "; " + subtypes + "; " + name + "; " + signature +
        "; " + ext + "; " + input + "; " + output + "; " + kind + "; " + provenance
  )
}

private predicate relevantNamespace(string namespace) {
  sourceModel(namespace, _, _, _, _, _, _, _, _, _) or
  sinkModel(namespace, _, _, _, _, _, _, _, _, _) or
  summaryModel(namespace, _, _, _, _, _, _, _, _, _, _)
}

private predicate namespaceLink(string shortns, string longns) {
  relevantNamespace(shortns) and
  relevantNamespace(longns) and
  longns.prefix(longns.indexOf(".")) = shortns
}

private predicate canonicalNamespace(string namespace) {
  relevantNamespace(namespace) and not namespaceLink(_, namespace)
}

private predicate canonicalNamespaceLink(string namespace, string subns) {
  canonicalNamespace(namespace) and
  (subns = namespace or namespaceLink(namespace, subns))
}

/**
 * Holds if MaD framework coverage of `namespace` is `n` api endpoints of the
 * kind `(kind, part)`, and `namespaces` is the number of subnamespaces of
 * `namespace` which have MaD framework coverage (including `namespace`
 * itself).
 */
predicate modelCoverage(string namespace, int namespaces, string kind, string part, int n) {
  namespaces = strictcount(string subns | canonicalNamespaceLink(namespace, subns)) and
  (
    part = "source" and
    n =
      strictcount(string subns, string type, boolean subtypes, string name, string signature,
        string ext, string output, string provenance |
        canonicalNamespaceLink(namespace, subns) and
        sourceModel(subns, type, subtypes, name, signature, ext, output, kind, provenance, _)
      )
    or
    part = "sink" and
    n =
      strictcount(string subns, string type, boolean subtypes, string name, string signature,
        string ext, string input, string provenance |
        canonicalNamespaceLink(namespace, subns) and
        sinkModel(subns, type, subtypes, name, signature, ext, input, kind, provenance, _)
      )
    or
    part = "summary" and
    n =
      strictcount(string subns, string type, boolean subtypes, string name, string signature,
        string ext, string input, string output, string provenance |
        canonicalNamespaceLink(namespace, subns) and
        summaryModel(subns, type, subtypes, name, signature, ext, input, output, kind, provenance, _)
      )
  )
}

/** Provides a query predicate to check the MaD models for validation errors. */
module ModelValidation {
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
        not part.getName() = ["Field", "Property"]
        or
        part = input.getToken(_) and
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
        not part.getName() = ["Field", "Property"]
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
      string pred, string namespace, string type, string name, string signature, string ext,
      string provenance
    |
      sourceModel(namespace, type, _, name, signature, ext, _, _, provenance, _) and pred = "source"
      or
      sinkModel(namespace, type, _, name, signature, ext, _, _, provenance, _) and pred = "sink"
      or
      summaryModel(namespace, type, _, name, signature, ext, _, _, _, provenance, _) and
      pred = "summary"
      or
      neutralModel(namespace, type, name, signature, _, provenance) and
      ext = "" and
      pred = "neutral"
    |
      not namespace.regexpMatch("[a-zA-Z0-9_\\.]+") and
      result = "Dubious namespace \"" + namespace + "\" in " + pred + " model."
      or
      not type.regexpMatch("[a-zA-Z0-9_<>,\\+]+") and
      result = "Dubious type \"" + type + "\" in " + pred + " model."
      or
      not name.regexpMatch("[a-zA-Z0-9_<>,\\.]*") and
      result = "Dubious member name \"" + name + "\" in " + pred + " model."
      or
      not signature.regexpMatch("|\\([a-zA-Z0-9_<>\\.\\+\\*,\\[\\]]*\\)") and
      result = "Dubious signature \"" + signature + "\" in " + pred + " model."
      or
      not ext = ["", "Attribute", "Attribute.Getter", "Attribute.Setter"] and
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

private predicate elementSpec(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  sourceModel(namespace, type, subtypes, name, signature, ext, _, _, _, _)
  or
  sinkModel(namespace, type, subtypes, name, signature, ext, _, _, _, _)
  or
  summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _, _, _)
  or
  neutralModel(namespace, type, name, signature, _, _) and ext = "" and subtypes = true
}

private predicate elementSpec(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  UnboundValueOrRefType t
) {
  elementSpec(namespace, type, subtypes, name, signature, ext) and
  hasQualifiedTypeName(t, namespace, type)
}

private class UnboundValueOrRefType extends ValueOrRefType {
  UnboundValueOrRefType() { this.isUnboundDeclaration() }

  UnboundValueOrRefType getASubTypeUnbound() {
    exists(Type t |
      result.getABaseType() = t and
      this = t.getUnboundDeclaration()
    )
  }
}

/** An unbound callable. */
class UnboundCallable extends Callable {
  UnboundCallable() { this.isUnboundDeclaration() }

  /**
   * Holds if this unbound callable overrides or implements (transitively)
   * `that` unbound callable.
   */
  predicate overridesOrImplementsUnbound(UnboundCallable that) {
    exists(Callable c |
      this.(Overridable).overridesOrImplements(c) and
      that = c.getUnboundDeclaration()
    )
  }
}

pragma[nomagic]
private predicate subtypeSpecCandidate(string name, UnboundValueOrRefType t) {
  exists(UnboundValueOrRefType t0 |
    elementSpec(_, _, true, name, _, _, t0) and
    t = t0.getASubTypeUnbound+()
  )
}

pragma[nomagic]
private predicate callableInfo(Callable c, string name, UnboundValueOrRefType decl) {
  decl = c.getDeclaringType() and
  (
    c.(Operator).getFunctionName() = name
    or
    not c instanceof Operator and
    c.hasName(name)
  )
}

private class InterpretedCallable extends Callable {
  InterpretedCallable() {
    exists(string namespace, string type, string name |
      partialModel(this, namespace, type, _, name, _) and
      elementSpec(namespace, type, _, name, _, _)
    )
    or
    exists(string name, UnboundValueOrRefType t |
      callableInfo(this, name, t) and
      subtypeSpecCandidate(name, t)
    )
  }
}

pragma[nomagic]
Declaration interpretBaseDeclaration(string namespace, string type, string name, string signature) {
  exists(UnboundValueOrRefType t | elementSpec(namespace, type, _, name, signature, _, t) |
    result =
      any(Declaration d |
        hasQualifiedMethodName(d, namespace, type, name) and
        (
          signature = ""
          or
          signature = "(" + parameterQualifiedTypeNamesToString(d) + ")"
        )
      )
    or
    result = t and
    name = "" and
    signature = ""
  )
}

pragma[inline]
private Declaration interpretExt(Declaration d, ExtPath ext) {
  ext = "" and result = d
  or
  ext.getToken(0) = "Attribute" and
  (
    not exists(ext.getToken(1)) and
    result.(Attributable).getAnAttribute().getType() = d and
    not result instanceof Property and
    not result instanceof Indexer
    or
    exists(string accessor | accessor = ext.getToken(1) |
      result.(Accessor).getDeclaration().getAnAttribute().getType() = d and
      (
        result instanceof Getter and
        accessor = "Getter"
        or
        result instanceof Setter and
        accessor = "Setter"
      )
    )
  )
}

/** Gets the source/sink/summary/neutral element corresponding to the supplied parameters. */
pragma[nomagic]
Declaration interpretElement(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  elementSpec(namespace, type, subtypes, name, signature, ext) and
  exists(Declaration base, Declaration d |
    base = interpretBaseDeclaration(namespace, type, name, signature) and
    (
      d = base
      or
      subtypes = true and
      (
        d.(UnboundCallable).overridesOrImplementsUnbound(base)
        or
        d = base.(UnboundValueOrRefType).getASubTypeUnbound+()
      )
    )
  |
    result = interpretExt(d, ext)
  )
}

private predicate relevantExt(string ext) {
  summaryModel(_, _, _, _, _, ext, _, _, _, _, _) or
  sourceModel(_, _, _, _, _, ext, _, _, _, _) or
  sinkModel(_, _, _, _, _, ext, _, _, _, _)
}

private class ExtPath = AccessPathSyntax::AccessPath<relevantExt/1>::AccessPath;

private predicate parseSynthField(AccessPathToken c, string name) {
  c.getName() = "SyntheticField" and name = c.getAnArgument()
}

/**
 * An adapter class for adding synthetic fields from MaD.
 */
private class SyntheticFieldAdapter extends SyntheticField {
  SyntheticFieldAdapter() { parseSynthField(_, this) }
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

private predicate isOverridableCallable(OverridableCallable c) {
  not exists(Type t, Callable base | c.getOverridee+() = base and t = base.getDeclaringType() |
    t instanceof SystemObjectClass or
    t instanceof SystemValueTypeClass
  )
}

/** Gets a string representing whether the summary should apply for all overrides of `c`. */
private string getCallableOverride(UnboundCallable c) {
  if isOverridableCallable(c) then result = "true" else result = "false"
}

private module QualifiedNameInput implements QualifiedNameInputSig {
  string getUnboundGenericSuffix(UnboundGeneric ug) {
    result =
      "<" + strictconcat(int i, string s | s = ug.getTypeParameter(i).getName() | s, "," order by i)
        + ">"
  }
}

private module QN = QualifiedName<QualifiedNameInput>;

/** Holds if declaration `d` has the qualified name `qualifier`.`name`. */
predicate hasQualifiedTypeName(Type t, string namespace, string type) {
  QN::hasQualifiedName(t, namespace, type)
}

/**
 * Holds if declaration `d` has name `name` and is defined in type `type`
 * with namespace `namespace`.
 */
predicate hasQualifiedMethodName(Declaration d, string namespace, string type, string name) {
  QN::hasQualifiedName(d, namespace, type, name)
}

pragma[nomagic]
private string parameterQualifiedType(Parameter p) {
  exists(string qualifier, string name |
    QN::hasQualifiedName(p.getType(), qualifier, name) and
    result = getQualifiedName(qualifier, name)
  )
}

/** Gets the string representation of the parameters of `c`. */
string parameterQualifiedTypeNamesToString(Callable c) {
  result =
    concat(int i, string s | s = parameterQualifiedType(c.getParameter(i)) | s, "," order by i)
}

predicate partialModel(
  Callable c, string namespace, string type, string extensible, string name, string parameters
) {
  QN::hasQualifiedName(c, namespace, type, name) and
  extensible = getCallableOverride(c) and
  parameters = "(" + parameterQualifiedTypeNamesToString(c) + ")"
}

/**
 * Gets the signature of `c` in the format `namespace;type;name;parameters`.
 */
string getSignature(UnboundCallable c) {
  exists(string namespace, string type, string name, string parameters |
    partialModel(c, namespace, type, _, name, parameters)
  |
    result =
      namespace + ";" //
        + type + ";" //
        + name + ";" //
        + parameters + ";" //
  )
}

private predicate interpretSummary(
  UnboundCallable c, string input, string output, string kind, string provenance, string model
) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    QlBuiltins::ExtensionId madId
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance,
      madId) and
    model = "MaD:" + madId.toString() and
    c = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

predicate interpretNeutral(UnboundCallable c, string kind, string provenance) {
  exists(string namespace, string type, string name, string signature |
    neutralModel(namespace, type, name, signature, kind, provenance) and
    c = interpretElement(namespace, type, true, name, signature, "")
  )
}

// adapter class for converting Mad summaries to `SummarizedCallable`s
private class SummarizedCallableAdapter extends SummarizedCallable {
  SummarizedCallableAdapter() {
    exists(Provenance provenance | interpretSummary(this, _, _, _, provenance, _) |
      not this.fromSource()
      or
      this.fromSource() and provenance.isManual()
    )
  }

  private predicate relevantSummaryElementManual(
    string input, string output, string kind, string model
  ) {
    exists(Provenance provenance |
      interpretSummary(this, input, output, kind, provenance, model) and
      provenance.isManual()
    )
  }

  private predicate relevantSummaryElementGenerated(
    string input, string output, string kind, string model
  ) {
    exists(Provenance provenance |
      interpretSummary(this, input, output, kind, provenance, model) and
      provenance.isGenerated()
    ) and
    not exists(Provenance provenance |
      interpretNeutral(this, "summary", provenance) and
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
    interpretSummary(this, _, _, _, provenance, _)
  }
}

final class SourceCallable = SourceModelCallable;

final class SinkCallable = SinkModelCallable;
