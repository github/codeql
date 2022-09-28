/**
 * Provides classes and predicates for identifying methods and constructors called by Spring injection.
 */

import java
import SpringComponentScan

/**
 * Holds if an injection annotation, such as `@Autowired` or `@Inject`, is present on this particular
 * annotatable element.
 */
predicate hasInjectAnnotation(Annotatable a) {
  a.hasAnnotation("org.springframework.beans.factory.annotation", "Autowired") or
  a.getAnAnnotation() instanceof SpringResourceAnnotation or
  a.hasAnnotation("javax.inject", "Inject")
}

/**
 * A constructor on a Spring component.
 *
 * The component is constructed according to the rules of Spring dependency injection if it is
 * picked up by the Spring classpath scanning.
 */
class SpringComponentConstructor extends Constructor {
  SpringComponentConstructor() {
    // Must be a live Spring component.
    this.getDeclaringType().(SpringComponent).isLive() and
    (
      this.getNumberOfParameters() = 0 or
      hasInjectAnnotation(this)
    )
  }
}

/**
 * A Spring bean specified in an XML configuration file, which we believe will be reflectively
 * constructed.
 */
class SpringBeanReflectivelyConstructed extends Constructor {
  SpringBeanReflectivelyConstructed() { this.getDeclaringType() instanceof SpringBeanRefType }
}

/**
 * A setter method called by Spring setter injection due to an explicit property specification in
 * the bean configuration file.
 */
class SpringBeanPropertySetterMethod extends Method {
  SpringBeanPropertySetterMethod() {
    exists(SpringProperty property |
      // Property specified in beans file
      this = property.getSetterMethod()
    )
  }
}

/**
 * A setter method that may be called due to some XML specified autowiring in the bean definition for this bean.
 *
 * Confusingly, this is a different form of autowiring to the `@Autowired` annotation.
 */
class SpringBeanXmlAutowiredSetterMethod extends Method {
  SpringBeanXmlAutowiredSetterMethod() {
    // The bean as marked with some form of autowiring in the XML file.
    exists(string xmlAutowire |
      xmlAutowire = this.getDeclaringType().(SpringBeanRefType).getSpringBean().getAutowire()
    |
      not xmlAutowire = "default" and
      not xmlAutowire = "no"
    )
  }

  /**
   * Gets the injected bean, if any.
   *
   * If there is no injected bean, this setter method is never called.
   */
  SpringBean getInjectedBean() {
    exists(string xmlAutowire |
      xmlAutowire = this.getDeclaringType().(SpringBeanRefType).getSpringBean().getAutowire()
    |
      xmlAutowire = "byName" and
      // There is a bean whose name is the same as this setter method.
      this.getName().toLowerCase() = "set" + result.getBeanIdentifier().toLowerCase()
      or
      (
        xmlAutowire = "byType"
        or
        // When it is set to autodetect, we use "byType" if there is a no-arg constructor. This
        // approach has been removed in Spring 4.x.
        xmlAutowire = "autodetect" and
        exists(Constructor c | c = this.getDeclaringType().getAConstructor() |
          c.getNumberOfParameters() = 0
        )
      ) and
      // The resulting bean is of the right type.
      result.getClass().getAnAncestor() = this.getParameter(0).getType() and
      this.getNumberOfParameters() = 1 and
      this.getName().matches("set%")
    )
  }
}

/** DEPRECATED: Alias for SpringBeanXmlAutowiredSetterMethod */
deprecated class SpringBeanXMLAutowiredSetterMethod = SpringBeanXmlAutowiredSetterMethod;

/**
 * A callable that is annotated with `@Autowired`.
 *
 * This can be a constructor, or a "config method" on the class.
 */
class SpringBeanAutowiredCallable extends Callable {
  SpringBeanAutowiredCallable() {
    // Marked as `@Autowired`.
    hasInjectAnnotation(this) and
    // No autowiring occurs if there are no parameters
    this.getNumberOfParameters() > 0
  }

  /**
   * If the enclosing type is declared as a bean in an XML file, return the `SpringBean` it is
   * defined in.
   */
  SpringBean getEnclosingSpringBean() {
    result = this.getDeclaringType().(SpringBeanRefType).getSpringBean()
  }

  /**
   * If the enclosing type is declared as a component, return the `SpringComponent`.
   */
  SpringComponent getEnclosingSpringComponent() { result = this.getDeclaringType() }

  /**
   * Gets the qualifier annotation for parameter at `pos`, if any.
   */
  SpringQualifierAnnotation getQualifier(int pos) {
    result = this.getParameter(pos).getAnAnnotation()
  }

  /**
   * Gets the qualifier annotation for this method, if any.
   */
  SpringQualifierAnnotation getQualifier() { result = this.getAnAnnotation() }

  /**
   * Gets the resource annotation for this method, if any.
   */
  SpringResourceAnnotation getResource() { result = this.getAnAnnotation() }

  /**
   * Gets a bean that will be injected into this callable.
   */
  SpringBean getAnInjectedBean() { result = this.getInjectedBean(_) }

  /**
   * Gets the `SpringBean`, if any, that will be injected for the parameter at position `pos`,
   * considering any `@Qualifier` annotations, and falling back to autowiring by type.
   */
  SpringBean getInjectedBean(int pos) {
    // Must be a sub-type of the parameter type
    result.getClass().getAnAncestor() = this.getParameterType(pos) and
    // Now look up bean
    if exists(this.getQualifier(pos))
    then
      // Resolved by `@Qualifier("qualifier")` specified on the parameter
      result = this.getQualifier(pos).getSpringBean()
    else
      if exists(this.getQualifier()) and this.getNumberOfParameters() = 1
      then
        // Resolved by `@Qualifier("qualifier")` on the method
        pos = 0 and
        result = this.getQualifier().getSpringBean()
      else
        if exists(this.getResource().getNameValue()) and this.getNumberOfParameters() = 1
        then
          // Resolved by looking at the name part of `@Resource(name="qualifier")`
          pos = 0 and
          result = this.getResource().getSpringBean()
        else
          // Otherwise no restrictions, just by type
          any()
  }

  /**
   * Gets the SpringComponent, if any, that will be injected for the parameter at position `pos`,
   * considering any `@Qualifier` annotations, and falling back to autowiring by type.
   */
  SpringComponent getInjectedComponent(int pos) {
    // Must be a sub-type of the parameter type
    result.getAnAncestor() = this.getParameterType(pos) and
    // Now look up bean
    if exists(this.getQualifier(pos))
    then
      // Resolved by `@Qualifier("qualifier")` specified on the parameter
      result = this.getQualifier(pos).getSpringComponent()
    else
      if exists(this.getQualifier()) and this.getNumberOfParameters() = 1
      then
        // Resolved by `@Qualifier("qualifier")` on the method
        pos = 0 and
        result = this.getQualifier().getSpringComponent()
      else
        if exists(this.getResource().getNameValue()) and this.getNumberOfParameters() = 1
        then
          // Resolved by looking at the name part of `@Resource(name="qualifier")`
          pos = 0 and
          result = this.getResource().getSpringComponent()
        else
          // Otherwise no restrictions, just by type
          any()
  }
}

/**
 * A field that is annotated with `@Autowired`.
 */
class SpringBeanAutowiredField extends Field {
  SpringBeanAutowiredField() {
    // Marked as `@Autowired`.
    hasInjectAnnotation(this)
  }

  /**
   * If the enclosing type is declared as a bean in an XML file, return the `SpringBean` it is
   * defined in.
   */
  SpringBean getEnclosingSpringBean() {
    result = this.getDeclaringType().(SpringBeanRefType).getSpringBean()
  }

  /**
   * If the enclosing type is declared as a component, return the `SpringComponent`.
   */
  SpringComponent getEnclosingSpringComponent() { result = this.getDeclaringType() }

  /**
   * Gets the qualifier annotation for this method, if any.
   */
  SpringQualifierAnnotation getQualifier() { result = this.getAnAnnotation() }

  /**
   * Gets the resource annotation for this method, if any.
   */
  SpringResourceAnnotation getResource() { result = this.getAnAnnotation() }

  /**
   * Gets the `SpringBean`, if any, that will be injected for this field, considering any `@Qualifier`
   * annotations, and falling back to autowiring by type.
   */
  SpringBean getInjectedBean() {
    // Must be a sub-type of the parameter type
    result.getClass().getAnAncestor() = this.getType() and
    // Now look up bean
    if exists(this.getQualifier())
    then
      // Resolved by `@Qualifier("qualifier")` specified on the field
      result = this.getQualifier().getSpringBean()
    else
      if exists(this.getResource().getNameValue())
      then
        // Resolved by looking at the name part of `@Resource(name="qualifier")`
        result = this.getResource().getSpringBean()
      else
        // Otherwise no restrictions, just by type
        any()
  }

  /**
   * Gets the `SpringComponent`, if any, that will be injected for this field, considering any
   * `@Qualifier` annotations, and falling back to autowiring by type.
   */
  SpringComponent getInjectedComponent() {
    // Must be a sub-type of the parameter type
    result.getAnAncestor() = this.getType() and
    // Now look up bean
    if exists(this.getQualifier())
    then
      // Resolved by `@Qualifier("qualifier")` specified on the field
      result = this.getQualifier().getSpringComponent()
    else
      if exists(this.getResource().getNameValue())
      then
        // Resolved by looking at the name part of `@Resource(name="qualifier")`
        result = this.getResource().getSpringComponent()
      else
        // Otherwise no restrictions, just by type
        any()
  }
}

/**
 * An annotation type that is treated as a qualifier for Spring.
 */
class SpringQualifierAnnotationType extends AnnotationType {
  SpringQualifierAnnotationType() {
    this.hasQualifiedName("org.springframework.beans.factory.annotation", "Qualifier") or
    this.hasQualifiedName("javax.inject", "Qualifier") or
    this.getAnAnnotation().getType() instanceof SpringQualifierAnnotationType
  }
}

/**
 * An annotation marking a `SpringComponent` with a "qualifier" that will be used to resolve when
 * this component will be used in autowiring another component or bean.
 */
class SpringQualifierDefinitionAnnotation extends Annotation {
  SpringQualifierDefinitionAnnotation() {
    this.getType() instanceof SpringQualifierAnnotationType and
    this.getAnnotatedElement() instanceof SpringComponent
  }

  /**
   * Gets the value of the qualifier field for this qualifier.
   */
  string getQualifierValue() { result = this.getStringValue("value") }
}

/**
 * A qualifier annotation on a method or field that is used to disambiguate which bean will be used.
 */
class SpringQualifierAnnotation extends Annotation {
  SpringQualifierAnnotation() { this.getType() instanceof SpringQualifierAnnotationType }

  /**
   * Gets the value of the qualifier field for this qualifier.
   */
  string getQualifierValue() { result = this.getStringValue("value") }

  /**
   * Gets the bean definition in an XML file that this qualifier resolves to, if any.
   */
  SpringBean getSpringBean() { result.getQualifierValue() = this.getQualifierValue() }

  /**
   * Gets the Spring component that this qualifier resolves to, if any.
   */
  SpringComponent getSpringComponent() { result.getQualifierValue() = this.getQualifierValue() }
}

/**
 * A `@Resource` annotation on a field or method that specifies that the field or method should be
 * autowired by Spring, and can optionally specify a qualifier in the "name".
 */
class SpringResourceAnnotation extends Annotation {
  SpringResourceAnnotation() { this.getType().hasQualifiedName("javax.inject", "Resource") }

  /**
   * Gets the specified name value, if any.
   */
  string getNameValue() { result = this.getStringValue("name") }

  /**
   * Gets the bean definition in an XML file that the resource resolves to, if any.
   */
  SpringBean getSpringBean() { result.getQualifierValue() = this.getNameValue() }

  /**
   * Gets the Spring component that this qualifier resolves to, if any.
   */
  SpringComponent getSpringComponent() { result.getQualifierValue() = this.getNameValue() }
}
