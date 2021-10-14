/**
 * Provides classes and predicates for identifying GWT UiBinder framework XML templates.
 */

import java

/** A GWT UiBinder XML template file with a `.ui.xml` suffix. */
class GwtUiTemplateXmlFile extends XMLFile {
  GwtUiTemplateXmlFile() { this.getBaseName().matches("%.ui.xml") }

  /** Gets the top-level UiBinder element. */
  GwtUiBinderTemplateElement getUiBinderElement() { result = this.getAChild() }
}

/** The top-level `<ui:UiBinder>` element of a GWT UiBinder template XML file. */
class GwtUiBinderTemplateElement extends XMLElement {
  GwtUiBinderTemplateElement() {
    this.getParent() instanceof GwtUiTemplateXmlFile and
    this.getName() = "UiBinder" and
    this.getNamespace().getURI() = "urn:ui:com.google.gwt.uibinder"
  }
}

/**
 * A component reference within a GWT UiBinder template.
 */
class GwtComponentTemplateElement extends XMLElement {
  GwtComponentTemplateElement() {
    exists(GwtUiBinderTemplateElement templateElement | this = templateElement.getAChild*() |
      this.getNamespace().getURI().substring(0, 10) = "urn:import"
    )
  }

  /**
   * Gets the class represented by this element.
   */
  Class getClass() {
    exists(string namespace |
      namespace = getNamespace().getURI() and
      result.getQualifiedName() = namespace.substring(11, namespace.length()) + "." + getName()
    )
  }
}
