/**
 * Provides predicates for working with templating libraries.
 */

import javascript

module Templating {
  /**
   * Gets a string that is a known template delimiter.
   */
  string getADelimiter() {
    result =
      [
        "<%", "%>", "{#", "#}", "{$", "$}", "[%", "%]", "[[", "]]", "<?", "?>", "{{", "}}", "{%",
        "%}", "<@", "@>", "<#", "#>"
      ]
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
    override string toString() { template_placeholder_tag_info(this, _, result) }

    /** Gets the full text of the template tag, including delimiters. */
    string getRawText() { template_placeholder_tag_info(this, _, result) }

    /** Gets the enclosing HTML element, attribute, or file. */
    Locatable getParent() { template_placeholder_tag_info(this, result, _) }

    /** Gets a data flow node representing the value plugged into this placeholder. */
    DataFlow::TemplatePlaceholderTagNode asDataFlowNode() { result.getTag() = this }

    /** Gets the top-level containing the template expression to be inserted at this placeholder. */
    TemplateTopLevel getInnerTopLevel() { toplevel_parent_xml_node(result, this) }

    /**
     * Holds if this performs raw interpolation, that is, inserts its result
     * in the output without escaping it.
     */
    predicate isRawInterpolation() {
      this.getRawText()
          .regexpMatch(getLikelyTemplateSyntax(this.getFile()).getRawInterpolationRegexp())
    }

    /**
     * Holds if this performs HTML escaping on the result before inserting it in the template.
     */
    predicate isEscapingInterpolation() {
      this.getRawText()
          .regexpMatch(getLikelyTemplateSyntax(this.getFile()).getEscapingInterpolationRegexp())
    }

    /** Holds if this occurs in a `script` tag. */
    predicate isInScriptTag() {
      // We want to exclude non-code scripts like JSON.
      toplevel_parent_xml_node(any(InlineScript scr), this.getParent())
    }

    /**
     * Holds if this occurs in an attribute value that is interepted as JavaScript.
     *
     * Unlike in script tags, HTML entities in attributes are expanded prior to JS parsing,
     * which cancels out the benefit of HTML escaping.
     */
    predicate isInCodeAttribute() {
      exists(TopLevel code | code = this.getParent().(HTML::Attribute).getCodeInAttribute() |
        code instanceof EventHandlerCode or
        code instanceof JavaScriptUrl
      )
    }

    /** Holds if this placeholder occurs in JS code. */
    predicate isInCodeContext() { this.isInScriptTag() or this.isInCodeAttribute() }

    /**
     * Holds if this placeholder occurs in the definition of another template, which means the output
     * is susceptible to code injection.
     */
    predicate isInNestedTemplateContext(string templateType) {
      templateType = "AngularJS" and
      AngularJS::isInterpretedByAngularJS(this.getParent()) and
      // Exclude delimiters that coincide with those of AngularJS's own template engine.
      // It's too unlikely to happen, more likely is that one of our heuristics got it wrong.
      not this.getRawText().regexpMatch("(?s)\\{\\{.*\\}\\}")
    }

    /**
     * Gets the innermost JavaScript expression containing this template tag, if any.
     */
    pragma[nomagic]
    Expr getEnclosingExpr() {
      exists(@location loc |
        hasLocation(this, loc) and
        expr_contains_template_tag_location(result, loc)
      )
    }
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
    Identifier getIdentifier() { result = this.getChildExpr(0) }

    /** Gets the name of the pipe being referenced. */
    string getName() { result = this.getIdentifier().getName() }

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
    Expr getExpression() { result = this.getChildStmt(0).(ExprStmt).getExpr() }

    /** Gets the data flow node representing the initialization of the given variable in this scope. */
    DataFlow::Node getVariableInit(string name) {
      result = DataFlow::ssaDefinitionNode(Ssa::implicitInit(this.getScope().getVariable(name)))
    }

    /** Gets a data flow node corresponding to a use of the given template variable within this top-level. */
    DataFlow::SourceNode getAVariableUse(string name) {
      result = this.getScope().getVariable(name).getAnAccess().flow()
    }

    /** Gets a data flow node corresponding to a use of the given template variable within this top-level. */
    DataFlow::SourceNode getAnAccessPathUse(string accessPath) {
      result = this.getAVariableUse(accessPath)
      or
      exists(string varName, string suffix |
        accessPath = varName + "." + suffix and
        suffix != "" and
        result = AccessPath::getAReferenceTo(this.getAVariableUse(varName), suffix)
      )
    }
  }

  /**
   * A place where a template is instantiated or rendered.
   */
  class TemplateInstantiation extends DataFlow::Node instanceof TemplateInstantiation::Range {
    /** Gets a data flow node that refers to the instantiated template string, if any. */
    DataFlow::SourceNode getOutput() { result = super.getOutput() }

    /** Gets a data flow node that refers a template file to be instantiated, if any. */
    DataFlow::Node getTemplateFileNode() { result = super.getTemplateFileNode() }

    /** Gets a data flow node that refers to an object whose properties become variables in the template. */
    DataFlow::Node getTemplateParamsNode() { result = super.getTemplateParamsNode() }

    /** Gets a data flow node that provides the value for the template variable at the given access path. */
    DataFlow::Node getTemplateParamForValue(string accessPath) {
      result = super.getTemplateParamForValue(accessPath)
    }

    /** Gets the template file instantiated here, if any. */
    TemplateFile getTemplateFile() {
      result = this.getTemplateFileNode().(TemplateFileReference).getTemplateFile()
    }

    /**
     * Gets the template syntax used by this template instantiation, if known.
     *
     * If not known, the relevant syntax will be determined by a heuristic.
     */
    TemplateSyntax getTemplateSyntax() { result = super.getTemplateSyntax() }
  }

  /** Companion module to the `TemplateInstantiation` class. */
  module TemplateInstantiation {
    abstract class Range extends DataFlow::Node {
      /** Gets a data flow node that refers to the instantiated template, if any. */
      abstract DataFlow::SourceNode getOutput();

      /** Gets a data flow node that refers a template file to be instantiated, if any. */
      abstract DataFlow::Node getTemplateFileNode();

      /** Gets a data flow node that refers to an object whose properties become variables in the template. */
      abstract DataFlow::Node getTemplateParamsNode();

      /** Gets a data flow node that provides the value for the template variable at the given access path. */
      DataFlow::Node getTemplateParamForValue(string accessPath) { none() }

      /**
       * Gets the template syntax used by this template instantiation, if known.
       *
       * If not known, the relevant syntax will be determined by a heuristic.
       */
      TemplateSyntax getTemplateSyntax() { none() }
    }
  }

  /** Gets an API node that may flow to `succ` through a template instantiation. */
  private API::Node getTemplateInput(DataFlow::SourceNode succ) {
    exists(TemplateInstantiation inst, API::Node base, string name |
      base.asSink() = inst.getTemplateParamsNode() and
      result = base.getMember(name) and
      succ =
        inst.getTemplateFile()
            .getAnImportedFile*()
            .getAPlaceholder()
            .getInnerTopLevel()
            .getAVariableUse(name)
    )
    or
    exists(TemplateInstantiation inst, string accessPath |
      result.asSink() = inst.getTemplateParamForValue(accessPath) and
      succ =
        inst.getTemplateFile()
            .getAnImportedFile*()
            .getAPlaceholder()
            .getInnerTopLevel()
            .getAnAccessPathUse(accessPath)
    )
    or
    exists(string prop, DataFlow::SourceNode prev |
      result = getTemplateInput(prev).getMember(prop) and
      succ = prev.getAPropertyRead(prop)
    )
  }

  private class TemplateInputStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      getTemplateInput(succ).asSink() = pred
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
   * A taint step from a `TemplatePlaceholderTag` to the enclosing expression in the
   * surrounding JavaScript program.
   */
  private class PlaceholderToGeneratedCodeStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(TemplatePlaceholderTag tag |
        pred = tag.asDataFlowNode() and
        succ = tag.getEnclosingExpr().flow()
      )
    }
  }

  /** A file that can be referenced by a template instantiation. */
  abstract class TemplateFile extends File {
    /** Gets a placeholder tag in this file. */
    final TemplatePlaceholderTag getAPlaceholder() { result.getFile() = this }

    /** Gets a template file referenced by this one via a template inclusion tag, such as `{% include foo %}` */
    TemplateFile getAnImportedFile() {
      result = this.getAPlaceholder().(TemplateInclusionTag).getImportedFile()
    }
  }

  /** Any HTML file, seen as a possible target for template instantiation. */
  private class TemplateFileByExtension extends TemplateFile {
    TemplateFileByExtension() { this.getFileType().isHtml() }
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
    /** Gets the value that identifies the template. */
    string getValue() {
      result = this.getStringValue()
      or
      exists(API::Node node |
        this = node.asSink() and
        result = node.getAValueReachingSink().getStringValue()
      )
    }

    pragma[nomagic]
    private Folder getFolder() { result = this.getFile().getParentContainer() }

    /** Gets the template file referenced by this node. */
    final TemplateFile getTemplateFile() {
      result = this.getValue().(TemplateFileReferenceString).getTemplateFile(this.getFolder())
    }
  }

  /** Get file argument of a template instantiation, seen as a template file reference. */
  private class DefaultTemplateFileReference extends TemplateFileReference {
    DefaultTemplateFileReference() { this = any(TemplateInstantiation inst).getTemplateFileNode() }
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
    string getStem() { result = this.getBaseName().regexpCapture("(.*?)(?:\\.([^.]*))?", 1) }

    /** Gets the template file referenced by this string when resolved from `baseFolder`. */
    final TemplateFile getTemplateFile(Folder baseFolder) {
      result = getBestMatchingTarget(baseFolder, this)
      or
      exists(UpwardTraversalSuffix up |
        this = up.getOriginal() and
        result = up.(TemplateFileReferenceString).getTemplateFile(baseFolder.getParentContainer()) and
        baseFolder = this.getContextFolder()
      )
    }
  }

  /** The value of a template reference node, as a template reference string. */
  private class DefaultTemplateReferenceString extends TemplateFileReferenceString {
    TemplateFileReference r;

    DefaultTemplateReferenceString() { this = r.getValue().replaceAll("\\", "/") }

    // Stop optimizer from trying to share the 'getParentContainer' join
    pragma[nomagic]
    private Folder getFileReferenceFolder() {
      result = pragma[only_bind_out](r).getFile().getParentContainer()
    }

    override Folder getContextFolder() { result = this.getFileReferenceFolder() }
  }

  /** The `X` in a path of form `../X`, treated as a separate path string with a different context folder. */
  private class UpwardTraversalSuffix extends TemplateFileReferenceString {
    TemplateFileReferenceString original;

    UpwardTraversalSuffix() { original = "../" + this }

    override Folder getContextFolder() { result = original.getContextFolder().getParentContainer() }

    /** Gets the original string including the `../` prefix. */
    TemplateFileReferenceString getOriginal() { result = original }
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
   * Gets the length of the longest common prefix between `file` and the `baseFolder` of `ref`.
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
  private int getRankOfMatchingTarget(
    TemplateFile file, Folder baseFolder, TemplateFileReferenceString ref
  ) {
    file = getAMatchingTarget(ref) and
    baseFolder = ref.getContextFolder() and
    exists(string filePath, string refPath |
      // Pad each file name to ensure they differ at some index, in case one was a prefix of the other
      filePath = file.getRelativePath() + "!" and
      refPath = baseFolder.getRelativePath() + "@" and
      result = min(int i | filePath.charAt(i) != refPath.charAt(i))
    )
  }

  /**
   * Gets the template file referred to by `ref` when resolved from `baseFolder`.
   */
  private TemplateFile getBestMatchingTarget(Folder baseFolder, TemplateFileReferenceString ref) {
    result = max(getAMatchingTarget(ref) as f order by getRankOfMatchingTarget(f, baseFolder, ref))
  }

  /**
   * A syntax type implemented by one or more supported templating engines.
   *
   * The syntax type determines which templating tags perform implicit escaping.
   *
   * Since this varies between templating engines, it is important to recognize the
   * templating engine correctly.
   */
  abstract class TemplateSyntax extends string {
    bindingset[this]
    TemplateSyntax() { this = this }

    /**
     * Gets a regular expression matching the full text of a placeholder tag
     * using raw interpolation, that is, without HTML escaping.
     */
    abstract string getRawInterpolationRegexp();

    /**
     * Gets a regular expression matching the full text of a placeholder tag
     * that performs HTML escaping on its output.
     */
    abstract string getEscapingInterpolationRegexp();

    /** Gets a file extension that is specific to this templating engine. */
    abstract string getAFileExtension();

    /** Gets the name of an NPM package providing this templating syntax. */
    abstract string getAPackageName();
  }

  /**
   * Mustache-style syntax, using `{{ }}` for safe interpolation, and (in some dialects)
   * `{{{ x }}}` for raw interpolation.
   */
  private class MustacheStyleSyntax extends TemplateSyntax {
    MustacheStyleSyntax() { this = "mustache" }

    override string getRawInterpolationRegexp() {
      result = "(?s)\\{\\{\\{(.*?)\\}\\}\\}|\\{\\{&(.*?)\\}\\}"
    }

    override string getEscapingInterpolationRegexp() { result = "(?s)\\{\\{[^{&](.*?)\\}\\}" }

    override string getAFileExtension() { result = ["hbs", "njk"] }

    override string getAPackageName() {
      result =
        [
          "mustache", "handlebars", "hbs", "express-hbs", "swig", "swig-templates", "hogan",
          "hogan.js", "nunjucks"
        ]
    }
  }

  /**
   * EJS-style syntax, using `<%= x %>` for safe interpolation, and `<%- x %>` for
   * unsafe interpolation.
   */
  private class EjsStyleSyntax extends TemplateSyntax {
    EjsStyleSyntax() { this = "ejs" }

    override string getRawInterpolationRegexp() { result = "(?s)<%-(.*?)%>" }

    override string getEscapingInterpolationRegexp() { result = "(?s)<%=(.*?)%>" }

    override string getAFileExtension() { result = "ejs" }

    override string getAPackageName() { result = "ejs" }
  }

  /**
   * doT-style syntax, using `{{! }}` for safe interpolation, and `{{= }}` for
   * unsafe interpolation.
   */
  private class DotStyleSyntax extends TemplateSyntax {
    DotStyleSyntax() { this = "dot" }

    override string getRawInterpolationRegexp() { result = "(?s)\\{\\{!(.*?)\\}\\}" }

    override string getEscapingInterpolationRegexp() { result = "(?s)\\{\\{=(.*?)\\}\\}" }

    override string getAFileExtension() { result = "dot" }

    override string getAPackageName() { result = "dot" }
  }

  private TemplateSyntax getOwnTemplateSyntaxInFolder(Folder f) {
    exists(PackageDependencies deps |
      deps.getADependency(result.getAPackageName(), _) and
      f = deps.getFile().getParentContainer()
    )
  }

  private TemplateSyntax getTemplateSyntaxInFolder(Folder f) {
    result = getOwnTemplateSyntaxInFolder(f)
    or
    not exists(getOwnTemplateSyntaxInFolder(f)) and
    result = getTemplateSyntaxInFolder(f.getParentContainer())
  }

  private TemplateSyntax getTemplateSyntaxFromInstantiation(TemplateFile file) {
    result = any(TemplateInstantiation inst | inst.getTemplateFile() = file).getTemplateSyntax()
  }

  /**
   * Gets a template syntax likely to be used in the given file.
   */
  TemplateSyntax getLikelyTemplateSyntax(TemplateFile file) {
    result = getTemplateSyntaxFromInstantiation(file)
    or
    not exists(getTemplateSyntaxFromInstantiation(file)) and
    result.getAFileExtension() = file.getExtension()
    or
    not exists(getTemplateSyntaxFromInstantiation(file)) and
    not file.getExtension() = any(TemplateSyntax s).getAFileExtension() and
    result = getTemplateSyntaxInFolder(file.getParentContainer())
  }

  /** A step through the `safe` pipe, which bypasses HTML escaping. */
  private class SafePipeStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = getAPipeCall("safe") and
        pred = call.getArgument(0) and
        succ = call
      )
    }
  }

  /**
   * An EJS-style `include` call within a template tag, such as `<%- include(file, { params }) %>`.
   */
  private class EjsIncludeCallInTemplate extends TemplateInstantiation::Range, DataFlow::CallNode {
    EjsIncludeCallInTemplate() {
      exists(TemplatePlaceholderTag tag |
        tag.getRawText().regexpMatch("(?s)<%-.*") and
        this = tag.getInnerTopLevel().getAVariableUse("include").getACall()
      )
    }

    /** Gets a data flow node that refers to the instantiated template, if any. */
    override DataFlow::SourceNode getOutput() { result = this }

    /** Gets a data flow node that refers a template file to be instantiated, if any. */
    override DataFlow::Node getTemplateFileNode() { result = this.getArgument(0) }

    /** Gets a data flow node that refers to an object whose properties become variables in the template. */
    override DataFlow::Node getTemplateParamsNode() { result = this.getArgument(1) }
  }

  /**
   * The `include` function, seen as an API node, so we can treat it as a template instantiation
   * in `EjsIncludeCallInTemplate`.
   *
   * These API nodes are used in the `getTemplateInput` predicate.
   */
  private class IncludeFunctionAsEntryPoint extends API::EntryPoint {
    IncludeFunctionAsEntryPoint() { this = "IncludeFunctionAsEntryPoint" }

    override DataFlow::SourceNode getASource() {
      result = any(TemplatePlaceholderTag tag).getInnerTopLevel().getAVariableUse("include")
    }
  }

  /**
   * A template tag which causes another template file to be instantiated using the same variables as the current one.
   *
   * Examples:
   * - `{% include foo/bar %}`
   * - `{% include "../foo/bar.html" %}`
   * - `<% include foo/bar %>`
   * - `{{!< foo/bar }}`
   * - `{{> foo/bar }}`
   */
  class TemplateInclusionTag extends TemplatePlaceholderTag {
    string rawPath;

    TemplateInclusionTag() {
      rawPath =
        this.getRawText()
            .regexpCapture("[{<]% *(?:import|include|extend|require)s? *(?:[(] *)?['\"]?(.*?)['\"]? *(?:[)] *)?%[}>]",
              1)
      or
      rawPath = this.getRawText().regexpCapture("\\{\\{!?[<>](.*?)\\}\\}", 1)
    }

    /** Gets the imported path (normalized). */
    string getPath() { result = rawPath.trim().replaceAll("\\", "/").regexpReplaceAll("^\\./", "") }

    /** Gets the file referenced by this inclusion tag. */
    TemplateFile getImportedFile() {
      result =
        this.getPath()
            .(TemplateFileReferenceString)
            .getTemplateFile(this.getFile().getParentContainer())
    }
  }

  /** The imported string from a template inclusion tag. */
  private class TemplateInclusionPathString extends TemplateFileReferenceString {
    TemplateInclusionTag tag;

    TemplateInclusionPathString() { this = tag.getPath() }

    override Folder getContextFolder() { result = tag.getFile().getParentContainer() }
  }

  /**
   * A call to a member of the `consolidate` library, seen as a template instantiation.
   */
  private class ConsolidateCall extends TemplateInstantiation::Range, API::CallNode {
    string engine;

    ConsolidateCall() { this = API::moduleImport("consolidate").getMember(engine).getACall() }

    override TemplateSyntax getTemplateSyntax() { result.getAPackageName() = engine }

    override DataFlow::SourceNode getOutput() {
      result = this.getParameter([1, 2]).getParameter(1).asSource()
      or
      not exists(this.getParameter([1, 2]).getParameter(1)) and
      result = this
    }

    override DataFlow::Node getTemplateFileNode() { result = this.getArgument(0) }

    override DataFlow::Node getTemplateParamsNode() { result = this.getArgument(1) }
  }
}
