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
 * 1. The `package` column selects a package. Note that if the package does not
 *    contain a major version suffix (like "/v2") then we will match all major
 *    versions. This can be disabled by putting `fixed-version:` at the start
 *    of the package path.
 * 2. The `type` column selects a type within that package.
 * 3. The `subtypes` is a boolean that indicates whether to jump to an
 *    arbitrary subtype of that type.
 * 4. The `name` column optionally selects a specific named member of the type.
 * 5. The `signature` column is always empty.
 * 6. The `ext` column is always empty.
 * 7. The `input` column specifies how data enters the element selected by the
 *    first 6 columns, and the `output` column specifies how data leaves the
 *    element selected by the first 6 columns. An `input` can be either "",
 *    "Argument[n]", or "Argument[n1..n2]":
 *    - "": Selects a write to the selected element in case this is a field.
 *    - "Argument[n]": Selects an argument in a call to the selected element.
 *      The arguments are zero-indexed, and `receiver` specifies the receiver.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but selects any argument
 *      in the given range. The range is inclusive at both ends.
 *
 *    An `output` can be either "", "Argument[n]", "Argument[n1..n2]", "Parameter",
 *    "Parameter[n]", "Parameter[n1..n2]", , "ReturnValue", "ReturnValue[n]", or
 *    "ReturnValue[n1..n2]":
 *    - "": Selects a read of a selected field.
 *    - "Argument[n]": Selects the post-update value of an argument in a call to the
 *      selected element. That is, the value of the argument after the call returns.
 *      The arguments are zero-indexed, and `receiver` specifies the receiver.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "Parameter": Selects the value of a parameter of the selected element.
 *    - "Parameter[n]": Similar to "Parameter" but restricted to a specific
 *      numbered parameter (zero-indexed, and `receiver` specifies the receiver).
 *    - "Parameter[n1..n2]": Similar to "Parameter[n]" but selects any parameter
 *      in the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects the first value being returned by the selected
 *      element. This requires that the selected element is a method with a
 *      body.
 *    - "ReturnValue[n]": Similar to "ReturnValue" but selects the specified
 *      return value. The return values are zero-indexed
 *    - "ReturnValue[n1..n2]": Similar to "ReturnValue[n]" but selects any
 *      return value in the given range. The range is inclusive at both ends.
 *
 *    For summaries, `input` and `output` may be suffixed by any number of the
 *    following, separated by ".":
 *    - "Field[pkg.className.fieldname]": Selects the contents of the field `f`
 *      which satisfies `f.hasQualifiedName(pkg, className, fieldname)`.
 *    - "SyntheticField[f]": Selects the contents of the synthetic field `f`.
 *    - "ArrayElement": Selects an element in an array or slice.
 *    - "Element": Selects an element in a collection.
 *    - "MapKey": Selects a key in a map.
 *    - "MapValue": Selects a value in a map.
 *    - "Dereference": Selects the value referenced by a pointer.
 *
 * 8. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources "remote" indicates a default remote flow source, and for summaries
 *    "taint" indicates a default additional taint step and "value" indicates a
 *    globally applicable value-preserving step.
 */

private import go
import internal.ExternalFlowExtensions
private import FlowSummary as FlowSummary
private import internal.DataFlowPrivate
private import internal.FlowSummaryImpl
private import internal.FlowSummaryImpl::Public
private import internal.FlowSummaryImpl::Private
private import internal.FlowSummaryImpl::Private::External
private import codeql.mad.ModelValidation as SharedModelVal

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
    sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance, madId) and
    model =
      "Source: " + package + "; " + type + "; " + subtypes + "; " + name + "; " + signature + "; " +
        ext + "; " + output + "; " + kind + "; " + provenance
  )
  or
  exists(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string input, string kind, string provenance
  |
    sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance, madId) and
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
      madId) and
    model =
      "Summary: " + package + "; " + type + "; " + subtypes + "; " + name + "; " + signature + "; " +
        ext + "; " + input + "; " + output + "; " + kind + "; " + provenance
  )
}

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
      not package.replaceAll(fixedVersionPrefix(), "").regexpMatch("[a-zA-Z0-9_\\./-]*") and
      result = "Dubious package \"" + package + "\" in " + pred + " model."
      or
      not type.regexpMatch("[a-zA-Z0-9_\\$<>]*") and
      result = "Dubious type \"" + type + "\" in " + pred + " model."
      or
      not name.regexpMatch("[a-zA-Z0-9_]*") and
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
  neutralModel(package, type, name, signature, _, _) and ext = "" and subtypes = false
}

private string fixedVersionPrefix() { result = "fixed-version:" }

/**
 * Gets the string for the package path corresponding to `p`, if one exists.
 *
 * We attempt to account for major version suffixes as follows: if `p` is
 * `github.com/a/b/c/d` then we will return any path for a package that was
 * imported which matches that, possibly with a major version suffix in it,
 * so if `github.com/a/b/c/d/v2` or `github.com/a/b/v3/c/d` were imported then
 * they will be in the results. There are two situations where we do not do
 * this: (1) when `p` already contains a major version suffix; (2) if `p` has
 * `fixed-version:` at the start (which we remove).
 */
bindingset[p]
private string interpretPackage(string p) {
  exists(Package pkg | result = pkg.getPath() |
    p = fixedVersionPrefix() + result
    or
    not p = fixedVersionPrefix() + any(string s) and
    (
      if exists(p.regexpFind(majorVersionSuffixRegex(), 0, _))
      then result = p
      else p = pkg.getPathWithoutMajorVersionSuffix()
    )
  )
  or
  // Special case for built-in functions, which are not in any package, but
  // satisfy `hasQualifiedName` with the package path "".
  p = "" and result = ""
}

/** Gets the source/sink/summary element corresponding to the supplied parameters. */
cached
SourceSinkInterpretationInput::SourceOrSinkElement interpretElement(
  string pkg, string type, boolean subtypes, string name, string signature, string ext
) {
  elementSpec(pkg, type, subtypes, name, signature, ext) and
  // Go does not need to distinguish functions with signature
  signature = "" and
  (
    exists(Field f | f.hasQualifiedName(interpretPackage(pkg), type, name) | result.asEntity() = f)
    or
    exists(Method m | m.hasQualifiedName(interpretPackage(pkg), type, name) |
      result.asEntity() = m
      or
      subtypes = true and result.asEntity().(Method).implementsIncludingInterfaceMethods(m)
    )
    or
    type = "" and
    exists(Entity e | e.hasQualifiedName(interpretPackage(pkg), name) | result.asEntity() = e)
  )
}

private predicate parseField(AccessPathToken c, DataFlow::FieldContent f) {
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
   * Gets the type of this field. The default type is `interface{}`, but this can be
   * overridden.
   */
  Type getType() { result instanceof EmptyInterfaceType }
}

private predicate parseSynthField(AccessPathToken c, string f) {
  c.getName() = "SyntheticField" and
  f = c.getAnArgument()
}

/** Holds if the specification component parses as a `Content`. */
predicate parseContent(AccessPathToken component, DataFlow::Content content) {
  parseField(component, content)
  or
  parseSynthField(component, content.(DataFlow::SyntheticFieldContent).getField())
  or
  component = "ArrayElement" and content instanceof DataFlow::ArrayContent
  or
  component = "Element" and content instanceof DataFlow::CollectionContent
  or
  component = "MapKey" and content instanceof DataFlow::MapKeyContent
  or
  component = "MapValue" and content instanceof DataFlow::MapValueContent
  or
  component = "Dereference" and content instanceof DataFlow::PointerContent
}

cached
private module Cached {
  /**
   * Holds if `node` is specified as a source with the given kind in a MaD flow
   * model.
   */
  cached
  predicate sourceNode(DataFlow::Node node, string kind, string model) {
    exists(SourceSinkInterpretationInput::InterpretNode n |
      isSourceNode(n, kind, model) and n.asNode() = node
    )
  }

  /**
   * Holds if `node` is specified as a sink with the given kind in a MaD flow
   * model.
   */
  cached
  predicate sinkNode(DataFlow::Node node, string kind, string model) {
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
predicate sourceNode(DataFlow::Node node, string kind) { sourceNode(node, kind, _) }

/**
 * Holds if `node` is specified as a sink with the given kind in a MaD flow
 * model.
 */
predicate sinkNode(DataFlow::Node node, string kind) { sinkNode(node, kind, _) }

// adapter class for converting Mad summaries to `SummarizedCallable`s
private class SummarizedCallableAdapter extends SummarizedCallable {
  SummarizedCallableAdapter() { summaryElement(this, _, _, _, _, _) }

  private predicate relevantSummaryElementManual(
    string input, string output, string kind, string model
  ) {
    exists(Provenance provenance |
      summaryElement(this, input, output, kind, provenance, model) and
      provenance.isManual()
    )
  }

  private predicate relevantSummaryElementGenerated(
    string input, string output, string kind, string model
  ) {
    exists(Provenance provenance |
      summaryElement(this, input, output, kind, provenance, model) and
      provenance.isGenerated()
    ) and
    not exists(Provenance provenance |
      neutralElement(this, "summary", provenance) and
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
    summaryElement(this, _, _, _, provenance, _)
  }
}

// adapter class for converting Mad neutrals to `NeutralCallable`s
private class NeutralCallableAdapter extends NeutralCallable {
  string kind;
  string provenance_;

  NeutralCallableAdapter() { neutralElement(this, kind, provenance_) }

  override string getKind() { result = kind }

  override predicate hasProvenance(Provenance provenance) { provenance = provenance_ }
}
