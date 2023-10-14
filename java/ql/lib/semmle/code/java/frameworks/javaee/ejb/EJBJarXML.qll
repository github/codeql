/**
 * Provides classes and predicates for working with
 * EJB deployment descriptor XML files (`ejb-jar.xml`).
 */

import java

/**
 * An EJB deployment descriptor XML file named `ejb-jar.xml`.
 */
class EjbJarXmlFile extends XmlFile {
  EjbJarXmlFile() { this.getStem() = "ejb-jar" }

  /** Gets the root `ejb-jar` XML element of this `ejb-jar.xml` file. */
  EjbJarRootElement getRoot() { result = this.getAChild() }

  /** Gets an `enterprise-beans` XML element nested within this `ejb-jar.xml` file. */
  EjbJarEnterpriseBeansElement getAnEnterpriseBeansElement() {
    result = this.getRoot().getAnEnterpriseBeansElement()
  }

  /** Gets a `session` XML element nested within this `ejb-jar.xml` file. */
  EjbJarSessionElement getASessionElement() {
    result = this.getAnEnterpriseBeansElement().getASessionElement()
  }

  /** Gets a `message-driven` XML element nested within this `ejb-jar.xml` file. */
  EjbJarMessageDrivenElement getAMessageDrivenElement() {
    result = this.getAnEnterpriseBeansElement().getAMessageDrivenElement()
  }

  /** Gets an `entity` XML element nested within this `ejb-jar.xml` file. */
  EjbJarEntityElement getAnEntityElement() {
    result = this.getAnEnterpriseBeansElement().getAnEntityElement()
  }
}

/** The root `ejb-jar` XML element in an `ejb-jar.xml` file. */
class EjbJarRootElement extends XmlElement {
  EjbJarRootElement() {
    this.getParent() instanceof EjbJarXmlFile and
    this.getName() = "ejb-jar"
  }

  /** Gets an `enterprise-beans` child XML element of this root `ejb-jar` XML element. */
  EjbJarEnterpriseBeansElement getAnEnterpriseBeansElement() { result = this.getAChild() }
}

/**
 * An `enterprise-beans` child XML element of the root
 * `ejb-jar` XML element in an `ejb-jar.xml` file.
 */
class EjbJarEnterpriseBeansElement extends XmlElement {
  EjbJarEnterpriseBeansElement() {
    this.getParent() instanceof EjbJarRootElement and
    this.getName() = "enterprise-beans"
  }

  /** Gets a `session` child XML element of this `enterprise-beans` XML element. */
  EjbJarSessionElement getASessionElement() {
    result = this.getAChild() and
    result.getName() = "session"
  }

  /** Gets a `message-driven` child XML element of this `enterprise-beans` XML element. */
  EjbJarMessageDrivenElement getAMessageDrivenElement() {
    result = this.getAChild() and
    result.getName() = "message-driven"
  }

  /** Gets an `entity` child XML element of this `enterprise-beans` XML element. */
  EjbJarEntityElement getAnEntityElement() {
    result = this.getAChild() and
    result.getName() = "entity"
  }
}

/**
 * A child XML element of an `enterprise-beans` XML element within an `ejb-jar.xml` file.
 *
 * This is either a `message-driven` element, a `session` element, or an `entity` element.
 */
abstract class EjbJarBeanTypeElement extends XmlElement {
  EjbJarBeanTypeElement() { this.getParent() instanceof EjbJarEnterpriseBeansElement }

  /** Gets an `ejb-class` child XML element of this bean type element. */
  XmlElement getAnEjbClassElement() {
    result = this.getAChild() and
    result.getName() = "ejb-class"
  }
}

/**
 * A `session` child XML element of a bean type element in an `ejb-jar.xml` file.
 */
class EjbJarSessionElement extends EjbJarBeanTypeElement {
  EjbJarSessionElement() { this.getName() = "session" }

  /** Gets a `business-local` child XML element of this `session` XML element. */
  XmlElement getABusinessLocalElement() {
    result = this.getAChild() and
    result.getName() = "business-local"
  }

  /** Gets a `business-remote` child XML element of this `session` XML element. */
  XmlElement getABusinessRemoteElement() {
    result = this.getAChild() and
    result.getName() = "business-remote"
  }

  /**
   * Gets a business child XML element of this `session` XML element.
   *
   * This is either a `business-local` or `business-remote` element.
   */
  XmlElement getABusinessElement() {
    result = this.getABusinessLocalElement() or
    result = this.getABusinessRemoteElement()
  }

  /** Gets a `remote` child XML element of this `session` XML element. */
  XmlElement getARemoteElement() {
    result = this.getAChild() and
    result.getName() = "remote"
  }

  /** Gets a `home` child XML element of this `session` XML element. */
  XmlElement getARemoteHomeElement() {
    result = this.getAChild() and
    result.getName() = "home"
  }

  /** Gets a `local` child XML element of this `session` XML element. */
  XmlElement getALocalElement() {
    result = this.getAChild() and
    result.getName() = "local"
  }

  /** Gets a `local-home` child XML element of this `session` XML element. */
  XmlElement getALocalHomeElement() {
    result = this.getAChild() and
    result.getName() = "local-home"
  }

  /** Gets a `session-type` child XML element of this `session` XML element. */
  EjbJarSessionTypeElement getASessionTypeElement() { result = this.getAChild() }

  /** Gets an `init-method` child XML element of this `session` XML element. */
  EjbJarInitMethodElement getAnInitMethodElement() { result = this.getAChild() }

  /**
   * Gets a `method-name` child XML element of a `create-method`
   * XML element nested within this `session` XML element.
   */
  XmlElement getACreateMethodNameElement() {
    result = this.getAnInitMethodElement().getACreateMethodElement().getAMethodNameElement()
  }

  /**
   * Gets a `method-name` child XML element of a `bean-method`
   * XML element nested within this `session` XML element.
   */
  XmlElement getABeanMethodNameElement() {
    result = this.getAnInitMethodElement().getABeanMethodElement().getAMethodNameElement()
  }
}

/**
 * A `message-driven` child XML element of a bean type element in an `ejb-jar.xml` file.
 */
class EjbJarMessageDrivenElement extends EjbJarBeanTypeElement {
  EjbJarMessageDrivenElement() { this.getName() = "message-driven" }
}

/**
 * An `entity` child XML element of a bean type element in an `ejb-jar.xml` file.
 */
class EjbJarEntityElement extends EjbJarBeanTypeElement {
  EjbJarEntityElement() { this.getName() = "entity" }
}

/** A `session-type` child XML element of a `session` element in an `ejb-jar.xml` file. */
class EjbJarSessionTypeElement extends XmlElement {
  EjbJarSessionTypeElement() {
    this.getParent() instanceof EjbJarSessionElement and
    this.getName() = "session-type"
  }

  /** Holds if the value of this `session-type` XML element is "Stateful". */
  predicate isStateful() { this.getACharactersSet().getCharacters() = "Stateful" }

  /** Holds if the value of this `session-type` XML element is "Stateless". */
  predicate isStateless() { this.getACharactersSet().getCharacters() = "Stateless" }
}

/** An `init-method` child XML element of a `session` element in an `ejb-jar.xml` file. */
class EjbJarInitMethodElement extends XmlElement {
  EjbJarInitMethodElement() {
    this.getParent() instanceof EjbJarSessionElement and
    this.getName() = "init-method"
  }

  /** Gets a `create-method` child XML element of this `init-method` XML element. */
  EjbJarCreateMethodElement getACreateMethodElement() {
    result = this.getAChild() and
    result.getName() = "create-method"
  }

  /** Gets a `bean-method` child XML element of this `init-method` XML element. */
  EjbJarBeanMethodElement getABeanMethodElement() {
    result = this.getAChild() and
    result.getName() = "bean-method"
  }
}

/**
 * A child XML element of an `init-method` element in an `ejb-jar.xml` file.
 *
 * This is either a `create-method` element, or a `bean-method` element.
 */
abstract class EjbJarInitMethodChildElement extends XmlElement {
  /** Gets a `method-name` child XML element of this `create-method` or `bean-method` XML element. */
  XmlElement getAMethodNameElement() {
    result = this.getAChild() and
    result.getName() = "method-name"
  }
}

/** A `create-method` child XML element of an `init-method` element in an `ejb-jar.xml` file. */
class EjbJarCreateMethodElement extends EjbJarInitMethodChildElement {
  EjbJarCreateMethodElement() {
    this.getParent() instanceof EjbJarInitMethodElement and
    this.getName() = "create-method"
  }
}

/** A `bean-method` child XML element of an `init-method` element in an `ejb-jar.xml` file. */
class EjbJarBeanMethodElement extends EjbJarInitMethodChildElement {
  EjbJarBeanMethodElement() {
    this.getParent() instanceof EjbJarInitMethodElement and
    this.getName() = "bean-method"
  }
}
