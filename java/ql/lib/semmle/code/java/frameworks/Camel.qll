/**
 * Apache Camel messaging framework.
 */

import java
import semmle.code.java.frameworks.spring.SpringCamel
import semmle.code.java.frameworks.camel.CamelJavaDSL
import semmle.code.java.frameworks.camel.CamelJavaAnnotations

/**
 * A string describing a URI specified in an Apache Camel "to" declaration.
 */
class CamelToUri extends string {
  CamelToUri() {
    exists(SpringCamelXmlToElement toXmlElement | this = toXmlElement.getUri()) or
    exists(CamelJavaDslToDecl toJavaDsl | this = toJavaDsl.getUri())
  }
}

/**
 * A string describing a URI specified in an Apache Camel "to" declaration that maps to a
 * SpringBean.
 */
class CamelToBeanUri extends CamelToUri {
  CamelToBeanUri() {
    // A `<to>` element references a bean if the URI starts with "bean:", or there is no scheme.
    this.matches("bean:%") or
    not exists(this.indexOf(":"))
  }

  /**
   * Gets the identifier of the Spring Bean that is the target of this URI.
   *
   * The URI is of the form: `bean:BeanName?method", where the "bean:" scheme and "?methodname"
   * parameter parts are optional.
   */
  string getBeanIdentifier() {
    if not exists(this.indexOf(":"))
    then result = this
    else
      exists(int start | start = this.indexOf(":", 0, 0) + 1 |
        if not exists(this.indexOf("?"))
        then result = this.suffix(start)
        else result = this.substring(start, this.indexOf("?", 0, 0))
      )
  }

  /**
   * Gets the bean referenced by this URI.
   */
  SpringBean getRefBean() { result.getBeanIdentifier() = this.getBeanIdentifier() }
}

/**
 * A Class whose methods may be called in response to an Apache Camel message.
 */
class CamelTargetClass extends Class {
  CamelTargetClass() {
    exists(SpringCamelXmlBeanRef camelXmlBeanRef |
      // A target may be defined by referencing an existing Spring Bean.
      this = camelXmlBeanRef.getRefBean().getClass()
      or
      // A target may be defined by referencing a class, which Apache Camel will create into a bean.
      this = camelXmlBeanRef.getBeanType()
    )
    or
    exists(CamelToBeanUri toBeanUri | this = toBeanUri.getRefBean().getClass())
    or
    exists(SpringCamelXmlMethodElement xmlMethod |
      this = xmlMethod.getRefBean().getClass() or
      this = xmlMethod.getBeanType()
    )
    or
    exists(CamelJavaDslMethodDecl methodDecl | this = methodDecl.getABean())
    or
    // Any beans referred to in Java DSL bean or beanRef elements are considered as possible
    // targets. Whether the route builder is ever constructed or called is not considered.
    exists(CamelJavaDslBeanDecl beanDecl | this = beanDecl.getABeanClass())
    or
    exists(CamelJavaDslBeanRefDecl beanRefDecl | this = beanRefDecl.getABeanClass())
  }

  /**
   * Gets a method that may be called by Apache Camel.
   *
   * Any public method inherited by this class is assumed to be callable by Apache Camel.
   */
  Method getACamelCalledMethod() {
    this.inherits(result) and
    result.isPublic()
  }
}
