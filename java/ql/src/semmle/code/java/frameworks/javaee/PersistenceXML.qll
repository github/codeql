import java

/**
 * A JavaEE persistence configuration XML file (persistence.xml).
 */
class PersistenceXMLFile extends XMLFile {
  PersistenceXMLFile() { this.getStem() = "persistence" }

  PersistenceXmlRoot getRoot() { result = this.getAChild() }

  // convenience methods
  SharedCacheModeElement getASharedCacheModeElement() {
    result = this.getRoot().getAPersistenceUnitElement().getASharedCacheModeElement()
  }

  PersistencePropertyElement getAPropertyElement() {
    result = this
          .getRoot()
          .getAPersistenceUnitElement()
          .getAPropertiesElement()
          .getAPropertyElement()
  }
}

class PersistenceXmlRoot extends XMLElement {
  PersistenceXmlRoot() {
    this.getParent() instanceof PersistenceXMLFile and
    this.getName() = "persistence"
  }

  PersistenceUnitElement getAPersistenceUnitElement() { result = this.getAChild() }
}

class PersistenceUnitElement extends XMLElement {
  PersistenceUnitElement() {
    this.getParent() instanceof PersistenceXmlRoot and
    this.getName() = "persistence-unit"
  }

  SharedCacheModeElement getASharedCacheModeElement() { result = this.getAChild() }

  PersistencePropertiesElement getAPropertiesElement() { result = this.getAChild() }
}

class SharedCacheModeElement extends XMLElement {
  SharedCacheModeElement() {
    this.getParent() instanceof PersistenceUnitElement and
    this.getName() = "shared-cache-mode"
  }

  string getValue() { result = this.getACharactersSet().getCharacters() }

  predicate isDisabled() { this.getValue() = "NONE" }
}

class PersistencePropertiesElement extends XMLElement {
  PersistencePropertiesElement() {
    this.getParent() instanceof PersistenceUnitElement and
    this.getName() = "properties"
  }

  PersistencePropertyElement getAPropertyElement() { result = this.getAChild() }
}

class PersistencePropertyElement extends XMLElement {
  PersistencePropertyElement() {
    this.getParent() instanceof PersistencePropertiesElement and
    this.getName() = "property"
  }

  /** see http://wiki.eclipse.org/EclipseLink/Examples/JPA/Caching */
  predicate disablesEclipseLinkSharedCache() {
    getAttribute("name").getValue() = "eclipselink.cache.shared.default" and
    getAttribute("value").getValue() = "false"
  }
}
