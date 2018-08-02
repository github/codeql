/** Provides definitions related to the namespace `System.Windows.Forms`. */
import csharp
private import semmle.code.csharp.frameworks.system.Windows

/** The `System.Windows.Forms` namespace. */
class SystemWindowsFormsNamespace extends Namespace {
  SystemWindowsFormsNamespace() {
    this.getParentNamespace() instanceof SystemWindowsNamespace and
    this.hasName("Forms")
  }
}

/** A class in the `System.Windows.Forms` namespace. */
class SystemWindowsFormsClass extends Class {
  SystemWindowsFormsClass() {
    this.getNamespace() instanceof SystemWindowsFormsNamespace
  }
}

/** The `System.Windows.Forms.HtmlElement` class. */
class SystemWindowsFormsHtmlElement extends SystemWindowsFormsClass {
  SystemWindowsFormsHtmlElement() {
    this.hasName("HtmlElement")
  }

  /** Gets the `SetAttribute` method. */
  Method getSetAttributeMethod() {
    result = this.getAMethod("SetAttribute")
  }
}
