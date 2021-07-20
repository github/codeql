/**
 * Provides predicates for working with templating libraries.
 */

import javascript

module Templating {
  /**
   * Gets a string that is a known template delimiter.
   */
  string getADelimiter() {
    result = "<%" or
    result = "%>" or
    result = "{{" or
    result = "}}" or
    result = "{%" or
    result = "%}" or
    result = "<@" or
    result = "@>" or
    result = "<#" or
    result = "#>" or
    result = "{#" or
    result = "#}" or
    result = "{$" or
    result = "$}" or
    result = "[%" or
    result = "%]" or
    result = "[[" or
    result = "]]" or
    result = "<?" or
    result = "?>"
  }

  /**
   * Gets a regular expression that matches a string containing one
   * of the known template delimiters identified by `getADelimiter()`,
   * storing it in its first (and only) capture group.
   */
  string getDelimiterMatchingRegexp() { result = getDelimiterMatchingRegexpWithPrefix(".*") }

  /**
   * Gets a regular expression that matches a string containing one
   * of the known template delimiters identified by `getADelimiter()`,
   * storing it in its first (and only) capture group.
   * Where the string prior to the template delimiter matches the regexp `prefix`.
   */
  bindingset[prefix]
  string getDelimiterMatchingRegexpWithPrefix(string prefix) {
    result = "(?s)" + prefix + "(" + concat("\\Q" + getADelimiter() + "\\E", "|") + ").*"
  }

  /** A placeholder tag for a templating engine. */
  class TemplatePlaceholderTag extends @template_placeholder_tag, Locatable {
    override Location getLocation() { hasLocation(this, result) }

    override string toString() { template_placeholder_tag_info(this, _, result) }

    /** Gets the full text of the template tag, including delimiters. */
    string getRawText() { template_placeholder_tag_info(this, _, result) }

    /** Gets the enclosing HTML element, attribute, or file. */
    Locatable getParent() { template_placeholder_tag_info(this, result, _) }

    /** Gets a data flow node representing the value plugged into this placeholder. */
    DataFlow::TemplatePlaceholderTagNode asDataFlowNode() { result.getTag() = this }

    /** Gets the top-level containing the template expression to be inserted at this placeholder. */
    TemplateTopLevel getInnerTopLevel() { toplevel_parent_xml_node(result, this) }
  }

  /**
   * A reference to a pipe function, occurring in a pipe expression
   * that has been desugared to a function call.
   *
   * For example, the expression `x | f: y` is desugared to `f(x, y)` where
   * `f` is a `PipeRefExpr`.
   */
  class PipeRefExpr extends Expr, @template_pipe_ref {
    /** Gets the identifier node naming the pipe. */
    Identifier getIdentifier() { result = getChildExpr(0) }

    /** Gets the name of the pipe being referenced. */
    string getName() { result = getIdentifier().getName() }

    override string getAPrimaryQlClass() { result = "Templating::PipeRefExpr" }
  }

  /**
   * Gets an invocation of the pipe of the given name.
   *
   * For example, the call generated from `items | async` would be found by `getAPipeCall("async")`.
   */
  DataFlow::CallNode getAPipeCall(string name) {
    result.getCalleeNode().asExpr().(PipeRefExpr).getName() = name
  }

  /**
   * A reference to a variable in a template expression, corresponding
   * to a value plugged into the template.
   */
  class TemplateVarRefExpr extends Expr {
    TemplateVarRefExpr() { this = any(TemplateTopLevel tl).getScope().getAVariable().getAnAccess() }
  }

  /** The top-level containing the expression in a template placeholder. */
  class TemplateTopLevel extends TopLevel, @template_toplevel {
    /** Gets the expression in this top-level. */
    Expr getExpression() { result = getChildStmt(0).(ExprStmt).getExpr() }

    /** Gets the data flow node representing the initialization of the given variable in this scope. */
    DataFlow::Node getVariableInit(string name) {
      result = DataFlow::ssaDefinitionNode(SSA::implicitInit(getScope().getVariable(name)))
    }

    /** Gets a data flow node corresponding to a use of the given template variable within this top-level. */
    DataFlow::SourceNode getAVariableUse(string name) {
      result = getScope().getVariable(name).getAnAccess().flow()
    }
  }

  /**
   * A place where a template is instantiated or rendered.
   */
  class TemplateInstantiaton extends DataFlow::Node {
    TemplateInstantiaton::Range range;
  
    TemplateInstantiaton() { this = range }

    /** Gets a data flow node that refers to the instantiated template string, if any. */
    DataFlow::SourceNode getOutput() { result = range.getOutput() }

    /** Gets a data flow node that refers a template file to be instantiated, if any. */
    DataFlow::Node getTemplateFileNode() { result = range.getTemplateFileNode() }

    /** Gets a data flow node that refers to the contents of the template to be instantiated, if any. */
    DataFlow::Node getTemplateContentNode() { result = range.getTemplateContentNode() }

    /** Gets a data flow node that refers to an object whose properties become variables in the template. */
    DataFlow::Node getTemplateParamsNode() { result = range.getTemplateParamsNode() }

    /** Gets the template file instantiated here, if any. */
    TemplateFile getTemplateFile() {
      result = getTemplateFileNode().(TemplateFileReference).getTemplateFile()
    }
  }

  /** Companion module to the `TemplateInstantiation` class. */
  module TemplateInstantiaton {
    abstract class Range extends DataFlow::Node {
      /** Gets a data flow node that refers to the instantiated template, if any. */
      abstract DataFlow::SourceNode getOutput();
  
      /** Gets a data flow node that refers a template file to be instantiated, if any. */
      abstract DataFlow::Node getTemplateFileNode();
  
      /** Gets a data flow node that refers to the contents of the template to be instantiated, if any. */
      abstract DataFlow::Node getTemplateContentNode();
  
      /** Gets a data flow node that refers to an object whose properties become variables in the template. */
      abstract DataFlow::Node getTemplateParamsNode();
    }
  }

  /** Gets an API node that may flow to `succ` through a template instantiation. */
  private API::Node getTemplateInput(DataFlow::SourceNode succ) {
    exists(TemplateInstantiaton inst, API::Node base, string name |
      base.getARhs() = inst.getTemplateParamsNode() and
      result = base.getMember(name) and
      succ = inst.getTemplateFile().getAPlaceholder().getInnerTopLevel().getAVariableUse(name)
    )
    or
    exists(string prop, DataFlow::SourceNode prev |
      result = getTemplateInput(prev).getMember(prop) and
      succ = prev.getAPropertyRead(prop)
    )
  }

  private class TemplateInputStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      getTemplateInput(succ).getARhs() = pred
    }
  }

  /**
   * A data flow step from the expression in a placeholder tag to the tag itself,
   * representing the value plugged into the template.
   */
  private class TemplatePlaceholderStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(TemplatePlaceholderTag tag |
        pred = tag.getInnerTopLevel().getExpression().flow() and
        succ = tag.asDataFlowNode()
      )
    }
  }

  /**
   * A taint step from a `TemplatePlaceholderTag` to the corresponding `GeneratedCodeExpr`,
   * representing that control over the generated code gives control over the expression
   * return value.
   */
  private class PlaceholderToGeneratedCodeStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(GeneratedCodeExpr expr |
        pred = expr.getPlaceholderTag().asDataFlowNode() and
        succ = expr.flow()
      )
    }
  }

  /** A file that can be referenced by a template instantiation. */
  abstract class TemplateFile extends File {
    /** Gets a placeholder tag in this file. */
    final TemplatePlaceholderTag getAPlaceholder() { result.getFile() = this }
  }

  /** Any HTML file, seen as a possible target for template instantiation. */
  private class TemplateFileByExtension extends TemplateFile {
    TemplateFileByExtension() { getFileType().isHtml() }
  }

  /**
   * A data flow node whose string value refers to a template file.
   *
   * This is similar to `PathExpr` with two main differences:
   * - It is not used for import resolution, and so can be computed in a later stage.
   * - The root folder is considered unknown, and so a heuristic is used to guess the most
   *   likely template file being referenced.
   */
  abstract class TemplateFileReference extends DataFlow::Node {
    /** Gets the value that identifies the template. Defaults to `getStringValue()`. */
    string getValue() { result = getStringValue() }

    /** Gets the template file referenced by this node. */
    final TemplateFile getTemplateFile() {
      result = this.getValue().(TemplateFileReferenceString).getTemplateFile()
    }
  }

  /** Get file argument of a template instantiation, seen as a template file reference. */
  private class DefaultTemplateFileReference extends TemplateFileReference {
    DefaultTemplateFileReference() {
      this = any(TemplateInstantiaton inst).getTemplateFileNode()
    }
  }

  /**
   * A string that refers to a template file, and should be resolved as such.
   *
   * The string must be normalized, with backslashes replaced by forward slashes.
   *
   * This is automatically populated for instances of `TemplateFileReference`, but additional subclasses
   * may be added if other strings need to be resolved.
   *
   * This is similar to `PathString` with two main differences:
   * - It is not used for import resolution, and so can be computed in a later stage.
   * - The root folder is considered unknown, and so a heuristic is used to guess the most
   *   likely template file being referenced.
   */
  abstract class TemplateFileReferenceString extends string {
    bindingset[this]
    TemplateFileReferenceString() { this = this }

    /** Gets the folder in which this string occurs, used to determine which file it could refer to. */
    abstract Folder getContextFolder();

    /**
     * Gets the base name of the string, similar to `Container.getBaseName`.
     */
    string getBaseName() { result = this.regexpReplaceAll(".*/", "") }

    /**
     * Gets the stem, similar to `Container.getStem`.
     */
    string getStem() { result = getBaseName().regexpCapture("(.*?)(?:\\.([^.]*))?", 1) }

    /** Gets the template file referenced by this string. */
    final TemplateFile getTemplateFile() { result = getBestMatchingTarget(this) }
  }

  /** The value of a template reference node, as a template reference string. */
  private class DefaultTemplateReferenceString extends TemplateFileReferenceString {
    TemplateFileReference r;

    DefaultTemplateReferenceString() { this = r.getValue().replaceAll("\\", "/") }

    override Folder getContextFolder() { result = r.getFile().getParentContainer() }
  }

  /**
   * Gets a "fingerprint" for the given template file, which is used to references
   * that might refer to it (for pruning purposes only).
   */
  pragma[nomagic]
  private string getTemplateFileFingerprint(TemplateFile file) {
    result = file.getStem()
    or
    file.getStem() = "index" and
    result = file.getParentContainer().getBaseName()
  }

  /**
   * Gets a "fingerprint" for the given string, which must match one of the fingerprints of
   * the referenced file (for pruning purposes only).
   */
  pragma[nomagic]
  private string getTemplateRefFingerprint(TemplateFileReferenceString ref) {
    result = ref.getStem() and not result = ["index", ""]
    or
    ref.getStem() = ["index", ""] and
    result = ref.regexpCapture("(?:.*)?/([^/]*)/(?:index|)(?:\\.[^.]*)?", 1)
    or
    // If the reference is just 'index', it could potentially refer to any template file
    // called 'index' -- we can't use the parent directory to prune candidates early.
    ref = "index" and result = "index"
  }

  /**
   * Gets a template file that could potentially be the target of `ref`, based on
   * them having the same fingerprint.
   *
   * This is only used to speed up `getAMatchingTarget` by pruning out pairs that can't match.
   */
  pragma[nomagic]
  private TemplateFile getAPotentialTarget(TemplateFileReferenceString ref) {
    getTemplateFileFingerprint(result) = getTemplateRefFingerprint(ref)
  }

  /**
   * Gets a template file whose path matches the given `ref`.
   *
   * A file matches if all path components of `ref` are part of the suffix of the file path,
   * and in case a file extension is mentioned in `ref`, this must match that of the file.
   *
   * For example, a file at `src/foo/views/bar/baz.html` would be matched by the following:
   * - `bar.html`
   * - `bar/baz.html`
   * - `views/bar/baz.html`
   * - `baz` (extension can be omitted)
   * - `bar/baz`
   *
   * But would not be matched by:
   * - `foo/baz.html` (folder does not match)
   * - `baz.ejs` (extension does not match)
   *
   * Additionally, a file whose stem is `index` matches if `ref` would match the parent folder by
   * the above rules. For example: `bar` matches `src/bar/index.html`.
   */
  pragma[nomagic]
  private TemplateFile getAMatchingTarget(TemplateFileReferenceString ref) {
    result = getAPotentialTarget(ref) and
    result.getAbsolutePath() =
      any(string s) + ref + ["", "/index"] + ["", "." + result.getExtension()]
  }

  /**
   * Gets the length of the longest common prefix between `file` and `ref`.
   *
   * This is used to rank all the possible files that `ref` could refer to.
   * Picking the one with the highest rank ensures that the file most closely related
   * in the file hierarchy is picked.
   *
   * For example, given the files:
   * ```
   * A/components/foo.js
   * A/views/list.html
   * B/components/foo.js
   * B/views/list.html
   * ```
   * The string `list` in `A/components/foo.js` will resolve to `A/views/list.html`,
   * and vice versa in `B/components/foo.js`.
   */
  pragma[nomagic]
  private int getRankOfMatchingTarget(TemplateFile file, TemplateFileReferenceString ref) {
    file = getAMatchingTarget(ref) and
    exists(string filePath, string refPath |
      // Pad each file name to ensure they differ at some index, in case one was a prefix of the other
      filePath = file.getRelativePath() + "!" and
      refPath = ref.getContextFolder().getRelativePath() + "@" and
      result = min(int i | filePath.charAt(i) != refPath.charAt(i))
    )
  }

  /**
   * Gets the template file referred to by `ref`.
   */
  private TemplateFile getBestMatchingTarget(TemplateFileReferenceString ref) {
    result = max(getAMatchingTarget(ref) as f order by getRankOfMatchingTarget(f, ref))
  }
}
