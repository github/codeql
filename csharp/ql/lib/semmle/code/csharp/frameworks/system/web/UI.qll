/** Provides definitions related to the namespace `System.Web.UI`. */

import csharp
private import semmle.code.csharp.frameworks.system.Web

/** The `System.Web.UI` namespace. */
class SystemWebUINamespace extends Namespace {
  SystemWebUINamespace() {
    this.getParentNamespace() instanceof SystemWebNamespace and
    this.hasName("UI")
  }
}

/** A class in the `System.Web.UI` namespace. */
class SystemWebUIClass extends Class {
  SystemWebUIClass() { this.getNamespace() instanceof SystemWebUINamespace }
}

/** The `System.Web.UI.Control` class. */
class SystemWebUIControlClass extends SystemWebUIClass {
  SystemWebUIControlClass() { this.hasName("Control") }
}

/** The `System.Web.UI.Page` class. */
class SystemWebUIPageClass extends SystemWebUIClass {
  SystemWebUIPageClass() { this.hasName("Page") }

  /** Get the `ID` property. */
  Property getIDProperty() {
    result = this.getAProperty() and
    result.hasName("ID")
  }

  /** Get the `MetaDescription` property. */
  Property getMetaDescriptionProperty() {
    result = this.getAProperty() and
    result.hasName("MetaDescription")
  }

  /** Get the `MetaKeywords` property. */
  Property getMetaKeywordsProperty() {
    result = this.getAProperty() and
    result.hasName("MetaKeywords")
  }

  /** Get the `Title` property. */
  Property getTitleProperty() {
    result = this.getAProperty() and
    result.hasName("Title")
  }

  /** Get the `RegisterStartupScript` method. */
  Method getRegisterStartupScriptMethod() {
    result.getDeclaringType() = this and
    result.hasName("RegisterStartupScript")
  }

  /** Get the `RegisterClientScriptBlock` method. */
  Method getRegisterClientScriptBlockMethod() {
    result.getDeclaringType() = this and
    result.hasName("RegisterClientScriptBlock")
  }
}

/** The `System.Web.UI.HtmlTextWriter` class. */
class SystemWebUIHtmlTextWriterClass extends SystemWebUIClass {
  SystemWebUIHtmlTextWriterClass() { this.hasName("HtmlTextWriter") }

  /** Get a `Write` method. */
  Method getAWriteMethod() {
    result.getDeclaringType() = this and
    result.hasName("Write")
  }

  /** Get a `WriteLine` method. */
  Method getAWriteLineMethod() {
    result.getDeclaringType() = this and
    result.hasName("WriteLine")
  }

  /** Get a `WriteLineNoTabs` method. */
  Method getAWriteLineNoTabsMethod() {
    result.getDeclaringType() = this and
    result.hasName("WriteLineNoTabs")
  }

  /** Get a `WriteAttribute` method. */
  Method getAWriteAttributeMethod() {
    result.getDeclaringType() = this and
    result.hasName("WriteAttribute")
  }

  /** Get a `WriteBeginTag` method. */
  Method getAWriteBeginTagMethod() {
    result.getDeclaringType() = this and
    result.hasName("WriteBeginTag")
  }
}

/** The `System.Web.UI.AttributeCollection` class. */
class SystemWebUIAttributeCollectionClass extends SystemWebUIClass {
  SystemWebUIAttributeCollectionClass() { this.hasName("AttributeCollection") }

  /** Get the `Add` method. */
  Method getAddMethod() {
    result.getDeclaringType() = this and
    result.hasName("Add")
  }

  /** Get the `Item` property. */
  Property getItemProperty() {
    result.getDeclaringType() = this and
    result.hasName("Item")
  }
}

/** The `System.Web.UI.ClientScriptManager` class. */
class SystemWebUIClientScriptManagerClass extends SystemWebUIClass {
  SystemWebUIClientScriptManagerClass() { this.hasName("ClientScriptManager") }

  /** Get the `RegisterStartupScript` method. */
  Method getRegisterStartupScriptMethod() {
    result.getDeclaringType() = this and
    result.hasName("RegisterStartupScript")
  }

  /** Get the `RegisterClientScriptBlock` method. */
  Method getRegisterClientScriptBlockMethod() {
    result.getDeclaringType() = this and
    result.hasName("RegisterClientScriptBlock")
  }
}
