/** Provides the `TargetFrameworkAttribute` class for querying the target framework. */

import csharp

/**
 * An attribute of type `System.Runtime.Versioning.TargetFrameworkAttribute`,
 * specifying the target framework of an assembly. For example
 *
 * ```csharp
 * [assembly: TargetFramework(".NETFramework,Version=v4.6.1")]
 * ```
 */
class TargetFrameworkAttribute extends Attribute {
  Assembly assembly;

  TargetFrameworkAttribute() {
    this.getType().hasFullyQualifiedName("System.Runtime.Versioning", "TargetFrameworkAttribute") and
    assembly = this.getTarget()
  }

  /**
   * Gets the framework name of this attribute. For example, the framework name of
   * ```csharp
   * [assembly: TargetFramework(".NETFramework,Version=v4.6.1")]
   * ```
   * is `".NETFramework,Version=v4.6.1"`.
   */
  string getFrameworkName() { result = this.getArgument(0).getValue() }

  private string frameworkCapture(int n) {
    result = this.getFrameworkName().regexpCapture("([^,]+),Version=v(.+)", n)
  }

  /**
   * Gets the framework type of this attribute. For example, the framework type of
   * ```csharp
   * [assembly: TargetFramework(".NETFramework,Version=v4.6.1")]
   * ```
   * is `".NETFramework"`. Other framework types include `".NETStandard"` and `".NETCoreApp"`.
   */
  string getFrameworkType() { result = this.frameworkCapture(1) }

  /**
   * Gets the framework version of this attribute. For example, the framework version of
   * ```csharp
   * [assembly: TargetFramework(".NETFramework,Version=v4.6.1")]
   * ```
   * is `"4.6.1"`. Note that you can use the `Version` class to compare versions, for example
   * `target.getFrameworkVersion().isEarlierThan("4.6")`.
   */
  Version getFrameworkVersion() { result = this.frameworkCapture(2) }

  /** Holds if the framework type is .NET Desktop. */
  predicate isNetFramework() { this.getFrameworkType() = ".NETFramework" }

  /** Holds if the framework type is .NET Standard. */
  predicate isNetStandard() { this.getFrameworkType() = ".NETStandard" }

  /** Holds if the framework type is .NET Core. */
  predicate isNetCore() { this.getFrameworkType() = ".NETCoreApp" }

  /**
   * Holds if element `e` specifies this target version, because it is
   * compiled in the assembly of this attribute.
   */
  predicate hasElement(Element e) { assembly = e.getALocation() }
}
