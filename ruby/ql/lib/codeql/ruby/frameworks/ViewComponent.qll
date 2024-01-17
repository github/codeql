private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.SSA
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/**
 * Provides modeling for the `view_component` gem.
 */
module ViewComponent {
  /**
   * A subclass of `ViewComponent::Base`.
   */
  class ComponentClass extends DataFlow::ClassNode {
    ComponentClass() {
      this = DataFlow::getConstant("ViewComponent").getConstant("Base").getADescendentModule()
    }

    /**
     * Returns the template file for this component.
     */
    ErbFile getTemplate() {
      result.getAbsolutePath() =
        this.getLocation().getFile().getAbsolutePath().replaceAll(".rb", ".html.erb")
    }
  }

  /**
   * An additional jump step from a `ComponentClass` passed as an argument in a call to `render`
   * to the `self` variable in its corresponding template.
   */
  private predicate jumpStep(DataFlow::Node node1, DataFlowPrivate::SsaSelfDefinitionNode node2) {
    exists(DataFlow::CallNode call, ComponentClass component |
      call.getMethodName() = "render" and
      call.getArgument(0) = node1 and
      component.trackInstance().getAValueReachableFromSource() = node1 and
      node2.getLocation().getFile() = component.getTemplate() and
      node2.getSelfScope() instanceof Toplevel and
      node2.getDefinitionExt() instanceof Ssa::SelfDefinition
    )
  }
}
