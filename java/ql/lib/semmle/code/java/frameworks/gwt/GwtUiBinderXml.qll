/**
 * Provides classes and predicates for identifying GWT UiBinder framework XML templates.
 */
overlay[local?]
module;

import java

/** A GWT UiBinder XML template file with a `.ui.xml` suffix. */
class GwtUiTemplateXmlFile extends XmlFile {
  GwtUiTemplateXmlFile() { this.getBaseName().matches("%.ui.xml") }

  /** Gets the top-level UiBinder element. */
  GwtUiBinderTemplateElement getUiBinderElement() { result = this.getAChild() }
}

/** The top-level `<ui:UiBinder>` element of a GWT UiBinder template XML file. */
class GwtUiBinderTemplateElement extends XmlElement {
  GwtUiBinderTemplateElement() {
    this.getParent() instanceof GwtUiTemplateXmlFile and
    this.getName() = "UiBinder" and
    this.getNamespace().getUri() = "urn:ui:com.google.gwt.uibinder"
  }
}

/**
 * A component reference within a GWT UiBinder template.
 */
class GwtComponentTemplateElement extends XmlElement {
  GwtComponentTemplateElement() {
    exists(GwtUiBinderTemplateElement templateElement | this = templateElement.getAChild*() |
      this.getNamespace().getUri().substring(0, 10) = "urn:import"
    )
  }

  /**
   * Gets the class represented by this element.
   */
  Class getClass() {
    exists(string namespace |
      namespace = this.getNamespace().getUri() and
      result.getQualifiedName() = namespace.substring(11, namespace.length()) + "." + this.getName()
    )
  }
}
