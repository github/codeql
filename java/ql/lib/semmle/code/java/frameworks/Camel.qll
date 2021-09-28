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
class CamelToURI extends string {
  CamelToURI() {
    exists(SpringCamelXMLToElement toXMLElement | this = toXMLElement.getURI()) or
    exists(CamelJavaDSLToDecl toJavaDSL | this = toJavaDSL.getURI())
  }
}

/**
 * A string describing a URI specified in an Apache Camel "to" declaration that maps to a
 * SpringBean.
 */
class CamelToBeanURI extends CamelToURI {
  CamelToBeanURI() {
    // A `<to>` element references a bean if the URI starts with "bean:", or there is no scheme.
    matches("bean:%") or
    not exists(indexOf(":"))
  }

  /**
   * Gets the identifier of the Spring Bean that is the target of this URI.
   *
   * The URI is of the form: `bean:BeanName?method", where the "bean:" scheme and "?methodname"
   * parameter parts are optional.
   */
  string getBeanIdentifier() {
    if not exists(indexOf(":"))
    then result = this
    else
      exists(int start | start = indexOf(":", 0, 0) + 1 |
        if not exists(indexOf("?"))
        then result = suffix(start)
        else result = substring(start, indexOf("?", 0, 0))
      )
  }

  /**
   * Gets the bean referenced by this URI.
   */
  SpringBean getRefBean() { result.getBeanIdentifier() = getBeanIdentifier() }
}

/**
 * A Class whose methods may be called in response to an Apache Camel message.
 */
class CamelTargetClass extends Class {
  CamelTargetClass() {
    exists(SpringCamelXMLBeanRef camelXMLBeanRef |
      // A target may be defined by referencing an existing Spring Bean.
      this = camelXMLBeanRef.getRefBean().getClass()
      or
      // A target may be defined by referencing a class, which Apache Camel will create into a bean.
      this = camelXMLBeanRef.getBeanType()
    )
    or
    exists(CamelToBeanURI toBeanURI | this = toBeanURI.getRefBean().getClass())
    or
    exists(SpringCamelXMLMethodElement xmlMethod |
      this = xmlMethod.getRefBean().getClass() or
      this = xmlMethod.getBeanType()
    )
    or
    exists(CamelJavaDSLMethodDecl methodDecl | this = methodDecl.getABean())
    or
    // Any beans referred to in Java DSL bean or beanRef elements are considered as possible
    // targets. Whether the route builder is ever constructed or called is not considered.
    exists(CamelJavaDSLBeanDecl beanDecl | this = beanDecl.getABeanClass())
    or
    exists(CamelJavaDSLBeanRefDecl beanRefDecl | this = beanRefDecl.getABeanClass())
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
