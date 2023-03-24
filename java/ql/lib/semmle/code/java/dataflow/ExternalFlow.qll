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
 *   `package; type; name; signature; provenance`
 *   A neutral is used to indicate that there is no flow via a callable.
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
 *    element selected by the first 6 columns. An `input` can be either "",
 *    "Argument[n]", "Argument[n1..n2]", "ReturnValue":
 *    - "": Selects a write to the selected element in case this is a field.
 *    - "Argument[n]": Selects an argument in a call to the selected element.
 *      The arguments are zero-indexed, and `this` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects a value being returned by the selected element.
 *      This requires that the selected element is a method with a body.
 *
 *    An `output` can be either "", "Argument[n]", "Argument[n1..n2]", "Parameter",
 *    "Parameter[n]", "Parameter[n1..n2]", or "ReturnValue":
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
 * 8. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources "remote" indicates a default remote flow source, and for summaries
 *    "taint" indicates a default additional taint step and "value" indicates a
 *    globally applicable value-preserving step.
 * 9. The `provenance` column is a tag to indicate the origin of the summary.
 *    The supported values are: "manual", "generated" and "ai-generated". "manual"
 *    means that the model has been written by hand, "generated" means that
 *    the model has been emitted by the model generator tool and
 *    "ai-generated" means that the model has been AI generated (ATM project).
 */

import java
private import semmle.code.java.dataflow.DataFlow::DataFlow
private import internal.DataFlowPrivate
private import internal.FlowSummaryImpl::Private::External
private import internal.FlowSummaryImplSpecific as FlowSummaryImplSpecific
private import internal.AccessPathSyntax
private import ExternalFlowExtensions as Extensions
private import FlowSummary

/**
 * A class for activating additional model rows.
 *
 * Extend this class to include experimental model rows with `this` name
 * in data flow analysis.
 */
abstract class ActiveExperimentalModels extends string {
  bindingset[this]
  ActiveExperimentalModels() { any() }

  /**
   * Holds if an experimental source model exists for the given parameters.
   */
  predicate sourceModel(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string output, string kind, string provenance
  ) {
    Extensions::experimentalSourceModel(package, type, subtypes, name, signature, ext, output, kind,
      provenance, this)
  }

  /**
   * Holds if an experimental sink model exists for the given parameters.
   */
  predicate sinkModel(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string output, string kind, string provenance
  ) {
    Extensions::experimentalSinkModel(package, type, subtypes, name, signature, ext, output, kind,
      provenance, this)
  }

  /**
   * Holds if an experimental summary model exists for the given parameters.
   */
  predicate summaryModel(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string input, string output, string kind, string provenance
  ) {
    Extensions::experimentalSummaryModel(package, type, subtypes, name, signature, ext, input,
      output, kind, provenance, this)
  }
}

/** Holds if a source model exists for the given parameters. */
predicate sourceModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
) {
  Extensions::sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance)
  or
  any(ActiveExperimentalModels q)
      .sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance)
}

/** Holds if a sink model exists for the given parameters. */
predicate sinkModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
) {
  Extensions::sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance)
  or
  any(ActiveExperimentalModels q)
      .sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance)
}

/** Holds if a summary model exists for the given parameters. */
predicate summaryModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
) {
  Extensions::summaryModel(package, type, subtypes, name, signature, ext, input, output, kind,
    provenance)
  or
  any(ActiveExperimentalModels q)
      .summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance)
}

/** Holds if a neutral model exists indicating there is no flow for the given parameters. */
predicate neutralModel = Extensions::neutralModel/5;

private predicate relevantPackage(string package) {
  sourceModel(package, _, _, _, _, _, _, _, _) or
  sinkModel(package, _, _, _, _, _, _, _, _) or
  summaryModel(package, _, _, _, _, _, _, _, _, _)
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
 * kind `(kind, part)`.
 */
predicate modelCoverage(string package, int pkgs, string kind, string part, int n) {
  pkgs = strictcount(string subpkg | canonicalPkgLink(package, subpkg)) and
  (
    part = "source" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string output, string provenance |
        canonicalPkgLink(package, subpkg) and
        sourceModel(subpkg, type, subtypes, name, signature, ext, output, kind, provenance)
      )
    or
    part = "sink" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string provenance |
        canonicalPkgLink(package, subpkg) and
        sinkModel(subpkg, type, subtypes, name, signature, ext, input, kind, provenance)
      )
    or
    part = "summary" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string output, string provenance |
        canonicalPkgLink(package, subpkg) and
        summaryModel(subpkg, type, subtypes, name, signature, ext, input, output, kind, provenance)
      )
  )
}

/** Provides a query predicate to check the MaD models for validation errors. */
module ModelValidation {
  private string getInvalidModelInput() {
    exists(string pred, AccessPath input, AccessPathToken part |
      sinkModel(_, _, _, _, _, _, input, _, _) and pred = "sink"
      or
      summaryModel(_, _, _, _, _, _, input, _, _, _) and pred = "summary"
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
      sourceModel(_, _, _, _, _, _, output, _, _) and pred = "source"
      or
      summaryModel(_, _, _, _, _, _, _, output, _, _) and pred = "summary"
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

  private string getInvalidModelKind() {
    exists(string kind | summaryModel(_, _, _, _, _, _, _, _, kind, _) |
      not kind = ["taint", "value"] and
      result = "Invalid kind \"" + kind + "\" in summary model."
    )
    or
    exists(string kind | sinkModel(_, _, _, _, _, _, _, kind, _) |
      not kind =
        [
          "open-url", "jndi-injection", "ldap", "sql", "jdbc-url", "logging", "mvel", "xpath",
          "groovy", "xss", "ognl-injection", "intent-start", "pending-intent-sent",
          "url-open-stream", "url-redirect", "create-file", "read-file", "write-file",
          "set-hostname-verifier", "header-splitting", "information-leak", "xslt", "jexl",
          "bean-validation", "ssti", "fragment-injection"
        ] and
      not kind.matches("regex-use%") and
      not kind.matches("qltest%") and
      result = "Invalid kind \"" + kind + "\" in sink model."
    )
    or
    exists(string kind | sourceModel(_, _, _, _, _, _, _, kind, _) |
      not kind = ["remote", "contentprovider", "android-widget", "android-external-storage-dir"] and
      not kind.matches("qltest%") and
      result = "Invalid kind \"" + kind + "\" in source model."
    )
  }

  private string getInvalidModelSignature() {
    exists(
      string pred, string package, string type, string name, string signature, string ext,
      string provenance
    |
      sourceModel(package, type, _, name, signature, ext, _, _, provenance) and pred = "source"
      or
      sinkModel(package, type, _, name, signature, ext, _, _, provenance) and pred = "sink"
      or
      summaryModel(package, type, _, name, signature, ext, _, _, _, provenance) and
      pred = "summary"
      or
      neutralModel(package, type, name, signature, provenance) and
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
      not provenance = ["manual", "generated", "ai-generated"] and
      result = "Unrecognized provenance description \"" + provenance + "\" in " + pred + " model."
    )
  }

  /** Holds if some row in a MaD flow model appears to contain typos. */
  query predicate invalidModelRow(string msg) {
    msg =
      [
        getInvalidModelSignature(), getInvalidModelInput(), getInvalidModelOutput(),
        getInvalidModelKind()
      ]
  }
}

pragma[nomagic]
private predicate elementSpec(
  string package, string type, boolean subtypes, string name, string signature, string ext
) {
  sourceModel(package, type, subtypes, name, signature, ext, _, _, _)
  or
  sinkModel(package, type, subtypes, name, signature, ext, _, _, _)
  or
  summaryModel(package, type, subtypes, name, signature, ext, _, _, _, _)
  or
  neutralModel(package, type, name, signature, _) and ext = "" and subtypes = false
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
    "(" + concat(int i | | c.getParameterType(i).getErasure().toString(), "," order by i) + ")"
}

private Element interpretElement0(
  string package, string type, boolean subtypes, string name, string signature
) {
  elementSpec(package, type, subtypes, name, signature, _) and
  exists(RefType t | t.hasQualifiedName(package, type) |
    exists(Member m |
      (
        result = m
        or
        subtypes = true and result.(SrcMethod).overridesOrInstantiates+(m)
      ) and
      m.getDeclaringType() = t and
      m.hasName(name)
    |
      signature = "" or
      m.(Callable).getSignature() = any(string nameprefix) + signature or
      paramsString(m) = signature
    )
    or
    (if subtypes = true then result.(SrcRefType).getASourceSupertype*() = t else result = t) and
    name = "" and
    signature = ""
  )
}

/** Gets the source/sink/summary/neutral element corresponding to the supplied parameters. */
Element interpretElement(
  string package, string type, boolean subtypes, string name, string signature, string ext
) {
  elementSpec(package, type, subtypes, name, signature, ext) and
  exists(Element e | e = interpretElement0(package, type, subtypes, name, signature) |
    ext = "" and result = e
    or
    ext = "Annotated" and result.(Annotatable).getAnAnnotation().getType() = e
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
  predicate sourceNode(Node node, string kind) {
    exists(FlowSummaryImplSpecific::InterpretNode n | isSourceNode(n, kind) and n.asNode() = node)
  }

  /**
   * Holds if `node` is specified as a sink with the given kind in a MaD flow
   * model.
   */
  cached
  predicate sinkNode(Node node, string kind) {
    exists(FlowSummaryImplSpecific::InterpretNode n | isSinkNode(n, kind) and n.asNode() = node)
  }
}

import Cached
