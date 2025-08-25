/** Provides definitions related to the namespace `System.Diagnostics.CodeAnalysis`. */

private import csharp

/** An attribute of type `System.Diagnostics.CodeAnalysis.ExperimentalAttribute`. */
class ExperimentalAttribute extends Attribute {
  ExperimentalAttribute() {
    this.getType().hasFullyQualifiedName("System.Diagnostics.CodeAnalysis", "ExperimentalAttribute")
  }

  /**
   * Gets the diagnostic ID.
   */
  string getId() { result = this.getConstructorArgument(0).getValue() }
}
