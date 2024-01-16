/**
 * Provides modeling for the `view_component` gem.
 */

private import codeql.ruby.AST

/**
 * Provides modeling for the `view_component` gem.
 */
module ViewComponent {
  /**
   * A subclass of `ViewComponent::Base`.
   */
  class ComponentClass extends Module {
    ComponentClass() { this.getAnAncestor().getQualifiedName() = "ViewComponent::Base" }

    /**
     * Returns the template file for this component.
     */
    ErbFile getTemplate() {
      result.getAbsolutePath() =
        this.getADeclaration()
            .getLocation()
            .getFile()
            .getAbsolutePath()
            .replaceAll(".rb", ".html.erb")
    }
  }
}
