import java

/**
 * An EJB deployment descriptor XML file named `ejb-jar.xml`.
 */
class EjbJarXMLFile extends XMLFile {
  EjbJarXMLFile() { this.getStem() = "ejb-jar" }

  EjbJarRootElement getRoot() { result = this.getAChild() }

  // Convenience methods.
  EjbJarEnterpriseBeansElement getAnEnterpriseBeansElement() {
    result = this.getRoot().getAnEnterpriseBeansElement()
  }

  EjbJarSessionElement getASessionElement() {
    result = this.getAnEnterpriseBeansElement().getASessionElement()
  }

  EjbJarMessageDrivenElement getAMessageDrivenElement() {
    result = this.getAnEnterpriseBeansElement().getAMessageDrivenElement()
  }

  EjbJarEntityElement getAnEntityElement() {
    result = this.getAnEnterpriseBeansElement().getAnEntityElement()
  }
}

class EjbJarRootElement extends XMLElement {
  EjbJarRootElement() {
    this.getParent() instanceof EjbJarXMLFile and
    this.getName() = "ejb-jar"
  }

  EjbJarEnterpriseBeansElement getAnEnterpriseBeansElement() { result = this.getAChild() }
}

class EjbJarEnterpriseBeansElement extends XMLElement {
  EjbJarEnterpriseBeansElement() {
    this.getParent() instanceof EjbJarRootElement and
    this.getName() = "enterprise-beans"
  }

  EjbJarSessionElement getASessionElement() {
    result = this.getAChild() and
    result.getName() = "session"
  }

  EjbJarMessageDrivenElement getAMessageDrivenElement() {
    result = this.getAChild() and
    result.getName() = "message-driven"
  }

  EjbJarEntityElement getAnEntityElement() {
    result = this.getAChild() and
    result.getName() = "entity"
  }
}

abstract class EjbJarBeanTypeElement extends XMLElement {
  EjbJarBeanTypeElement() { this.getParent() instanceof EjbJarEnterpriseBeansElement }

  XMLElement getAnEjbClassElement() {
    result = this.getAChild() and
    result.getName() = "ejb-class"
  }
}

class EjbJarSessionElement extends EjbJarBeanTypeElement {
  EjbJarSessionElement() { this.getName() = "session" }

  XMLElement getABusinessLocalElement() {
    result = this.getAChild() and
    result.getName() = "business-local"
  }

  XMLElement getABusinessRemoteElement() {
    result = this.getAChild() and
    result.getName() = "business-remote"
  }

  XMLElement getABusinessElement() {
    result = getABusinessLocalElement() or
    result = getABusinessRemoteElement()
  }

  XMLElement getARemoteElement() {
    result = this.getAChild() and
    result.getName() = "remote"
  }

  XMLElement getARemoteHomeElement() {
    result = this.getAChild() and
    result.getName() = "home"
  }

  XMLElement getALocalElement() {
    result = this.getAChild() and
    result.getName() = "local"
  }

  XMLElement getALocalHomeElement() {
    result = this.getAChild() and
    result.getName() = "local-home"
  }

  EjbJarSessionTypeElement getASessionTypeElement() { result = this.getAChild() }

  EjbJarInitMethodElement getAnInitMethodElement() { result = this.getAChild() }

  // Convenience methods.
  XMLElement getACreateMethodNameElement() {
    result = getAnInitMethodElement().getACreateMethodElement().getAMethodNameElement()
  }

  XMLElement getABeanMethodNameElement() {
    result = getAnInitMethodElement().getABeanMethodElement().getAMethodNameElement()
  }
}

class EjbJarMessageDrivenElement extends EjbJarBeanTypeElement {
  EjbJarMessageDrivenElement() { this.getName() = "message-driven" }
}

class EjbJarEntityElement extends EjbJarBeanTypeElement {
  EjbJarEntityElement() { this.getName() = "entity" }
}

class EjbJarSessionTypeElement extends XMLElement {
  EjbJarSessionTypeElement() {
    this.getParent() instanceof EjbJarSessionElement and
    this.getName() = "session-type"
  }

  predicate isStateful() { this.getACharactersSet().getCharacters() = "Stateful" }

  predicate isStateless() { this.getACharactersSet().getCharacters() = "Stateless" }
}

class EjbJarInitMethodElement extends XMLElement {
  EjbJarInitMethodElement() {
    this.getParent() instanceof EjbJarSessionElement and
    this.getName() = "init-method"
  }

  EjbJarCreateMethodElement getACreateMethodElement() {
    result = this.getAChild() and
    result.getName() = "create-method"
  }

  EjbJarBeanMethodElement getABeanMethodElement() {
    result = this.getAChild() and
    result.getName() = "bean-method"
  }
}

abstract class EjbJarInitMethodChildElement extends XMLElement {
  XMLElement getAMethodNameElement() {
    result = this.getAChild() and
    result.getName() = "method-name"
  }
}

class EjbJarCreateMethodElement extends EjbJarInitMethodChildElement {
  EjbJarCreateMethodElement() {
    this.getParent() instanceof EjbJarInitMethodElement and
    this.getName() = "create-method"
  }
}

class EjbJarBeanMethodElement extends EjbJarInitMethodChildElement {
  EjbJarBeanMethodElement() {
    this.getParent() instanceof EjbJarInitMethodElement and
    this.getName() = "bean-method"
  }
}
