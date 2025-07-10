/**
 * Provides classes and predicates for working with the YamlBeans framework.
 */

import java

/**
 * The class `com.esotericsoftware.yamlbeans.YamlReader`.
 */
class YamlBeansReader extends RefType {
  YamlBeansReader() { this.hasQualifiedName("com.esotericsoftware.yamlbeans", "YamlReader") }
}

/** A method with the name `read` declared in `com.esotericsoftware.yamlbeans.YamlReader`. */
class YamlBeansReaderReadMethod extends Method {
  YamlBeansReaderReadMethod() {
    this.getDeclaringType() instanceof YamlBeansReader and
    this.getName() = "read"
  }
}
