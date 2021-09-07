import java

/**
 * A class which implements the `InitializingBean` interface, directly or indirectly.
 *
 * If this class is used as a Spring bean, the `afterPropertiesSet()` method will be called after
 * bean initialization.
 */
class InitializingBeanClass extends Class {
  InitializingBeanClass() {
    getAnAncestor().hasQualifiedName("org.springframework.beans.factory", "InitializingBean")
  }

  /**
   * Gets the `afterPropertiesSet()` method, which is called after the bean has been initialized.
   */
  Method getAfterPropertiesSet() {
    inherits(result) and
    result.hasName("afterPropertiesSet")
  }
}
