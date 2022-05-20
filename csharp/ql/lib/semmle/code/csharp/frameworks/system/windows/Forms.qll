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
  SystemWindowsFormsClass() { this.getNamespace() instanceof SystemWindowsFormsNamespace }
}

/** The `System.Windows.Forms.HtmlElement` class. */
class SystemWindowsFormsHtmlElement extends SystemWindowsFormsClass {
  SystemWindowsFormsHtmlElement() { this.hasName("HtmlElement") }

  /** Gets the `SetAttribute` method. */
  Method getSetAttributeMethod() { result = this.getAMethod("SetAttribute") }
}

/** The `System.Windows.Forms.TextBoxBase` class. */
class SystemWindowsFormsTextBoxBase extends SystemWindowsFormsClass {
  SystemWindowsFormsTextBoxBase() { this.hasName("TextBoxBase") }

  /** Gets the `Text` property. */
  Property getTextProperty() { result = this.getProperty("Text") }
}

/** The `System.Windows.Forms.RichTextBox` class. */
class SystemWindowsFormsRichTextBox extends SystemWindowsFormsClass {
  SystemWindowsFormsRichTextBox() { this.hasName("RichTextBox") }

  /** Gets the `Rtf` property. */
  Property getRtfProperty() { result = this.getProperty("Rtf") }

  /** Gets the `SelectedText` property. */
  Property getSelectedTextProperty() { result = this.getProperty("SelectedText") }

  /** Gets the 'SelectedRtf' property. */
  Property getSelectedRtfProperty() { result = this.getProperty("SelectedRtf") }
}

/** The `System.Windows.Forms.HtmlDocument` class. */
class SystemWindowsFormsHtmlDocumentClass extends SystemWindowsFormsClass {
  SystemWindowsFormsHtmlDocumentClass() { this.hasName("HtmlDocument") }

  /** Gets the `Write` method. */
  Method getWriteMethod() { result = this.getAMethod("Write") }
}

/** The `System.Windows.Forms.WebBrowser` class. */
class SystemWindowsFormsWebBrowserClass extends SystemWindowsFormsClass {
  SystemWindowsFormsWebBrowserClass() { this.hasName("WebBrowser") }

  /** Gets the `DocumentText` property. */
  Property getDocumentTextProperty() { result = this.getProperty("DocumentText") }
}

private class TextProperty extends Property {
  TextProperty() {
    exists(SystemWindowsFormsRichTextBox c |
      this = c.getRtfProperty() or
      this = c.getSelectedTextProperty() or
      this = c.getSelectedRtfProperty()
    )
    or
    exists(SystemWindowsFormsTextBoxBase tb | this = tb.getTextProperty().getAnOverrider*())
  }
}

/** A variable that contains a text control. */
class TextControl extends Variable {
  TextControl() {
    this.getType().(ValueOrRefType).getBaseClass*() instanceof SystemWindowsFormsTextBoxBase
  }

  /** Gets a read of the text property. */
  PropertyRead getARead() {
    result.getTarget() instanceof TextProperty and
    result.getQualifier() = this.getAnAccess()
  }
}
