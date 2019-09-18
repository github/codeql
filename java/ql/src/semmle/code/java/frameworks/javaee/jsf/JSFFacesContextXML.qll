/**
 * Provides classes for JSF "Application Configuration Resources File", usually called `faces-config.xml`.
 */

import default

/**
 * A JSF "application configuration resources file", typically called `faces-config.xml`, which
 * contains the configuration for a JSF application
 */
class FacesConfigXMLFile extends XMLFile {
  FacesConfigXMLFile() {
    // Contains a single top-level XML node named "faces-Config".
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "faces-config"
  }
}

/**
 * An XML element in a `FacesConfigXMLFile`.
 */
class FacesConfigXMLElement extends XMLElement {
  FacesConfigXMLElement() { this.getFile() instanceof FacesConfigXMLFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = allCharactersString().trim() }
}

/**
 * An element in a JSF config file that declares a managed bean.
 */
class FacesConfigManagedBean extends FacesConfigXMLElement {
  FacesConfigManagedBean() { getName() = "managed-bean" }
}

/**
 * An element in a JSF config file that declares the Class of a managed bean.
 */
class FacesConfigManagedBeanClass extends FacesConfigXMLElement {
  FacesConfigManagedBeanClass() {
    getName() = "managed-bean-class" and
    getParent() instanceof FacesConfigManagedBean
  }

  /**
   * Gets the `Class` of the managed bean.
   */
  Class getManagedBeanClass() { result.getQualifiedName() = getValue() }
}

/**
 * An element in a JSF config file that declares a custom component.
 */
class FacesConfigComponent extends FacesConfigXMLElement {
  FacesConfigComponent() { getName() = "component" }
}

/**
 * An element in a JSF config file that declares the Class of a faces component.
 */
class FacesConfigComponentClass extends FacesConfigXMLElement {
  FacesConfigComponentClass() {
    getName() = "component-class" and
    getParent() instanceof FacesConfigComponent
  }

  /**
   * Gets the `Class` of the faces component.
   */
  Class getFacesComponentClass() { result.getQualifiedName() = getValue() }
}
