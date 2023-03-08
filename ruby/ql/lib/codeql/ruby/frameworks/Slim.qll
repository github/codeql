/**
 * Provides templating for embedding Ruby code into text files, allowing dynamic content generation in web applications.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides templating for embedding Ruby code into text files, allowing dynamic content generation in web applications.
 */
module Slim {
  /** A call to `Slim::Template.new`, considered as a template construction. */
  private class SlimTemplateNewCall extends TemplateConstruction::Range, DataFlow::CallNode {
    SlimTemplateNewCall() {
      this = API::getTopLevelMember("Slim").getMember("Template").getAnInstantiation()
    }

    override DataFlow::Node getTemplate() {
      result.asExpr().getExpr() =
        this.getBlock().(DataFlow::BlockNode).asCallableAstNode().getAStmt()
    }
  }

  /** A call to `Slim::Template.new{ foo }.render`, considered as a template rendering */
  private class SlimTemplateRendering extends TemplateRendering::Range, DataFlow::CallNode {
    private DataFlow::Node template;

    SlimTemplateRendering() {
      exists(SlimTemplateNewCall templateConstruction |
        this = templateConstruction.getAMethodCall("render") and
        template = templateConstruction.getTemplate()
      )
    }

    override DataFlow::Node getTemplate() { result = template }
  }
}
