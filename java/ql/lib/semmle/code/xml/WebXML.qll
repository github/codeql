import java

/**
 * Holds if any `web.xml` files are included in this snapshot.
 */
predicate isWebXmlIncluded() { exists(WebXmlFile webXml) }

/**
 * A deployment descriptor file, typically called `web.xml`.
 */
class WebXmlFile extends XmlFile {
  WebXmlFile() {
    count(XmlElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "web-app"
  }

  /**
   * Gets the value of the context parameter with the given name.
   */
  string getContextParamValue(string name) {
    exists(WebContextParameter parameter |
      // Find a web context parameter in the same file and ...
      parameter.getFile() = this and
      // ... with the right name.
      name = parameter.getParamName().getValue() and
      result = parameter.getParamValue().getValue()
    )
  }
}

/**
 * An XML element in a `WebXMLFile`.
 */
class WebXmlElement extends XmlElement {
  WebXmlElement() { this.getFile() instanceof WebXmlFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = this.allCharactersString().trim() }
}

/**
 * A `<context-param>` element in a `web.xml` file.
 */
class WebContextParameter extends WebXmlElement {
  WebContextParameter() { this.getName() = "context-param" }

  /**
   * Gets the `<param-name>` element of this `<context-param>`.
   */
  WebContextParamName getParamName() { result = this.getAChild() }

  /**
   * Gets the `<param-value>` element of this `<context-param>`.
   */
  WebContextParamValue getParamValue() { result = this.getAChild() }
}

/**
 * A `<param-name>` element in a `web.xml` file.
 */
class WebContextParamName extends WebXmlElement {
  WebContextParamName() { this.getName() = "param-name" }
}

/**
 * A `<param-value>` element in a `web.xml` file.
 */
class WebContextParamValue extends WebXmlElement {
  WebContextParamValue() { this.getName() = "param-value" }
}

/**
 * A `<filter>` element in a `web.xml` file.
 */
class WebFilter extends WebXmlElement {
  WebFilter() { this.getName() = "filter" }
}

/**
 * A `<filter-class>` element in a `web.xml` file, nested under a `<filter>` element.
 */
class WebFilterClass extends WebXmlElement {
  WebFilterClass() {
    this.getName() = "filter-class" and
    this.getParent() instanceof WebFilter
  }

  Class getClass() { result.getQualifiedName() = this.getValue() }
}

/**
 * A `<servlet>` element in a `web.xml` file.
 */
class WebServlet extends WebXmlElement {
  WebServlet() { this.getName() = "servlet" }
}

/**
 * A `<servlet-class>` element in a `web.xml` file, nested under a `<servlet>` element.
 */
class WebServletClass extends WebXmlElement {
  WebServletClass() {
    this.getName() = "servlet-class" and
    this.getParent() instanceof WebServlet
  }

  Class getClass() { result.getQualifiedName() = this.getValue() }
}

/**
 * A `<listener>` element in a `web.xml` file.
 */
class WebListener extends WebXmlElement {
  WebListener() { this.getName() = "listener" }
}

/**
 * A `<listener-class>` element in a `web.xml` file, nested under a `<listener>` element.
 */
class WebListenerClass extends WebXmlElement {
  WebListenerClass() {
    this.getName() = "listener-class" and
    this.getParent() instanceof WebListener
  }

  /**
   * Gets the `Class` instance associated with this element.
   */
  Class getClass() { result.getQualifiedName() = this.getValue() }
}

/**
 * An `<error-page>` element in a `web.xml` file.
 */
class WebErrorPage extends WebXmlElement {
  WebErrorPage() { this.getName() = "error-page" }

  /**
   * Gets the `<exception-type>` element of this `<error-page>`.
   */
  WebErrorPageType getPageType() { result = this.getAChild() }

  /**
   * Gets the `<location>` element of this `<error-page>`.
   */
  WebErrorPageLocation getPageLocation() { result = this.getAChild() }
}

/**
 * An `<exception-type>` element in a `web.xml` file, nested under an `<error-page>` element.
 */
class WebErrorPageType extends WebXmlElement {
  WebErrorPageType() {
    this.getName() = "exception-type" and
    this.getParent() instanceof WebErrorPage
  }
}

/**
 * A `<location>` element in a `web.xml` file, nested under an `<error-page>` element.
 */
class WebErrorPageLocation extends WebXmlElement {
  WebErrorPageLocation() {
    this.getName() = "location" and
    this.getParent() instanceof WebErrorPage
  }
}
