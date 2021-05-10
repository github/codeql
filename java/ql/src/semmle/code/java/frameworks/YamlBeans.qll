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

<<<<<<< HEAD
/** A method with the name `read` declared in `com.esotericsoftware.yamlbeans.YamlReader`. */
=======
/**
 * A YamlReader read method. This is either `YamlReader.read`.
 */
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
class YamlReaderReadMethod extends Method {
  YamlReaderReadMethod() {
    this.getDeclaringType() instanceof YamlReader and
    this.getName() = "read"
  }
}
