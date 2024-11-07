/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * Provides classes and predicates for dealing with flow models specified in CSV format.
 *
 * The CSV specification has the following columns:
 * - Sources:
 *   `namespace; type; subtypes; name; signature; ext; output; kind`
 * - Sinks:
 *   `namespace; type; subtypes; name; signature; ext; input; kind`
 * - Summaries:
 *   `namespace; type; subtypes; name; signature; ext; input; output; kind`
 *
 * The interpretation of a row is similar to API-graphs with a left-to-right
 * reading.
 * 1. The `namespace` column selects a package.
 * 2. The `type` column selects a type within that package.
 * 3. The `subtypes` is a boolean that indicates whether to jump to an
 *    arbitrary subtype of that type. Set this to `false` if leaving the `type`
 *    blank (for example, a free function).
 * 4. The `name` column optionally selects a specific named member of the type.
 * 5. The `signature` column optionally restricts the named member. If
 *    `signature` is blank then no such filtering is done. The format of the
 *    signature is a comma-separated list of types enclosed in parentheses. The
 *    types can be short names or fully qualified names (mixing these two options
 *    is not allowed within a single signature).
 * 6. The `ext` column specifies additional API-graph-like edges. Currently
 *    there is only one valid value: "".
 * 7. The `input` column specifies how data enters the element selected by the
 *    first 6 columns, and the `output` column specifies how data leaves the
 *    element selected by the first 6 columns. An `input` can be either "",
 *    "Argument[n]", "Argument[n1..n2]", "ReturnValue":
 *    - "": Selects a write to the selected element in case this is a field.
 *    - "Argument[n]": Selects an argument in a call to the selected element.
 *      The arguments are zero-indexed, and `-1` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects a value being returned by the selected element.
 *      This requires that the selected element is a method with a body.
 *
 *    An `output` can be either "", "Argument[n]", "Argument[n1..n2]", "Parameter",
 *    "Parameter[n]", "Parameter[n1..n2]", or "ReturnValue":
 *    - "": Selects a read of a selected field.
 *    - "Argument[n]": Selects the post-update value of an argument in a call to the
 *      selected element. That is, the value of the argument after the call returns.
 *      The arguments are zero-indexed, and `-1` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "Parameter[n]": Similar to "Parameter" but restricted to a specific
 *      numbered parameter (zero-indexed, and `-1` specifies the value of `this`).
 *    - "Parameter[n1..n2]": Similar to "Parameter[n]" but selects any parameter
 *      in the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects the return value of a call to the selected element.
 * 8. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources "remote" indicates a default remote flow source, and for summaries
 *    "taint" indicates a default additional taint step and "value" indicates a
 *    globally applicable value-preserving step.
 */

import swift
private import internal.DataFlowDispatch
private import internal.DataFlowPrivate
private import internal.DataFlowPublic
private import internal.FlowSummaryImpl
private import internal.FlowSummaryImpl::Public
private import internal.FlowSummaryImpl::Private
private import internal.FlowSummaryImpl::Private::External
private import FlowSummary as FlowSummary
private import codeql.mad.ModelValidation as SharedModelVal

/**
 * A unit class for adding additional source model rows.
 *
 * Extend this class to add additional source definitions.
 */
class SourceModelCsv extends Unit {
  /** Holds if `row` specifies a source definition. */
  abstract predicate row(string row);
}

/**
 * A unit class for adding additional sink model rows.
 *
 * Extend this class to add additional sink definitions.
 */
class SinkModelCsv extends Unit {
  /** Holds if `row` specifies a sink definition. */
  abstract predicate row(string row);
}

/**
 * A unit class for adding additional summary model rows.
 *
 * Extend this class to add additional flow summary definitions.
 */
class SummaryModelCsv extends Unit {
  /** Holds if `row` specifies a summary definition. */
  abstract predicate row(string row);
}

/** Holds if `row` is a source model. */
predicate sourceModel(string row) { any(SourceModelCsv s).row(row) }

/** Holds if `row` is a sink model. */
predicate sinkModel(string row) { any(SinkModelCsv s).row(row) }

/** Holds if `row` is a summary model. */
predicate summaryModel(string row) { any(SummaryModelCsv s).row(row) }

/** Holds if a source model exists for the given parameters. */
predicate sourceModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
) {
  exists(string row |
    sourceModel(row) and
    row.splitAt(";", 0) = namespace and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = subtypes.toString() and
    subtypes = [true, false] and
    row.splitAt(";", 3) = name and
    row.splitAt(";", 4) = signature and
    row.splitAt(";", 5) = ext and
    row.splitAt(";", 6) = output and
    row.splitAt(";", 7) = kind
  ) and
  provenance = "manual"
}

/** Holds if a sink model exists for the given parameters. */
predicate sinkModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
) {
  exists(string row |
    sinkModel(row) and
    row.splitAt(";", 0) = namespace and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = subtypes.toString() and
    subtypes = [true, false] and
    row.splitAt(";", 3) = name and
    row.splitAt(";", 4) = signature and
    row.splitAt(";", 5) = ext and
    row.splitAt(";", 6) = input and
    row.splitAt(";", 7) = kind
  ) and
  provenance = "manual"
}

/** Holds if a summary model exists for the given parameters. */
predicate summaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
) {
  exists(string row |
    summaryModel(row) and
    row.splitAt(";", 0) = namespace and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = subtypes.toString() and
    subtypes = [true, false] and
    row.splitAt(";", 3) = name and
    row.splitAt(";", 4) = signature and
    row.splitAt(";", 5) = ext and
    row.splitAt(";", 6) = input and
    row.splitAt(";", 7) = output and
    row.splitAt(";", 8) = kind
  ) and
  provenance = "manual"
}

private predicate relevantNamespace(string namespace) {
  sourceModel(namespace, _, _, _, _, _, _, _, _) or
  sinkModel(namespace, _, _, _, _, _, _, _, _) or
  summaryModel(namespace, _, _, _, _, _, _, _, _, _)
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
        sourceModel(subns, type, subtypes, name, signature, ext, output, kind, provenance)
      )
    or
    part = "sink" and
    n =
      strictcount(string subns, string type, boolean subtypes, string name, string signature,
        string ext, string input, string provenance |
        canonicalNamespaceLink(namespace, subns) and
        sinkModel(subns, type, subtypes, name, signature, ext, input, kind, provenance)
      )
    or
    part = "summary" and
    n =
      strictcount(string subns, string type, boolean subtypes, string name, string signature,
        string ext, string input, string output, string provenance |
        canonicalNamespaceLink(namespace, subns) and
        summaryModel(subns, type, subtypes, name, signature, ext, input, output, kind, provenance)
      )
  )
}

/** Provides a query predicate to check the CSV data for validation errors. */
module CsvValidation {
  private string getInvalidModelInput() {
    exists(string pred, AccessPath input, string part |
      sinkModel(_, _, _, _, _, _, input, _, _) and pred = "sink"
      or
      summaryModel(_, _, _, _, _, _, input, _, _, _) and pred = "summary"
    |
      (
        invalidSpecComponent(input, part) and
        not part = "" and
        not (part = "Argument" and pred = "sink") and
        not parseArg(part, _)
        or
        part = input.getToken(_) and
        parseParam(part, _)
      ) and
      result = "Unrecognized input specification \"" + part + "\" in " + pred + " model."
    )
  }

  private string getInvalidModelOutput() {
    exists(string pred, string output, string part |
      sourceModel(_, _, _, _, _, _, output, _, _) and pred = "source"
      or
      summaryModel(_, _, _, _, _, _, _, output, _, _) and pred = "summary"
    |
      invalidSpecComponent(output, part) and
      not part = "" and
      not (part = ["Argument", "Parameter"] and pred = "source") and
      result = "Unrecognized output specification \"" + part + "\" in " + pred + " model."
    )
  }

  private module KindValConfig implements SharedModelVal::KindValidationConfigSig {
    predicate summaryKind(string kind) { summaryModel(_, _, _, _, _, _, _, _, kind, _) }

    predicate sinkKind(string kind) { sinkModel(_, _, _, _, _, _, _, kind, _) }

    predicate sourceKind(string kind) { sourceModel(_, _, _, _, _, _, _, kind, _) }
  }

  private module KindVal = SharedModelVal::KindValidation<KindValConfig>;

  private string getInvalidModelSubtype() {
    exists(string pred, string row |
      sourceModel(row) and pred = "source"
      or
      sinkModel(row) and pred = "sink"
      or
      summaryModel(row) and pred = "summary"
    |
      exists(string b |
        b = row.splitAt(";", 2) and
        not b = ["true", "false"] and
        result = "Invalid boolean \"" + b + "\" in " + pred + " model."
      )
    )
  }

  private string getInvalidModelColumnCount() {
    exists(string pred, string row, int expect |
      sourceModel(row) and expect = 8 and pred = "source"
      or
      sinkModel(row) and expect = 8 and pred = "sink"
      or
      summaryModel(row) and expect = 9 and pred = "summary"
    |
      exists(int cols |
        cols = 1 + max(int n | exists(row.splitAt(";", n))) and
        cols != expect and
        result =
          "Wrong number of columns in " + pred + " model row, expected " + expect + ", got " + cols +
            "."
      )
    )
  }

  private string getInvalidModelSignature() {
    exists(string pred, string namespace, string type, string name, string signature, string ext |
      sourceModel(namespace, type, _, name, signature, ext, _, _, _) and pred = "source"
      or
      sinkModel(namespace, type, _, name, signature, ext, _, _, _) and pred = "sink"
      or
      summaryModel(namespace, type, _, name, signature, ext, _, _, _, _) and pred = "summary"
    |
      not namespace.regexpMatch("[a-zA-Z0-9_\\.]+") and
      result = "Dubious namespace \"" + namespace + "\" in " + pred + " model."
      or
      not type.regexpMatch("[a-zA-Z0-9_<>,\\+]+") and
      result = "Dubious type \"" + type + "\" in " + pred + " model."
      or
      not name.regexpMatch("[a-zA-Z0-9_<>,]*") and
      result = "Dubious member name \"" + name + "\" in " + pred + " model."
      or
      not signature.regexpMatch("|\\([a-zA-Z0-9_<>\\.\\+\\*,\\[\\]]*\\)") and
      result = "Dubious signature \"" + signature + "\" in " + pred + " model."
      or
      not ext.regexpMatch("|Attribute") and
      result = "Unrecognized extra API graph element \"" + ext + "\" in " + pred + " model."
    )
  }

  /** Holds if some row in a CSV-based flow model appears to contain typos. */
  query predicate invalidModelRow(string msg) {
    msg =
      [
        getInvalidModelSignature(), getInvalidModelInput(), getInvalidModelOutput(),
        getInvalidModelSubtype(), getInvalidModelColumnCount(), KindVal::getInvalidModelKind()
      ]
  }
}

private predicate elementSpec(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  sourceModel(namespace, type, subtypes, name, signature, ext, _, _, _) or
  sinkModel(namespace, type, subtypes, name, signature, ext, _, _, _) or
  summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _, _)
}

private string paramsStringPart(Function c, int i) {
  i = -1 and result = "(" and exists(c)
  or
  exists(int n, string p | c.getParam(n).getType().toString() = p |
    i = 2 * n and result = p
    or
    i = 2 * n - 1 and result = "," and n != 0
  )
  or
  i = 2 * c.getNumberOfParams() and result = ")"
}

/**
 * Gets a parenthesized string containing all parameter types of this callable, separated by a comma.
 *
 * Returns the empty string if the callable has no parameters.
 * Parameter types are represented by their type erasure.
 */
cached
string paramsString(Function c) { result = concat(int i | | paramsStringPart(c, i) order by i) }

bindingset[func]
predicate matchesSignature(Function func, string signature) {
  signature = "" or
  paramsString(func) = signature
}

/**
 * Gets the element in module `namespace` that satisfies the following properties:
 * 1. If the element is a member of a class-like type, then the class-like type has name `type`
 * 2. If `subtypes = true` and the element is a member of a class-like type, then overrides of the element
 *    are also returned.
 * 3. The element has name `name`
 * 4. If `signature` is non-empty, then the element has a list of parameter types described by `signature`.
 *
 * NOTE: `namespace` is currently not used (since we don't properly extract modules yet).
 */
pragma[nomagic]
private Element interpretElement0(
  string namespace, string type, boolean subtypes, string name, string signature
) {
  elementSpec(namespace, type, subtypes, name, signature, _) and
  namespace = "" and // TODO: Fill out when we properly extract modules.
  (
    // Non-member functions
    exists(Function func |
      func.getName() = name and
      type = "" and
      matchesSignature(func, signature) and
      subtypes = false and
      not result instanceof Method and
      result = func
    )
    or
    // Member functions
    exists(NominalTypeDecl namedTypeDecl, Decl declWithMethod, Method method |
      method.getName() = name and
      method = declWithMethod.getAMember() and
      namedTypeDecl.getFullName() = type and
      matchesSignature(method, signature) and
      result = method
    |
      // member declared in the named type or a subtype of it (or an extension of any)
      subtypes = true and
      declWithMethod.asNominalTypeDecl() = namedTypeDecl.getADerivedTypeDecl*()
      or
      // member declared directly in the named type (or an extension of it)
      subtypes = false and
      declWithMethod.asNominalTypeDecl() = namedTypeDecl
    )
    or
    // Fields
    signature = "" and
    exists(NominalTypeDecl namedTypeDecl, Decl declWithField, FieldDecl field |
      field.getName() = name and
      field = declWithField.getAMember() and
      namedTypeDecl.getFullName() = type and
      result = field
    |
      // field declared in the named type or a subtype of it (or an extension of any)
      subtypes = true and
      declWithField.asNominalTypeDecl() = namedTypeDecl.getADerivedTypeDecl*()
      or
      // field declared directly in the named type (or an extension of it)
      subtypes = false and
      declWithField.asNominalTypeDecl() = namedTypeDecl
    )
  )
}

/** Gets the source/sink/summary element corresponding to the supplied parameters. */
Element interpretElement(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  elementSpec(namespace, type, subtypes, name, signature, ext) and
  exists(Element e | e = interpretElement0(namespace, type, subtypes, name, signature) |
    ext = "" and result = e
  )
}

deprecated private predicate parseField(AccessPathToken c, Content::FieldContent f) {
  exists(string fieldRegex, string name |
    c.getName() = "Field" and
    fieldRegex = "^([^.]+)$" and
    name = c.getAnArgument().regexpCapture(fieldRegex, 1) and
    f.getField().getName() = name
  )
}

deprecated private predicate parseTuple(AccessPathToken c, Content::TupleContent t) {
  c.getName() = "TupleElement" and
  t.getIndex() = c.getAnArgument().toInt()
}

deprecated private predicate parseEnum(AccessPathToken c, Content::EnumContent e) {
  c.getName() = "EnumElement" and
  c.getAnArgument() = e.getSignature()
  or
  c.getName() = "OptionalSome" and
  e.getSignature() = "some:0"
}

/** Holds if the specification component parses as a `Content`. */
deprecated predicate parseContent(AccessPathToken component, Content content) {
  parseField(component, content)
  or
  parseTuple(component, content)
  or
  parseEnum(component, content)
  or
  // map legacy "ArrayElement" specification components to `CollectionContent`
  component.getName() = "ArrayElement" and
  content instanceof Content::CollectionContent
  or
  component.getName() = "CollectionElement" and
  content instanceof Content::CollectionContent
}

cached
private module Cached {
  /**
   * Holds if `node` is specified as a source with the given kind in a CSV flow
   * model.
   */
  cached
  predicate sourceNode(Node node, string kind, string model) {
    exists(SourceSinkInterpretationInput::InterpretNode n |
      isSourceNode(n, kind, model) and n.asNode() = node
    )
  }

  /**
   * Holds if `node` is specified as a sink with the given kind in a CSV flow
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

private predicate interpretSummary(
  Function f, string input, string output, string kind, string provenance, string model
) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance) and
    model = "" and // TODO: Insert MaD provenance from summaryModel
    f = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

// adapter class for converting Mad summaries to `SummarizedCallable`s
private class SummarizedCallableAdapter extends SummarizedCallable {
  SummarizedCallableAdapter() { interpretSummary(this, _, _, _, _, _) }

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
