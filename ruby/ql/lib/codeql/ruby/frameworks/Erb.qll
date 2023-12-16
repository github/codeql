/**
 * Provides templating for embedding Ruby code into text files, allowing dynamic content generation in web applications.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides templating for embedding Ruby code into text files, allowing dynamic content generation in web applications.
 */
module Erb {
  /**
   * Flow summary for `ERB.new`. This method wraps a template string, compiling it.
   */
  private class TemplateSummary extends SummarizedCallable {
    TemplateSummary() { this = "ERB.new" }

    override MethodCall getACall() { result = any(ErbTemplateNewCall c).asExpr().getExpr() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** A call to `ERB.new`, considered as a template construction. */
  private class ErbTemplateNewCall extends TemplateConstruction::Range, DataFlow::CallNode {
    ErbTemplateNewCall() { this = API::getTopLevelMember("ERB").getAnInstantiation() }

    override DataFlow::Node getTemplate() { result = this.getArgument(0) }
  }

  /** A call to `ERB.new(foo).result(binding)`, considered as a template rendering. */
  private class ErbTemplateRendering extends TemplateRendering::Range, DataFlow::CallNode {
    private DataFlow::Node template;

    ErbTemplateRendering() {
      exists(ErbTemplateNewCall templateConstruction |
        this = templateConstruction.getAMethodCall("result") and
        template = templateConstruction.getTemplate()
      )
    }

    override DataFlow::Node getTemplate() { result = template }
  }
}
