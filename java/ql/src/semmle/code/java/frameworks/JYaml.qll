/**
 * Provides classes and predicates for working with the JYaml framework.
 */

import java

/**
 * The class `org.ho.yaml.Yaml` or `org.ho.yaml.YamlConfig`.
 */
class JYamlLoader extends RefType {
  JYamlLoader() { this.hasQualifiedName("org.ho.yaml", ["Yaml", "YamlConfig"]) }
}

/**
 * A JYaml unsafe load method, declared on either `Yaml` or `YamlConfig`.
 */
class JYamlLoaderUnsafeLoadMethod extends Method {
  JYamlLoaderUnsafeLoadMethod() {
    this.getDeclaringType() instanceof JYamlLoader and
    this.getName() in ["load", "loadType", "loadStream", "loadStreamOfType"]
  }
}
