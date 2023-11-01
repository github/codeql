/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * Provides classes and predicates for dealing with MaD flow models specified
 * in data extensions and CSV format.
 *
 * The CSV specification has the following columns:
 * - Sources:
 *   `package; type; subtypes; name; signature; ext; output; kind; provenance`
 * - Sinks:
 *   `package; type; subtypes; name; signature; ext; input; kind; provenance`
 * - Summaries:
 *   `package; type; subtypes; name; signature; ext; input; output; kind; provenance`
 *
 * The interpretation of a row is similar to API-graphs with a left-to-right
 * reading.
 * 1. The `package` column selects a package.
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
 *      The arguments are zero-indexed, and `-1` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but selects any argument
 *      in the given range. The range is inclusive at both ends.
 *
 *    An `output` can be either "", "Argument[n]", "Argument[n1..n2]", "Parameter",
 *    "Parameter[n]", "Parameter[n1..n2]", , "ReturnValue", "ReturnValue[n]", or
 *    "ReturnValue[n1..n2]":
 *    - "": Selects a read of a selected field, or a selected parameter.
 *    - "Argument[n]": Selects the post-update value of an argument in a call to the
 *      selected element. That is, the value of the argument after the call returns.
 *      The arguments are zero-indexed, and `-1` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "Parameter": Selects the value of a parameter of the selected element.
 *      "Parameter" is also allowed in case the selected element is already a
 *      parameter itself.
 *    - "Parameter[n]": Similar to "Parameter" but restricted to a specific
 *      numbered parameter (zero-indexed, and `-1` specifies the value of `this`).
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
private import ExternalFlowExtensions as Extensions
private import internal.DataFlowPrivate
private import internal.FlowSummaryImpl::Private::External
private import internal.FlowSummaryImplSpecific
private import internal.AccessPathSyntax
private import FlowSummary
private import codeql.mad.ModelValidation as SharedModelVal

/** Holds if a source model exists for the given parameters. */
predicate sourceModel = Extensions::sourceModel/9;

/** Holds if a sink model exists for the given parameters. */
predicate sinkModel = Extensions::sinkModel/9;

/** Holds if a summary model exists for the given parameters. */
predicate summaryModel = Extensions::summaryModel/10;

/** Holds if `package` have MaD framework coverage. */
private predicate packageHasMaDCoverage(string package) {
  sourceModel(package, _, _, _, _, _, _, _, _) or
  sinkModel(package, _, _, _, _, _, _, _, _) or
  summaryModel(package, _, _, _, _, _, _, _, _, _)
}

/**
 * Holds if `package` and `subpkg` have MaD framework coverage and `subpkg`
 * is a subpackage of `package`.
 */
private predicate packageHasASubpackage(string package, string subpkg) {
  packageHasMaDCoverage(package) and
  packageHasMaDCoverage(subpkg) and
  subpkg.prefix(subpkg.indexOf(".")) = package
}

/**
 * Holds if `package` has MaD framework coverage and it is not a subpackage of
 * any other package with MaD framework coverage.
 */
private predicate canonicalPackage(string package) {
  packageHasMaDCoverage(package) and not packageHasASubpackage(_, package)
}

/**
 * Holds if `package` and `subpkg` have MaD framework coverage, `subpkg` is a
 * subpackage of `package` (or they are the same), and `package` is not a
 * subpackage of any other package with MaD framework coverage.
 */
private predicate canonicalPackageHasASubpackage(string package, string subpkg) {
  canonicalPackage(package) and
  (subpkg = package or packageHasASubpackage(package, subpkg))
}

/**
 * Holds if MaD framework coverage of `package` is `n` api endpoints of the
 * kind `(kind, part)`, and `pkgs` is the number of subpackages of `package`
 * which have MaD framework coverage (including `package` itself).
 */
predicate modelCoverage(string package, int pkgs, string kind, string part, int n) {
  pkgs = strictcount(string subpkg | canonicalPackageHasASubpackage(package, subpkg)) and
  (
    part = "source" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string output, string provenance |
        canonicalPackageHasASubpackage(package, subpkg) and
        sourceModel(subpkg, type, subtypes, name, signature, ext, output, kind, provenance)
      )
    or
    part = "sink" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string provenance |
        canonicalPackageHasASubpackage(package, subpkg) and
        sinkModel(subpkg, type, subtypes, name, signature, ext, input, kind, provenance)
      )
    or
    part = "summary" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string output, string provenance |
        canonicalPackageHasASubpackage(package, subpkg) and
        summaryModel(subpkg, type, subtypes, name, signature, ext, input, output, kind, provenance)
      )
  )
}

/** Provides a query predicate to check the MaD models for validation errors. */
module ModelValidation {
  private string getInvalidModelInput() {
    exists(string pred, AccessPath input, string part |
      sinkModel(_, _, _, _, _, _, input, _, _) and pred = "sink"
      or
      summaryModel(_, _, _, _, _, _, input, _, _, _) and pred = "summary"
    |
      (
        invalidSpecComponent(input, part) and
        not part = "" and
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
      not (part = "Parameter" and pred = "source") and
      result = "Unrecognized output specification \"" + part + "\" in " + pred + " model."
    )
  }

  private module KindValConfig implements SharedModelVal::KindValidationConfigSig {
    predicate summaryKind(string kind) { summaryModel(_, _, _, _, _, _, _, _, kind, _) }

    predicate sinkKind(string kind) { sinkModel(_, _, _, _, _, _, _, kind, _) }

    predicate sourceKind(string kind) { sourceModel(_, _, _, _, _, _, _, kind, _) }
  }

  private module KindVal = SharedModelVal::KindValidation<KindValConfig>;

  private string getInvalidModelSignature() {
    exists(
      string pred, string package, string type, string name, string signature, string ext,
      string provenance
    |
      sourceModel(package, type, _, name, signature, ext, _, _, provenance) and pred = "source"
      or
      sinkModel(package, type, _, name, signature, ext, _, _, provenance) and pred = "sink"
      or
      summaryModel(package, type, _, name, signature, ext, _, _, _, provenance) and pred = "summary"
    |
      not package.replaceAll("$ANYVERSION", "").regexpMatch("[a-zA-Z0-9_\\./-]*") and
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
  sourceModel(package, type, subtypes, name, signature, ext, _, _, _) or
  sinkModel(package, type, subtypes, name, signature, ext, _, _, _) or
  summaryModel(package, type, subtypes, name, signature, ext, _, _, _, _)
}

private string paramsStringPart(Function f, int i) {
  i = -1 and result = "("
  or
  exists(int n, string p | f.getParameterType(n).toString() = p |
    i = 2 * n and result = p
    or
    i = 2 * n - 1 and result = "," and n != 0
  )
  or
  i = 2 * f.getNumParameter() and result = ")"
}

/**
 * Gets a parenthesized string containing all parameter types of this callable, separated by a comma.
 *
 * Returns the empty string if the callable has no parameters.
 * Parameter types are represented by their type erasure.
 */
string paramsString(Function f) { result = concat(int i | | paramsStringPart(f, i) order by i) }

bindingset[p]
private string interpretPackage(string p) {
  exists(string r | r = "([^$]+)([./]\\$ANYVERSION(/|$)(.*))?" |
    if exists(p.regexpCapture(r, 4))
    then result = package(p.regexpCapture(r, 1), p.regexpCapture(r, 4))
    else result = package(p, "")
  )
}

/** Gets the source/sink/summary element corresponding to the supplied parameters. */
SourceOrSinkElement interpretElement(
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

/** Holds if there is an external specification for `f`. */
predicate hasExternalSpecification(Function f) {
  f = any(SummarizedCallable sc).asFunction()
  or
  exists(SourceOrSinkElement e | f = e.asEntity() |
    sourceElement(e, _, _, _) or sinkElement(e, _, _, _)
  )
}

private predicate parseField(AccessPathToken c, DataFlow::FieldContent f) {
  exists(string fieldRegex, string package, string className, string fieldName |
    fieldRegex = "^Field\\[(.*)\\.([^.]+)\\.([^.]+)\\]$" and
    package = c.regexpCapture(fieldRegex, 1) and
    className = c.regexpCapture(fieldRegex, 2) and
    fieldName = c.regexpCapture(fieldRegex, 3) and
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
  c.regexpCapture("SyntheticField\\[([.a-zA-Z0-9]+)\\]", 1) = f
}

/** Holds if the specification component parses as a `Content`. */
predicate parseContent(string component, DataFlow::Content content) {
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
  predicate sourceNode(DataFlow::Node node, string kind) {
    exists(InterpretNode n | isSourceNode(n, kind) and n.asNode() = node)
  }

  /**
   * Holds if `node` is specified as a sink with the given kind in a MaD flow
   * model.
   */
  cached
  predicate sinkNode(DataFlow::Node node, string kind) {
    exists(InterpretNode n | isSinkNode(n, kind) and n.asNode() = node)
  }
}

import Cached
