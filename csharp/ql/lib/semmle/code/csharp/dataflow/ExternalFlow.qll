/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * Provides classes and predicates for dealing with flow models specified in CSV format.
 *
 * The CSV specification has the following columns:
 * - Sources:
 *   `namespace; type; subtypes; name; signature; ext; output; kind; provenance`
 * - Sinks:
 *   `namespace; type; subtypes; name; signature; ext; input; kind; provenance`
 * - Summaries:
 *   `namespace; type; subtypes; name; signature; ext; input; output; kind; provenance`
 * - Negative Summaries:
 *   `namespace; type; name; signature; provenance`
 *   A negative summary is used to indicate that there is no flow via a callable.
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
 *    there are only two valid values: "" and "Attribute". The empty string has no
 *    effect. "Attribute" applies if `name` and `signature` were left blank and
 *    acts by selecting an element that is attributed with the attribute type
 *    selected by the first 4 columns. This can be another member such as a field,
 *    property, method, or parameter.
 * 7. The `input` column specifies how data enters the element selected by the
 *    first 6 columns, and the `output` column specifies how data leaves the
 *    element selected by the first 6 columns. For sinks, an `input` can be either "",
 *    "Argument[n]", "Argument[n1..n2]", or "ReturnValue":
 *    - "": Selects a write to the selected element in case this is a field or property.
 *    - "Argument[n]": Selects an argument in a call to the selected element.
 *      The arguments are zero-indexed, and `-1` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects a value being returned by the selected element.
 *      This requires that the selected element is a method with a body.
 *
 *    For sources, an `output` can be either "", "Argument[n]", "Argument[n1..n2]",
 *    "Parameter", "Parameter[n]", "Parameter[n1..n2]", or "ReturnValue":
 *    - "": Selects a read of a selected field, property, or parameter.
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
 *    - "ReturnValue": Selects the return value of a call to the selected element.
 *
 *    For summaries, `input` and `output` may be prefixed by one of the following,
 *    separated by the "of" keyword:
 *    - "Element": Selects an element in a collection.
 *    - "Field[f]": Selects the contents of field `f`.
 *    - "Property[p]": Selects the contents of property `p`.
 *
 * 8. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources "remote" indicates a default remote flow source, and for summaries
 *    "taint" indicates a default additional taint step and "value" indicates a
 *    globally applicable value-preserving step.
 * 9. The `provenance` column is a tag to indicate the origin of the summary.
 *    There are two supported values: "generated" and "manual". "generated" means that
 *    the model has been emitted by the model generator tool and "manual" means
 *    that the model has been written by hand. This information is used in a heuristic
 *    for dataflow analysis to determine, if a model or source code should be used for
 *    determining flow.
 */

import csharp
private import internal.AccessPathSyntax
private import internal.DataFlowDispatch
private import internal.DataFlowPrivate
private import internal.DataFlowPublic
private import internal.FlowSummaryImpl::Public
private import internal.FlowSummaryImpl::Private::External
private import internal.FlowSummaryImplSpecific

/**
 * A module importing the frameworks that provide external flow data,
 * ensuring that they are visible to the taint tracking / data flow library.
 */
private module Frameworks {
  private import semmle.code.csharp.frameworks.EntityFramework
  private import semmle.code.csharp.frameworks.Generated
  private import semmle.code.csharp.frameworks.JsonNET
  private import semmle.code.csharp.frameworks.microsoft.extensions.Primitives
  private import semmle.code.csharp.frameworks.microsoft.VisualBasic
  private import semmle.code.csharp.frameworks.ServiceStack
  private import semmle.code.csharp.frameworks.Sql
  private import semmle.code.csharp.frameworks.System
  private import semmle.code.csharp.frameworks.system.CodeDom
  private import semmle.code.csharp.frameworks.system.Collections
  private import semmle.code.csharp.frameworks.system.collections.Concurrent
  private import semmle.code.csharp.frameworks.system.collections.Generic
  private import semmle.code.csharp.frameworks.system.collections.Immutable
  private import semmle.code.csharp.frameworks.system.collections.ObjectModel
  private import semmle.code.csharp.frameworks.system.collections.Specialized
  private import semmle.code.csharp.frameworks.system.ComponentModel
  private import semmle.code.csharp.frameworks.system.componentmodel.Design
  private import semmle.code.csharp.frameworks.system.Configuration
  private import semmle.code.csharp.frameworks.system.Data
  private import semmle.code.csharp.frameworks.system.data.Common
  private import semmle.code.csharp.frameworks.system.Diagnostics
  private import semmle.code.csharp.frameworks.system.Dynamic
  private import semmle.code.csharp.frameworks.system.Linq
  private import semmle.code.csharp.frameworks.system.Net
  private import semmle.code.csharp.frameworks.system.net.Http
  private import semmle.code.csharp.frameworks.system.net.Mail
  private import semmle.code.csharp.frameworks.system.IO
  private import semmle.code.csharp.frameworks.system.io.Compression
  private import semmle.code.csharp.frameworks.system.runtime.CompilerServices
  private import semmle.code.csharp.frameworks.system.Security
  private import semmle.code.csharp.frameworks.system.security.Cryptography
  private import semmle.code.csharp.frameworks.system.security.cryptography.X509Certificates
  private import semmle.code.csharp.frameworks.system.Text
  private import semmle.code.csharp.frameworks.system.text.RegularExpressions
  private import semmle.code.csharp.frameworks.system.threading.Tasks
  private import semmle.code.csharp.frameworks.system.Web
  private import semmle.code.csharp.frameworks.system.web.ui.WebControls
  private import semmle.code.csharp.frameworks.system.Xml
  private import semmle.code.csharp.frameworks.system.xml.Schema
  private import semmle.code.csharp.frameworks.system.xml.Serialization
  private import semmle.code.csharp.security.dataflow.flowsinks.Html
  private import semmle.code.csharp.security.dataflow.flowsources.Local
  private import semmle.code.csharp.security.dataflow.XSSSinks
}

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

/**
 * A unit class for adding negative summary model rows.
 *
 * Extend this class to add additional flow summary definitions.
 */
class NegativeSummaryModelCsv extends Unit {
  /** Holds if `row` specifies a negative summary definition. */
  abstract predicate row(string row);
}

/** Holds if `row` is a source model. */
predicate sourceModel(string row) { any(SourceModelCsv s).row(row) }

/** Holds if `row` is a sink model. */
predicate sinkModel(string row) { any(SinkModelCsv s).row(row) }

/** Holds if `row` is a summary model. */
predicate summaryModel(string row) { any(SummaryModelCsv s).row(row) }

/** Holds if `row` is a negative summary model. */
predicate negativeSummaryModel(string row) { any(NegativeSummaryModelCsv s).row(row) }

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
    row.splitAt(";", 7) = kind and
    row.splitAt(";", 8) = provenance
  )
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
    row.splitAt(";", 7) = kind and
    row.splitAt(";", 8) = provenance
  )
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
    row.splitAt(";", 8) = kind and
    row.splitAt(";", 9) = provenance
  )
}

/** Holds if a summary model exists indicating there is no flow for the given parameters. */
predicate negativeSummaryModel(
  string namespace, string type, string name, string signature, string provenance
) {
  exists(string row |
    negativeSummaryModel(row) and
    row.splitAt(";", 0) = namespace and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = name and
    row.splitAt(";", 3) = signature and
    row.splitAt(";", 4) = provenance
  )
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
 * Holds if CSV framework coverage of `namespace` is `n` api endpoints of the
 * kind `(kind, part)`.
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

  private string getInvalidModelKind() {
    exists(string row, string kind | summaryModel(row) |
      kind = row.splitAt(";", 8) and
      not kind = ["taint", "value"] and
      result = "Invalid kind \"" + kind + "\" in summary model."
    )
    or
    exists(string row, string kind | sinkModel(row) |
      kind = row.splitAt(";", 7) and
      not kind = ["code", "sql", "xss", "remote", "html"] and
      not kind.matches("encryption-%") and
      result = "Invalid kind \"" + kind + "\" in sink model."
    )
    or
    exists(string row, string kind | sourceModel(row) |
      kind = row.splitAt(";", 7) and
      not kind = ["local", "file"] and
      result = "Invalid kind \"" + kind + "\" in source model."
    )
  }

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
      sourceModel(row) and expect = 9 and pred = "source"
      or
      sinkModel(row) and expect = 9 and pred = "sink"
      or
      summaryModel(row) and expect = 10 and pred = "summary"
      or
      negativeSummaryModel(row) and expect = 5 and pred = "negative summary"
    |
      exists(int cols |
        cols = 1 + max(int n | exists(row.splitAt(";", n))) and
        cols != expect and
        result =
          "Wrong number of columns in " + pred + " model row, expected " + expect + ", got " + cols +
            " in " + row + "."
      )
    )
  }

  private string getInvalidModelSignature() {
    exists(
      string pred, string namespace, string type, string name, string signature, string ext,
      string provenance
    |
      sourceModel(namespace, type, _, name, signature, ext, _, _, provenance) and pred = "source"
      or
      sinkModel(namespace, type, _, name, signature, ext, _, _, provenance) and pred = "sink"
      or
      summaryModel(namespace, type, _, name, signature, ext, _, _, _, provenance) and
      pred = "summary"
      or
      negativeSummaryModel(namespace, type, name, signature, provenance) and
      ext = "" and
      pred = "negative summary"
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
      or
      not provenance = ["manual", "generated"] and
      result = "Unrecognized provenance description \"" + provenance + "\" in " + pred + " model."
    )
  }

  /** Holds if some row in a CSV-based flow model appears to contain typos. */
  query predicate invalidModelRow(string msg) {
    msg =
      [
        getInvalidModelSignature(), getInvalidModelInput(), getInvalidModelOutput(),
        getInvalidModelSubtype(), getInvalidModelColumnCount(), getInvalidModelKind()
      ]
  }
}

private predicate elementSpec(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  sourceModel(namespace, type, subtypes, name, signature, ext, _, _, _)
  or
  sinkModel(namespace, type, subtypes, name, signature, ext, _, _, _)
  or
  summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _, _)
  or
  negativeSummaryModel(namespace, type, name, signature, _) and ext = "" and subtypes = false
}

private predicate elementSpec(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  UnboundValueOrRefType t
) {
  elementSpec(namespace, type, subtypes, name, signature, ext) and
  t.hasQualifiedName(namespace, type)
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

private class InterpretedCallable extends Callable {
  InterpretedCallable() {
    exists(UnboundValueOrRefType t, boolean subtypes, string name |
      elementSpec(_, _, subtypes, name, _, _, t) and
      this.hasName(name)
    |
      this.getDeclaringType() = t
      or
      subtypes = true and
      this.getDeclaringType() = t.getASubTypeUnbound+()
    )
  }
}

private string paramsStringPartA(InterpretedCallable c, int i) {
  i = -1 and result = "("
  or
  exists(int n |
    exists(c.getParameter(n)) and
    i = 2 * n - 1 and
    result = "," and
    n != 0
  )
  or
  i = 2 * c.getNumberOfParameters() and result = ")"
}

private string paramsStringPartB(InterpretedCallable c, int i) {
  exists(int n, string p, Type t |
    t = c.getParameter(n).getType() and
    i = 2 * n and
    result = p and
    p = t.getQualifiedName()
  )
}

private string paramsString(InterpretedCallable c) {
  result =
    strictconcat(int i, string s |
      s in [paramsStringPartA(c, i), paramsStringPartB(c, i)]
    |
      s order by i
    )
}

pragma[nomagic]
private Element interpretElement0(
  string namespace, string type, boolean subtypes, string name, string signature
) {
  exists(UnboundValueOrRefType t | elementSpec(namespace, type, subtypes, name, signature, _, t) |
    exists(Declaration m |
      (
        result = m
        or
        subtypes = true and result.(UnboundCallable).overridesOrImplementsUnbound(m)
      ) and
      m.getDeclaringType() = t and
      m.hasName(name)
    |
      signature = ""
      or
      paramsString(m) = signature
    )
    or
    (
      result = t
      or
      subtypes = true and
      result = t.getASubTypeUnbound+()
    ) and
    result = t and
    name = "" and
    signature = ""
  )
}

/** Gets the source/sink/summary/negativesummary element corresponding to the supplied parameters. */
Element interpretElement(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  elementSpec(namespace, type, subtypes, name, signature, ext) and
  exists(Element e | e = interpretElement0(namespace, type, subtypes, name, signature) |
    ext = "" and result = e
    or
    ext = "Attribute" and result.(Attributable).getAnAttribute().getType() = e
  )
}

/**
 * Holds if `c` has a `generated` summary.
 */
predicate hasSummary(Callable c, boolean generated) { summaryElement(c, _, _, _, generated) }

cached
private module Cached {
  /**
   * Holds if `node` is specified as a source with the given kind in a CSV flow
   * model.
   */
  cached
  predicate sourceNode(Node node, string kind) {
    exists(InterpretNode n | isSourceNode(n, kind) and n.asNode() = node)
  }

  /**
   * Holds if `node` is specified as a sink with the given kind in a CSV flow
   * model.
   */
  cached
  predicate sinkNode(Node node, string kind) {
    exists(InterpretNode n | isSinkNode(n, kind) and n.asNode() = node)
  }
}

import Cached
