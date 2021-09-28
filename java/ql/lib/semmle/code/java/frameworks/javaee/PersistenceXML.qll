/**
 * Provides classes and predicates for working with JavaEE
 * persistence configuration XML files (`persistence.xml`).
 */

import java

/**
 * A JavaEE persistence configuration XML file (persistence.xml).
 */
class PersistenceXMLFile extends XMLFile {
  PersistenceXMLFile() { this.getStem() = "persistence" }

  /** Gets the root XML element in this `persistence.xml` file. */
  PersistenceXmlRoot getRoot() { result = this.getAChild() }

  /** Gets a `shared-cache-mode` XML element nested within this `persistence.xml` file. */
  SharedCacheModeElement getASharedCacheModeElement() {
    result = this.getRoot().getAPersistenceUnitElement().getASharedCacheModeElement()
  }

  /** Gets a `property` XML element nested within this `persistence.xml` file. */
  PersistencePropertyElement getAPropertyElement() {
    result =
      this.getRoot().getAPersistenceUnitElement().getAPropertiesElement().getAPropertyElement()
  }
}

/** The root `persistence` XML element in a `persistence.xml` file. */
class PersistenceXmlRoot extends XMLElement {
  PersistenceXmlRoot() {
    this.getParent() instanceof PersistenceXMLFile and
    this.getName() = "persistence"
  }

  /** Gets a `persistence-unit` child XML element of this `persistence` XML element. */
  PersistenceUnitElement getAPersistenceUnitElement() { result = this.getAChild() }
}

/**
 * A `persistence-unit` child XML element of the root
 * `persistence` XML element in a `persistence.xml` file.
 */
class PersistenceUnitElement extends XMLElement {
  PersistenceUnitElement() {
    this.getParent() instanceof PersistenceXmlRoot and
    this.getName() = "persistence-unit"
  }

  /** Gets a `shared-cache-mode` child XML element of this `persistence-unit` XML element. */
  SharedCacheModeElement getASharedCacheModeElement() { result = this.getAChild() }

  /** Gets a `properties` child XML element of this `persistence-unit` XML element. */
  PersistencePropertiesElement getAPropertiesElement() { result = this.getAChild() }
}

/**
 * A `shared-cache-mode` child XML element of a `persistence-unit`
 * XML element in a `persistence.xml` file.
 */
class SharedCacheModeElement extends XMLElement {
  SharedCacheModeElement() {
    this.getParent() instanceof PersistenceUnitElement and
    this.getName() = "shared-cache-mode"
  }

  /** Gets the value of this `shared-cache-mode` XML element. */
  string getValue() { result = this.getACharactersSet().getCharacters() }

  /** Holds if this `shared-cache-mode` XML element has the value "NONE". */
  predicate isDisabled() { this.getValue() = "NONE" }
}

/**
 * A `properties` child XML element of a `persistence-unit`
 * XML element in a `persistence.xml` file.
 */
class PersistencePropertiesElement extends XMLElement {
  PersistencePropertiesElement() {
    this.getParent() instanceof PersistenceUnitElement and
    this.getName() = "properties"
  }

  /** Gets a `property` child XML element of this `properties` XML element. */
  PersistencePropertyElement getAPropertyElement() { result = this.getAChild() }
}

/**
 * A `property` child XML element of a `properties`
 * XML element in a `persistence.xml` file.
 */
class PersistencePropertyElement extends XMLElement {
  PersistencePropertyElement() {
    this.getParent() instanceof PersistencePropertiesElement and
    this.getName() = "property"
  }

  /**
   * Holds if this `property` XML element of a `persistence.xml` file
   * disables the EclipseLink shared cache.
   */
  predicate disablesEclipseLinkSharedCache() {
    getAttribute("name").getValue() = "eclipselink.cache.shared.default" and
    getAttribute("value").getValue() = "false"
  }
}
