import java
import semmle.code.java.frameworks.spring.SpringBean

/**
 * A Spring XML file.
 *
 * This class includes methods to access attributes of the `<beans>` element.
 */
class SpringBeanFile extends XMLFile {
  SpringBeanFile() {
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "beans"
  }

  /**
   * Gets a `<bean>` element that is found in this file.
   *
   * Note that this will also include `<bean>` elements nested
   * inside other spring elements (such as `value`).
   *
   * Use `SpringBean.isTopLevel()` to obtain only the `<bean>`
   * elements that are direct children of `<beans>`.
   */
  SpringBean getABean() { exists(SpringBean b | b.getFile() = this and result = b) }

  /** Gets the `<beans>` element of the file. */
  XMLElement getBeansElement() {
    result = this.getAChild() and
    result.getName() = "beans"
  }

  /**
   * Gets a `profile` expression for which this beans file is enabled, or nothing if it is
   * applicable to any profile.
   */
  string getAProfileExpr() {
    result =
      this.getBeansElement()
          .getAttribute("profile")
          .getValue()
          .splitAt(",")
          .splitAt(" ")
          .splitAt(";") and
    result.length() != 0
  }

  /** Gets the `default-autowire` value for this file. */
  string getDefaultAutowire() {
    if this.getBeansElement().hasAttribute("default-autowire")
    then result = this.getBeansElement().getAttributeValue("default-autowire")
    else result = "no"
  }

  /** Gets the `default-autowire-candidates` value for this file. */
  string getDefaultAutowireCandidatesPattern() {
    result = this.getBeansElement().getAttributeValue("default-autowire-candidates")
  }

  /** Gets the `default-dependency-check` value for this file. */
  string getDefaultDependencyCheck() {
    if exists(this.getBeansElement().getAttribute("default-dependency-check"))
    then result = this.getBeansElement().getAttributeValue("default-dependency-check")
    else result = "none"
  }

  /** Gets the `default-destroy-method` value for this file. */
  string getDefaultDestroyMethod() {
    result = this.getBeansElement().getAttributeValue("default-destroy-method")
  }

  /** Holds if this file has a `default-destroy-method` value. */
  predicate hasDefaultDestroyMethod() {
    exists(this.getBeansElement().getAttribute("default-destroy-method"))
  }

  /** Gets the `default-init-method` value for this file. */
  string getDefaultInitMethod() {
    result = this.getBeansElement().getAttributeValue("default-init-method")
  }

  /** Holds if the file has a `default-destroy-method` value. */
  predicate hasDefaultInitMethod() {
    exists(this.getBeansElement().getAttribute("default-init-method"))
  }

  /** Holds if `default-lazy-init` is specified to be `true` for this file. */
  predicate isDefaultLazyInit() {
    exists(XMLAttribute a |
      this.getBeansElement().getAttribute("default-lazy-init") = a and
      a.getValue() = "true"
    )
  }

  /** Holds if `default-merge` is specified to be `true` for this file. */
  predicate isDefaultMerge() {
    exists(XMLAttribute a |
      this.getBeansElement().getAttribute("default-merge") = a and
      a.getValue() = "true"
    )
  }
}
