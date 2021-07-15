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
}
