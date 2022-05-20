/**
 * Provides classes for JSF "Application Configuration Resources File", usually called `faces-config.xml`.
 */

import default

/**
 * A JSF "application configuration resources file", typically called `faces-config.xml`, which
 * contains the configuration for a JSF application
 */
class FacesConfigXmlFile extends XMLFile {
  FacesConfigXmlFile() {
    // Contains a single top-level XML node named "faces-Config".
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "faces-config"
  }
}

/** DEPRECATED: Alias for FacesConfigXmlFile */
deprecated class FacesConfigXMLFile = FacesConfigXmlFile;

/**
 * An XML element in a `FacesConfigXMLFile`.
 */
class FacesConfigXmlElement extends XMLElement {
  FacesConfigXmlElement() { this.getFile() instanceof FacesConfigXmlFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = this.allCharactersString().trim() }
}

/** DEPRECATED: Alias for FacesConfigXmlElement */
deprecated class FacesConfigXMLElement = FacesConfigXmlElement;

/**
 * An element in a JSF config file that declares a managed bean.
 */
class FacesConfigManagedBean extends FacesConfigXmlElement {
  FacesConfigManagedBean() { this.getName() = "managed-bean" }
}

/**
 * An element in a JSF config file that declares the Class of a managed bean.
 */
class FacesConfigManagedBeanClass extends FacesConfigXmlElement {
  FacesConfigManagedBeanClass() {
    this.getName() = "managed-bean-class" and
    this.getParent() instanceof FacesConfigManagedBean
  }

  /**
   * Gets the `Class` of the managed bean.
   */
  Class getManagedBeanClass() { result.getQualifiedName() = this.getValue() }
}

/**
 * An element in a JSF config file that declares a custom component.
 */
class FacesConfigComponent extends FacesConfigXmlElement {
  FacesConfigComponent() { this.getName() = "component" }
}

/**
 * An element in a JSF config file that declares the Class of a faces component.
 */
class FacesConfigComponentClass extends FacesConfigXmlElement {
  FacesConfigComponentClass() {
    this.getName() = "component-class" and
    this.getParent() instanceof FacesConfigComponent
  }

  /**
   * Gets the `Class` of the faces component.
   */
  Class getFacesComponentClass() { result.getQualifiedName() = this.getValue() }
}
