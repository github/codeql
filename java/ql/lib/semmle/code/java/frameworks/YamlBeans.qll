/**
 * Provides classes and predicates for working with the YamlBeans framework.
 */
overlay[local?]
module;

import java

/**
 * The class `com.esotericsoftware.yamlbeans.YamlReader`.
 */
class YamlBeansReader extends RefType {
  YamlBeansReader() { this.hasQualifiedName("com.esotericsoftware.yamlbeans", "YamlReader") }
}

/**
 * DEPRECATED: Now modeled using data extensions instead.
 *
 * A method with the name `read` declared in `com.esotericsoftware.yamlbeans.YamlReader`.
 */
deprecated class YamlBeansReaderReadMethod extends Method {
  YamlBeansReaderReadMethod() {
    this.getDeclaringType() instanceof YamlBeansReader and
    this.getName() = "read"
  }
}
