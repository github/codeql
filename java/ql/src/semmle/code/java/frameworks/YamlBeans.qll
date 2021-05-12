/**
 * Provides classes and predicates for working with the YamlBeans framework.
 */

import java

/**
 * The class `com.esotericsoftware.yamlbeans.YamlReader`.
 */
class YamlReader extends RefType {
  YamlReader() { this.hasQualifiedName("com.esotericsoftware.yamlbeans", "YamlReader") }
}

/** A method with the name `read` declared in `com.esotericsoftware.yamlbeans.YamlReader`. */
class YamlReaderReadMethod extends Method {
  YamlReaderReadMethod() {
    this.getDeclaringType() instanceof YamlReader and
    this.getName() = "read"
  }
}
