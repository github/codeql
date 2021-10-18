/** Provides definitions related to the namespace `System.Xml`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.DataFlow3

/** The `System.Xml` namespace. */
class SystemXmlNamespace extends Namespace {
  SystemXmlNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Xml")
  }
}

/** The `System.Xml.Schema` namespace. */
class SystemXmlSchemaNamespace extends Namespace {
  SystemXmlSchemaNamespace() {
    this.getParentNamespace() instanceof SystemXmlNamespace and
    this.hasName("Schema")
  }
}

/** A class in the `System.Xml` namespace. */
class SystemXmlClass extends Class {
  SystemXmlClass() { this.getNamespace() instanceof SystemXmlNamespace }
}

/** The `System.Xml.XmlDocument` class. */
class SystemXmlXmlDocumentClass extends Class {
  SystemXmlXmlDocumentClass() {
    this.getNamespace() instanceof SystemXmlNamespace and
    this.hasName("XmlDocument")
  }

  /** Gets the `Load` method. */
  Method getLoadMethod() {
    result = this.getAMethod() and
    result.hasName("Load") and
    result.isStatic()
  }
}

/** The `System.Xml.XmlReader` class. */
class SystemXmlXmlReaderClass extends Class {
  SystemXmlXmlReaderClass() {
    this.getNamespace() instanceof SystemXmlNamespace and
    this.hasName("XmlReader")
  }

  /** Gets the `Create` method. */
  Method getCreateMethod() {
    result = this.getAMethod() and
    result.hasName("Create") and
    result.isStatic()
  }
}

/** The `System.Xml.XmlReaderSettings` class. */
class SystemXmlXmlReaderSettingsClass extends Class {
  SystemXmlXmlReaderSettingsClass() {
    this.getNamespace() instanceof SystemXmlNamespace and
    this.hasName("XmlReaderSettings")
  }

  /** Gets the `ValidationType` property. */
  Property getValidationTypeProperty() { result = this.getProperty("ValidationType") }

  /** Gets the `ValidationFlags` property. */
  Property getValidationFlagsProperty() { result = this.getProperty("ValidationFlags") }
}

/** The `System.Xml.XmlNode` class. */
class SystemXmlXmlNodeClass extends Class {
  SystemXmlXmlNodeClass() {
    this.getNamespace() instanceof SystemXmlNamespace and
    this.hasName("XmlNode")
  }

  /** Gets the `FirstChild` property. */
  Property getFirstChildProperty() {
    result = this.getAProperty() and
    result.hasName("FirstChild")
  }

  /** Gets the `Attributes` property. */
  Property getAttributesProperty() {
    result = this.getAProperty() and
    result.hasName("Attributes")
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result = this.getAProperty() and
    result.hasName("Value")
  }

  /** Gets a method that selects nodes. */
  Method getASelectNodeMethod() {
    result = this.getAMethod() and
    result.getName().matches("Select%Node%")
  }
}

/** The `System.Xml.XmlNamedNodeMap` class. */
class SystemXmlXmlNamedNodeMapClass extends Class {
  SystemXmlXmlNamedNodeMapClass() {
    this.getNamespace() instanceof SystemXmlNamespace and
    this.hasName("XmlNamedNodeMap")
  }

  /** Get the `GetNamedItem` method. */
  Method getGetNamedItemMethod() {
    result = this.getAMethod() and
    result.hasName("GetNamedItem")
  }
}

/** An enum constant in `System.Xml.ValidationType`. */
class SystemXmlValidationType extends EnumConstant {
  SystemXmlValidationType() {
    this.getDeclaringEnum() =
      any(Enum e | e = any(SystemXmlNamespace n).getAnEnum() and e.hasName("ValidationType"))
  }
}

/** An enum constant in `System.Xml.Schema.XmlSchemaValidationFlags`. */
class SystemXmlSchemaXmlSchemaValidationFlags extends EnumConstant {
  SystemXmlSchemaXmlSchemaValidationFlags() {
    this.getDeclaringEnum() =
      any(Enum e |
        e = any(SystemXmlSchemaNamespace s).getAnEnum() and e.hasName("XmlSchemaValidationFlags")
      )
  }
}

private Expr getBitwiseOrOperand(Expr e) { result = e.(BitwiseOrExpr).getAnOperand() }

/** A creation of an instance of `System.Xml.XmlReaderSettings`. */
class XmlReaderSettingsCreation extends ObjectCreation {
  XmlReaderSettingsCreation() { this.getType() instanceof SystemXmlXmlReaderSettingsClass }

  /** Gets a value set on the `ValidationType` property, if any. */
  SystemXmlValidationType getValidationType() {
    result.getAnAccess() =
      this.getPropertyValue(any(SystemXmlXmlReaderSettingsClass s).getValidationTypeProperty())
  }

  /** Gets a flag set on the `ValidationFlags` property, if any. */
  SystemXmlSchemaXmlSchemaValidationFlags getAValidationFlag() {
    result.getAnAccess() =
      this.getPropertyValue(any(SystemXmlXmlReaderSettingsClass s).getValidationFlagsProperty())
  }

  /** Gets a value set for the given property in this local context. */
  private Expr getPropertyValue(Property p) {
    p = this.getType().(RefType).getAProperty() and
    exists(PropertyCall set, Expr arg |
      set.getTarget() = p.getSetter() and
      DataFlow::localExprFlow(this, set.getQualifier()) and
      arg = set.getAnArgument() and
      result = getBitwiseOrOperand*(arg)
    )
  }
}

private class SettingsDataFlowConfig extends DataFlow3::Configuration {
  SettingsDataFlowConfig() { this = "SettingsDataFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof XmlReaderSettingsCreation
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() instanceof XmlReaderSettingsInstance
  }
}

/** A call to `XmlReader.Create`. */
class XmlReaderCreateCall extends MethodCall {
  XmlReaderCreateCall() { this.getTarget() = any(SystemXmlXmlReaderClass r).getCreateMethod() }

  /** Gets the settings used for this create call, if any. */
  XmlReaderSettingsInstance getSettings() { result = this.getAnArgument() }
}

/** An instance of `XmlReaderSettings` passed to an `XmlReader.Create` call. */
class XmlReaderSettingsInstance extends Expr {
  XmlReaderSettingsInstance() {
    this = any(XmlReaderCreateCall createCall).getArgumentForName("settings")
  }

  /** Gets a possible creation point for this instance of `XmlReaderSettings`. */
  XmlReaderSettingsCreation getASettingsCreation() {
    exists(SettingsDataFlowConfig settingsFlow |
      settingsFlow.hasFlow(DataFlow::exprNode(result), DataFlow::exprNode(this))
    )
  }
}
