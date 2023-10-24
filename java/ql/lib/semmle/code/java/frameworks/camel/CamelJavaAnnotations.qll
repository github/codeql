/**
 * Provides classes and predicates for the Apache Camel Java annotations.
 *
 * Apache Camel allows "routes" to be defined in Java, using annotations. For example:
 *
 * ```
 * public class ConsumeMdb {
 *   @Consume(uri = "activemq:queue:sayhello")
 *   public String onMyMessage(String message) {
 *       return "Hello " + message;
 *   }
 * }
 * ```
 *
 * This creates a route to the `ConsumeMdb` class for messages sent to "activemq:queue:sayhello".
 */

import java
import semmle.code.java.Reflection
import semmle.code.java.frameworks.spring.Spring

class CamelAnnotation extends Annotation {
  CamelAnnotation() { this.getType().getPackage().hasName("org.apache.camel") }
}

/**
 * An annotation indicating that the annotated method is called by Apache Camel.
 */
class CamelConsumeAnnotation extends CamelAnnotation {
  CamelConsumeAnnotation() { this.getType().hasName("Consume") }
}

/**
 * A method that may be called by Apache Camel in response to a message.
 */
class CamelConsumeMethod extends Method {
  CamelConsumeMethod() { this.getAnAnnotation() instanceof CamelConsumeAnnotation }
}
