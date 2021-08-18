/**
 * Provides classes and predicates for identifying classes reflectively constructed by Selenium using the
 * `PageFactory.initElements(...)` method.
 */

import default
import semmle.code.java.Reflection

/**
 * The Selenium `PageFactory` class used to create page objects
 */
class SeleniumPageFactory extends Class {
  SeleniumPageFactory() { hasQualifiedName("org.openqa.selenium.support", "PageFactory") }
}

/**
 * A call to the Selenium `PageFactory.initElements` method, to construct a page object.
 */
class SeleniumInitElementsAccess extends MethodAccess {
  SeleniumInitElementsAccess() {
    getMethod().getDeclaringType() instanceof SeleniumPageFactory and
    getMethod().hasName("initElements")
  }

  /**
   * Gets the class that is initialized by this call..
   */
  Class getInitClass() { result = inferClassParameterType(getArgument(1)) }
}

/**
 * A class which is constructed by Selenium as a page object using `PageFactory.initElements(...)`.
 */
class SeleniumPageObject extends Class {
  SeleniumPageObject() { exists(SeleniumInitElementsAccess init | this = init.getInitClass()) }
}
