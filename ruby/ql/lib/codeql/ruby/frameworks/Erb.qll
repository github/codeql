/**
 * Provides templating for embedding Ruby code into text files, allowing dynamic content generation in web applications.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides templating for embedding Ruby code into text files, allowing dynamic content generation in web applications.
 */
module ERB {
  /**
   * Flow summary for `ERB.new`. This method wraps a template string, compiling it.
   */
  private class TemplateSummary extends SummarizedCallable {
    TemplateSummary() { this = "ERB.new" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("ERB").getAMethodCall("new").asExpr().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** A call to `ERB.new`, considered as a template construction. */
  private class ERBTemplateNewCall extends TemplateConstruction::Range, DataFlow::CallNode {
    ERBTemplateNewCall() { this = API::getTopLevelMember("ERB").getAMethodCall("new") }

    override DataFlow::Node getTemplate() { result = this.getArgument(0) }
  }

  /** A call to `ERB.new(foo).result(binding)`, considered as a template rendering. */
  private class ERBTemplateRendering extends TemplateRendering::Range, DataFlow::CallNode {
    DataFlow::Node template;

    ERBTemplateRendering() {
      exists(ERBTemplateNewCall templateConstruction |
        this = templateConstruction.getAMethodCall("result") and
        template = templateConstruction.getTemplate()
      )
    }

    override DataFlow::Node getTemplate() { result = template }
  }
}
