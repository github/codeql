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
 * 8. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources "remote" indicates a default remote flow source, and for summaries
 *    "taint" indicates a default additional taint step and "value" indicates a
 *    globally applicable value-preserving step.
 */

private import go
private import internal.DataFlowPrivate
private import internal.FlowSummaryImpl::Private::External
private import internal.FlowSummaryImplSpecific
private import internal.AccessPathSyntax
private import FlowSummary

/**
 * A module importing the frameworks that provide external flow data,
 * ensuring that they are visible to the taint tracking / data flow library.
 */
private module Frameworks {
  private import semmle.go.frameworks.Stdlib
}

private class BuiltinModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;append;;;Argument[0].ArrayElement;ReturnValue.ArrayElement;value",
        ";;false;append;;;Argument[1];ReturnValue.ArrayElement;value"
      ]
  }
}

private predicate sourceModelCsv(string row) { none() }

private predicate sinkModelCsv(string row) { none() }

private predicate summaryModelCsv(string row) { none() }

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

private predicate sourceModel(string row) {
  sourceModelCsv(row) or
  any(SourceModelCsv s).row(row)
}

private predicate sinkModel(string row) {
  sinkModelCsv(row) or
  any(SinkModelCsv s).row(row)
}

private predicate summaryModel(string row) {
  summaryModelCsv(row) or
  any(SummaryModelCsv s).row(row)
}

/** Holds if a source model exists for the given parameters. */
predicate sourceModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind
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
  )
}

/** Holds if a sink model exists for the given parameters. */
predicate sinkModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind
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
  )
}

/** Holds if a summary model exists for the given parameters. */
predicate summaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind
) {
  summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, _)
}

/** Holds if a summary model `row` exists for the given parameters. */
predicate summaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string row
) {
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
}

/** Holds if `package` have CSV framework coverage. */
private predicate packageHasCsvCoverage(string package) {
  sourceModel(package, _, _, _, _, _, _, _) or
  sinkModel(package, _, _, _, _, _, _, _) or
  summaryModel(package, _, _, _, _, _, _, _, _)
}

/**
 * Holds if `package` and `subpkg` have CSV framework coverage and `subpkg`
 * is a subpackage of `package`.
 */
private predicate packageHasASubpackage(string package, string subpkg) {
  packageHasCsvCoverage(package) and
  packageHasCsvCoverage(subpkg) and
  subpkg.prefix(subpkg.indexOf(".")) = package
}

/**
 * Holds if `package` has CSV framework coverage and it is not a subpackage of
 * any other package with CSV framework coverage.
 */
private predicate canonicalPackage(string package) {
  packageHasCsvCoverage(package) and not packageHasASubpackage(_, package)
}

/**
 * Holds if `package` and `subpkg` have CSV framework coverage, `subpkg` is a
 * subpackage of `package` (or they are the same), and `package` is not a
 * subpackage of any other package with CSV framework coverage.
 */
private predicate canonicalPackageHasASubpackage(string package, string subpkg) {
  canonicalPackage(package) and
  (subpkg = package or packageHasASubpackage(package, subpkg))
}

/**
 * Holds if CSV framework coverage of `package` is `n` api endpoints of the
 * kind `(kind, part)`, and `pkgs` is the number of subpackages of `package`
 * which have CSV framework coverage (including `package` itself).
 */
predicate modelCoverage(string package, int pkgs, string kind, string part, int n) {
  pkgs = strictcount(string subpkg | canonicalPackageHasASubpackage(package, subpkg)) and
  (
    part = "source" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string output |
        canonicalPackageHasASubpackage(package, subpkg) and
        sourceModel(subpkg, type, subtypes, name, signature, ext, output, kind)
      )
    or
    part = "sink" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input |
        canonicalPackageHasASubpackage(package, subpkg) and
        sinkModel(subpkg, type, subtypes, name, signature, ext, input, kind)
      )
    or
    part = "summary" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string output |
        canonicalPackageHasASubpackage(package, subpkg) and
        summaryModel(subpkg, type, subtypes, name, signature, ext, input, output, kind)
      )
  )
}

/** Provides a query predicate to check the CSV data for validation errors. */
module CsvValidation {
  /** Holds if some row in a CSV-based flow model appears to contain typos. */
  query predicate invalidModelRow(string msg) {
    exists(string pred, string namespace, string type, string name, string signature, string ext |
      sourceModel(namespace, type, _, name, signature, ext, _, _) and pred = "source"
      or
      sinkModel(namespace, type, _, name, signature, ext, _, _) and pred = "sink"
      or
      summaryModel(namespace, type, _, name, signature, ext, _, _, _) and pred = "summary"
    |
      not namespace.regexpMatch("[a-zA-Z0-9_\\./]*") and
      msg = "Dubious namespace \"" + namespace + "\" in " + pred + " model."
      or
      not type.regexpMatch("[a-zA-Z0-9_\\$<>]*") and
      msg = "Dubious type \"" + type + "\" in " + pred + " model."
      or
      not name.regexpMatch("[a-zA-Z0-9_]*") and
      msg = "Dubious name \"" + name + "\" in " + pred + " model."
      or
      not signature.regexpMatch("|\\([a-zA-Z0-9_\\.\\$<>,\\[\\]]*\\)") and
      msg = "Dubious signature \"" + signature + "\" in " + pred + " model."
      or
      not ext.regexpMatch("|Annotated") and
      msg = "Unrecognized extra API graph element \"" + ext + "\" in " + pred + " model."
    )
    or
    exists(string pred, AccessPath input, string part |
      sinkModel(_, _, _, _, _, _, input, _) and pred = "sink"
      or
      summaryModel(_, _, _, _, _, _, input, _, _) and pred = "summary"
    |
      (
        invalidSpecComponent(input, part) and
        not part = "" and
        not parseArg(part, _)
        or
        part = input.getToken(_) and
        parseParam(part, _)
      ) and
      msg = "Unrecognized input specification \"" + part + "\" in " + pred + " model."
    )
    or
    exists(string pred, string output, string part |
      sourceModel(_, _, _, _, _, _, output, _) and pred = "source"
      or
      summaryModel(_, _, _, _, _, _, _, output, _) and pred = "summary"
    |
      invalidSpecComponent(output, part) and
      not part = "" and
      not (part = "Parameter" and pred = "source") and
      msg = "Unrecognized output specification \"" + part + "\" in " + pred + " model."
    )
    or
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
        msg =
          "Wrong number of columns in " + pred + " model row, expected " + expect + ", got " + cols +
            "."
      )
      or
      exists(string b |
        b = row.splitAt(";", 2) and
        not b = ["true", "false"] and
        msg = "Invalid boolean \"" + b + "\" in " + pred + " model."
      )
    )
  }
}

pragma[nomagic]
private predicate elementSpec(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  sourceModel(namespace, type, subtypes, name, signature, ext, _, _) or
  sinkModel(namespace, type, subtypes, name, signature, ext, _, _) or
  summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _)
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

/** Gets the source/sink/summary element corresponding to the supplied parameters. */
SourceOrSinkElement interpretElement(
  string pkg, string type, boolean subtypes, string name, string signature, string ext
) {
  elementSpec(pkg, type, subtypes, name, signature, ext) and
  // Go does not need to distinguish functions with signature
  signature = "" and
  (
    exists(Field f | f.hasQualifiedName(pkg, type, name) | result.asEntity() = f)
    or
    exists(Method m | m.hasQualifiedName(pkg, type, name) |
      result.asEntity() = m
      or
      subtypes = true and result.asEntity().(Method).implements(m)
    )
    or
    type = "" and
    exists(Entity e | e.hasQualifiedName(pkg, name) | result.asEntity() = e)
  )
}

/** Holds if there is an external specification for `f`. */
predicate hasExternalSpecification(Function f) {
  f = any(SummarizedCallable sc).asFunction()
  or
  exists(SourceOrSinkElement e | f = e.asEntity() | sourceElement(e, _, _) or sinkElement(e, _, _))
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
}

cached
private module Cached {
  /**
   * Holds if `node` is specified as a source with the given kind in a CSV flow
   * model.
   */
  cached
  predicate sourceNode(DataFlow::Node node, string kind) {
    exists(InterpretNode n | isSourceNode(n, kind) and n.asNode() = node)
  }

  /**
   * Holds if `node` is specified as a sink with the given kind in a CSV flow
   * model.
   */
  cached
  predicate sinkNode(DataFlow::Node node, string kind) {
    exists(InterpretNode n | isSinkNode(n, kind) and n.asNode() = node)
  }
}

import Cached
