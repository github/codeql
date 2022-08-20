/**
 * @name Use shortcut forms for values
 * @description Using shortcut forms may make a Spring XML configuration file less cluttered.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/non-shortcut-form
 * @tags maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

class SpringConstructorArgUseShortcut extends SpringConstructorArg {
  SpringConstructorArgUseShortcut() {
    not this.hasArgValueString() and
    this.getASpringChild() instanceof SpringValue
  }

  string getMessage() {
    not this.hasArgValueString() and
    this.getASpringChild() instanceof SpringValue and
    result = "Use the shortcut \"value\" attribute instead of a nested <value> element."
  }
}

class SpringEntryUseShortcut extends SpringEntry {
  SpringEntryUseShortcut() {
    not this.hasValueStringRaw() and
    this.getASpringChild() instanceof SpringValue
  }

  string getMessage() {
    not this.hasValueStringRaw() and
    this.getASpringChild() instanceof SpringValue and
    result = "Use the shortcut \"value\" attribute instead of a nested <value> element."
  }
}

class SpringPropertyUseShortcut extends SpringProperty {
  SpringPropertyUseShortcut() {
    not this.hasPropertyValueString() and
    this.getASpringChild() instanceof SpringValue
  }

  string getMessage() {
    not this.hasPropertyValueString() and
    this.getASpringChild() instanceof SpringValue and
    result = "Use the shortcut \"value\" attribute instead of a nested <value> element."
  }
}

from SpringXmlElement springElement, string msg
where
  exists(SpringConstructorArgUseShortcut cons | cons = springElement and msg = cons.getMessage())
  or
  exists(SpringEntryUseShortcut entry | entry = springElement and msg = entry.getMessage())
  or
  exists(SpringPropertyUseShortcut prop | prop = springElement and msg = prop.getMessage())
select springElement, msg
