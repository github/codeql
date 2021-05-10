/**
 * Provides classes and predicates for working with the JYaml framework.
 */

import java

/**
 * The class `org.ho.yaml.Yaml`.
 */
class JYaml extends RefType {
  JYaml() { this.hasQualifiedName("org.ho.yaml", "Yaml") }
}

/**
<<<<<<< HEAD
 * A JYaml unsafe load method. This is either `YAML.load` or
 * `YAML.loadStream` or `YAML.loadStreamOfType`.
=======
 * A JYaml unsafe load method. This is either `YAML.load`.
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
 */
class JYamlUnSafeLoadMethod extends Method {
  JYamlUnSafeLoadMethod() {
    this.getDeclaringType() instanceof JYaml and
    this.getName() in ["load", "loadStream", "loadStreamOfType"]
  }
}

/**
 * The class `org.ho.yaml.YamlConfig`.
 */
class JYamlConfig extends RefType {
  JYamlConfig() { this.hasQualifiedName("org.ho.yaml", "YamlConfig") }
}

/**
<<<<<<< HEAD
 * A JYamlConfig unsafe load method. This is either `YamlConfig.load` or
=======
 * A JYamlConfig unsafe load method. This is either `YamlConfig.load` or 
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
 * `YamlConfig.loadStream` or `YamlConfig.loadStreamOfType`.
 */
class JYamlConfigUnSafeLoadMethod extends Method {
  JYamlConfigUnSafeLoadMethod() {
    this.getDeclaringType() instanceof JYamlConfig and
    this.getName() in ["load", "loadStream", "loadStreamOfType"]
  }
}
