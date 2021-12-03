/**
 * Apache Camel is a messaging framework, which can integrate with Spring.
 */

import java
import semmle.code.java.deadcode.DeadCode
import semmle.code.java.frameworks.Camel

/**
 * A method that may be called by Apache Camel to process a message.
 */
class CamelMessageCallableEntryPoint extends CallableEntryPoint {
  CamelMessageCallableEntryPoint() {
    exists(CamelTargetClass camelTargetClass | this = camelTargetClass.getACamelCalledMethod()) or
    exists(CamelConsumeMethod consumeMethod | this = consumeMethod)
  }
}
