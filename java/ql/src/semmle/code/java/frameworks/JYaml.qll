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
 * A JYaml unsafe load method. This is either `YAML.load` or
 * `YAML.loadType` or `YAML.loadStream` or `YAML.loadStreamOfType`.
 */
class JYamlUnSafeLoadMethod extends Method {
  JYamlUnSafeLoadMethod() {
    this.getDeclaringType() instanceof JYaml and
    this.getName() in ["load", "loadType", "loadStream", "loadStreamOfType"]
  }
}

/**
 * The class `org.ho.yaml.YamlConfig`.
 */
class JYamlConfig extends RefType {
  JYamlConfig() { this.hasQualifiedName("org.ho.yaml", "YamlConfig") }
}

/**
 * A JYamlConfig unsafe load method. This is either `YamlConfig.load` or
 * `YAML.loadType` or `YamlConfig.loadStream` or `YamlConfig.loadStreamOfType`.
 */
class JYamlConfigUnSafeLoadMethod extends Method {
  JYamlConfigUnSafeLoadMethod() {
    this.getDeclaringType() instanceof JYamlConfig and
    this.getName() in ["load", "loadType", "loadStream", "loadStreamOfType"]
  }
}
