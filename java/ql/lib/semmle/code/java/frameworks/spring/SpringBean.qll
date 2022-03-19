import java
import semmle.code.java.frameworks.spring.SpringXMLElement
import semmle.code.java.frameworks.spring.SpringBeanRefType
import semmle.code.java.frameworks.spring.SpringProperty
import semmle.code.java.frameworks.spring.SpringConstructorArg
import semmle.code.java.frameworks.spring.SpringLookupMethod
import semmle.code.java.frameworks.spring.SpringQualifier
import semmle.code.java.frameworks.spring.SpringReplacedMethod

/*
 * Reference: http://docs.spring.io/spring/docs/2.5.x/reference/beans.html#beans-child-bean-definitions
 */

/** A `<bean>` element in a Spring XML file. */
class SpringBean extends SpringXmlElement {
  SpringBean() {
    this.getName() = "bean" and
    // Do not capture Camel beans, which are different
    not this.getNamespace().getURI() = "http://camel.apache.org/schema/spring"
  }

  override string toString() { result = this.getBeanIdentifier() }

  /**
   * Holds if this element is a top-level bean definition.
   */
  predicate isTopLevel() { this.getParent().getName() = "beans" }

  /** Holds if this element has an `id` attribute. */
  predicate hasBeanId() { this.hasAttribute("id") }

  /** Gets the value of the `id` attribute. */
  string getBeanId() { result = this.getAttribute("id").getValue() }

  /** Holds if the bean has a `name` attribute. */
  predicate hasBeanName() { this.hasAttribute("name") }

  /** Gets the value of the `name` attribute. */
  string getBeanName() { result = this.getAttribute("name").getValue() }

  /** Holds if the bean has a `name`, `id` or `class` attribute. */
  predicate hasBeanIdentifier() {
    this.hasBeanName() or
    this.hasClassName() or
    this.hasBeanId()
  }

  /** Gets the bean `id` or `name`, whichever is present, giving priority to `id`. */
  string getBeanIdentifier() {
    // Aliasing is currently not supported.
    if this.hasBeanId()
    then result = this.getBeanId()
    else (
      if this.hasBeanName() then result = this.getBeanName() else result = this.getClassName()
    )
  }

  /** Holds if the bean is abstract. */
  predicate isAbstract() {
    exists(XMLAttribute a |
      a = this.getAttribute("abstract") and
      a.getValue() = "true"
    )
    or
    not exists(this.getClass())
  }

  /** Gets the raw value of the `autowire` attribute. */
  string getAutowireRaw() { result = this.getAttributeValueWithDefault("autowire") }

  /**
   * Gets the `autowire` value for the bean, taking any default values from the
   * enclosing `<beans>` element.
   */
  string getAutowire() {
    if this.getAutowireRaw() != "default"
    then result = this.getAutowireRaw()
    else result = this.getSpringBeanFile().getDefaultAutowire()
  }

  /** Gets the value for the `autowire-candidate` attribute. */
  string getAutowireCandidate() { result = this.getAttributeValueWithDefault("autowire-candidate") }

  /** Holds if the bean has a `class` attribute. */
  predicate hasClassNameRaw() { this.hasAttribute("class") }

  /** Gets the value of the bean's `class` attribute, if any. */
  string getClassNameRaw() { result = this.getAttribute("class").getValue() }

  /** Holds if the bean has a class name, taking parent inheritance into account. */
  predicate hasClassName() {
    this.hasClassNameRaw() or
    this.getBeanParent().hasClassName()
  }

  /** Gets the name of the bean's class, taking parent inheritance into account. */
  string getClassName() {
    if this.hasClassNameRaw()
    then result = this.getClassNameRaw()
    else result = this.getBeanParent().getClassName()
  }

  /** Gets the Java class referred to by the bean's class name. */
  RefType getClass() { result.getQualifiedName() = this.getClassName() }

  /** Gets the value of the `dependency-check` attribute, if any. */
  string getDependencyCheckRaw() { result = this.getAttributeValueWithDefault("dependency-check") }

  /**
   * Gets the `dependency-check` value for the bean, taking any default values declared
   * in the enclosing `<beans>` element.
   */
  string getDependencyCheck() {
    if this.getDependencyCheckRaw() != "default"
    then result = this.getDependencyCheckRaw()
    else result = this.getSpringBeanFile().getDefaultDependencyCheck()
  }

  /** Gets the value of the `depends-on` attribute. */
  string getDependsOnString() { result = this.getAttributeValue("depends-on") }

  /** Holds if the bean has a `destroy-method` attribute. */
  predicate hasDestroyMethodNameRaw() { this.hasAttribute("destroy-method") }

  /** Gets the value of the bean's `destroy-method` attribute. */
  string getDestroyMethodNameRaw() { result = this.getAttributeValue("destroy-method") }

  /**
   * Holds if the bean has a `destroy-method` name, taking bean inheritance and `<beans>`
   * defaults into account.
   */
  predicate hasDestroyMethodName() {
    this.hasDestroyMethodNameRaw() or
    this.getBeanParent().hasDestroyMethodName() or
    this.getSpringBeanFile().hasDefaultDestroyMethod()
  }

  /**
   * Gets the `destroy-method` name of the bean, taking bean inheritance and `<beans>`
   * defaults into account.
   */
  string getDestroyMethodName() {
    if this.hasDestroyMethodNameRaw()
    then result = this.getAttributeValue("destroy-method")
    else (
      if this.getSpringBeanFile().hasDefaultDestroyMethod()
      then result = this.getSpringBeanFile().getDefaultDestroyMethod()
      else result = this.getBeanParent().getDestroyMethodName()
    )
  }

  /** Gets the Java method that corresponds to the bean's `destroy-method`. */
  Method getDestroyMethod() {
    exists(RefType superType |
      this.getClass().hasMethod(result, superType) and
      result.getName() = this.getDestroyMethodName() and
      result.getNumberOfParameters() = 0
    )
  }

  /** Holds if the bean has a `factory-bean` attribute. */
  predicate hasFactoryBeanNameRaw() { this.hasAttribute("factory-bean") }

  /** Gets the value of the `factory-bean` attribute. */
  string getFactoryBeanNameRaw() { result = this.getAttributeValue("factory-bean") }

  /** Gets the name of the bean's `factory-bean`, taking bean inheritance into account. */
  string getFactoryBeanName() {
    if this.hasFactoryBeanNameRaw()
    then result = this.getFactoryBeanNameRaw()
    else result = this.getBeanParent().getFactoryBeanName()
  }

  /** Holds if the bean as a `factory-method` attribute. */
  predicate hasFactoryMethodNameRaw() { this.hasAttribute("factory-method") }

  /** Gets the value of the `factory-method` attribute. */
  string getFactoryMethodNameRaw() { result = this.getAttributeValue("factory-method") }

  /** Gets the name of the bean's `factory-method`, taking bean inheritance into account. */
  string getFactoryMethodName() {
    if this.hasFactoryMethodNameRaw()
    then result = this.getFactoryMethodNameRaw()
    else result = this.getBeanParent().getFactoryMethodName()
  }

  /** Holds if the bean has an `init-method` attribute. */
  predicate hasInitMethodNameRaw() { this.hasAttribute("init-method") }

  /** Gets the value of the bean's `init-method` attribute. */
  string getInitMethodNameRaw() { result = this.getAttributeValue("init-method") }

  /**
   * Holds if the bean has an `init-method` name, taking bean inheritance and `<beans>`
   * defaults into account.
   */
  predicate hasInitMethodName() {
    this.hasInitMethodNameRaw() or
    this.getBeanParent().hasInitMethodName() or
    this.getSpringBeanFile().hasDefaultInitMethod()
  }

  /**
   * Gets the `init-method` name of the bean, taking bean inheritance and `<beans>`
   * defaults into account.
   */
  string getInitMethodName() {
    if this.hasInitMethodNameRaw()
    then result = this.getInitMethodNameRaw()
    else (
      if this.getSpringBeanFile().hasDefaultInitMethod()
      then result = this.getSpringBeanFile().getDefaultInitMethod()
      else result = this.getBeanParent().getInitMethodName()
    )
  }

  /** Gets the Java method that the `init-method` corresponds to. */
  Method getInitMethod() {
    exists(RefType superType |
      this.getClass().hasMethod(result, superType) and
      result.getName() = this.getInitMethodName() and
      result.getNumberOfParameters() = 0
    )
  }

  /** Gets the name of the bean's parent bean. */
  string getBeanParentName() { result = this.getAttributeValue("parent") }

  /** Holds if the bean has a `parent` attribute. */
  predicate hasBeanParentName() { this.hasAttribute("parent") }

  /** Gets the `SpringBean` parent of this bean. */
  SpringBean getBeanParent() { result.getBeanIdentifier() = this.getBeanParentName() }

  /** Holds if this bean has a parent bean. */
  predicate hasBeanParent() { exists(this.getBeanParent()) }

  predicate hasBeanAncestor(SpringBean ancestor) {
    ancestor = this.getBeanParent() or
    this.getBeanParent().hasBeanAncestor(ancestor)
  }

  /** Gets the value of the bean's `lazy-init` attribute. */
  string getLazyInitRaw() { result = this.getAttributeValueWithDefault("lazy-init") }

  /**
   * Holds if the bean is to be lazily initialized.
   * Takes `<beans>` defaults into account.
   */
  predicate isLazyInit() {
    if this.getLazyInitRaw() != "default"
    then this.getAttributeValue("lazy-init") = "true"
    else this.getSpringBeanFile().isDefaultLazyInit()
  }

  /** Holds if the bean has been declared to be a `primary` bean for autowiring. */
  predicate isPrimary() {
    exists(XMLAttribute a | a = this.getAttribute("primary") and a.getValue() = "true")
  }

  /** Gets the scope of the bean. */
  string getScope() {
    if this.hasAttribute("scope")
    then result = this.getAttributeValue("scope")
    else result = "singleton"
  }

  /**
   * Holds if this bean element has the same bean identifier as `other`.
   */
  override predicate isSimilar(SpringXmlElement other) {
    this.getBeanIdentifier() = other.(SpringBean).getBeanIdentifier()
  }

  /**
   * Gets a `<property>` element declared in this bean (not inherited from parent beans).
   */
  SpringProperty getADeclaredProperty() { result = this.getASpringChild() }

  /** Any `<property>` elements inherited from parent beans. */
  SpringProperty getAnInheritedProperty() {
    not exists(SpringProperty thisProperty |
      thisProperty = this.getADeclaredProperty() and
      result.getPropertyName() = thisProperty.getPropertyName()
    ) and
    (
      result = this.getBeanParent().getADeclaredProperty() or
      result = this.getBeanParent().getAnInheritedProperty()
    )
  }

  /**
   * Any `<property>` elements that apply to this bean
   * (including those inherited from the parent bean).
   */
  SpringProperty getAProperty() {
    result = this.getADeclaredProperty() or
    result = this.getAnInheritedProperty()
  }

  /** Gets a `<constructor-arg>` element declared in this bean. */
  SpringConstructorArg getADeclaredConstructorArg() { result = this.getASpringChild() }

  /** Gets a `<constructor-arg>` element inherited from the parent bean. */
  SpringConstructorArg getAnInheritedConstructorArg() {
    not exists(SpringConstructorArg thisArg |
      thisArg = this.getADeclaredConstructorArg() and
      thisArg.conflictsWithArg(result)
    ) and
    (
      result = this.getBeanParent().getADeclaredConstructorArg() or
      result = this.getBeanParent().getAnInheritedConstructorArg()
    )
  }

  /**
   * Gets a `<constructor-arg>` element that applies to this bean
   * (including those inherited from the parent bean).
   */
  SpringConstructorArg getAConstructorArg() {
    result = this.getADeclaredConstructorArg() or
    result = this.getAnInheritedConstructorArg()
  }

  /** Gets a `<lookup-method>` element declared in this bean. */
  SpringLookupMethod getADeclaredLookupMethod() { result = this.getASpringChild() }

  /** Gets a `<lookup-method>` element inherited from the parent bean. */
  SpringLookupMethod getAnInheritedLookupMethod() {
    not exists(SpringLookupMethod thisMethod |
      thisMethod = this.getADeclaredLookupMethod() and
      thisMethod.getMethodName() = result.getMethodName()
    ) and
    (
      result = this.getBeanParent().getADeclaredLookupMethod() or
      result = this.getBeanParent().getAnInheritedLookupMethod()
    )
  }

  /**
   * Gets a `<lookup-method>` element that applies to this bean
   * (including those inherited from the parent bean).
   */
  SpringLookupMethod getALookupMethod() {
    result = this.getADeclaredLookupMethod() or
    result = this.getAnInheritedLookupMethod()
  }

  /** Gets a `<replaced-method>` element declared in this bean. */
  SpringReplacedMethod getADeclaredReplacedMethod() { result = this.getASpringChild() }

  /** Gets a `<replaced-method>` element inherited from the parent bean. */
  SpringReplacedMethod getAnInheritedReplacedMethod() {
    not exists(SpringReplacedMethod thisMethod |
      thisMethod = this.getADeclaredReplacedMethod() and
      thisMethod.getMethodName() = result.getMethodName()
    ) and
    (
      result = this.getBeanParent().getADeclaredReplacedMethod() or
      result = this.getBeanParent().getAnInheritedReplacedMethod()
    )
  }

  /**
   * Gets a `<replaced-method>` element that applies to this bean
   * (including those inherited from the parent bean).
   */
  SpringLookupMethod getAReplacedMethod() {
    result = this.getADeclaredReplacedMethod() or
    result = this.getAnInheritedReplacedMethod()
  }

  /**
   * Gets the `SpringBean` specified by reference as the factory bean.
   */
  SpringBean getFactoryBean() { result.getBeanIdentifier() = this.getFactoryBeanName() }

  /**
   * Gets the factory method that the Java method corresponds to.
   */
  Method getFactoryMethod() {
    exists(string factoryMethod | factoryMethod = this.getFactoryMethodName() |
      // If a factory bean is specified, use that, otherwise use the current bean.
      (
        if exists(this.getFactoryBeanName())
        then result.getDeclaringType() = this.getFactoryBean().getClass()
        else (
          result.getDeclaringType() = this.getClass() and
          // Must be static because we don't yet have an instance.
          result.isStatic()
        )
      ) and
      // The factory method has this name.
      result.getName() = factoryMethod
    )
  }

  /**
   * Gets the qualifier value for this `SpringBean`, defaulting to
   * the bean identifier if no qualifier is specified.
   */
  string getQualifierValue() {
    if exists(this.getQualifier())
    then result = this.getQualifier().getQualifierValue()
    else result = this.getBeanIdentifier()
  }

  /**
   * Gets the qualifier for this bean.
   */
  SpringQualifier getQualifier() { result = this.getASpringChild() }
}
