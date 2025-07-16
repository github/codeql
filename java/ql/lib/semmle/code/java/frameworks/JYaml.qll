/**
 * DEPRECATED: Now modeled using data extensions instead.
 *
 * Provides classes and predicates for working with the JYaml framework.
 */
overlay[local?]
deprecated module;

import java

/**
 * DEPRECATED: Now modeled using data extensions instead.
 *
 * The class `org.ho.yaml.Yaml` or `org.ho.yaml.YamlConfig`.
 */
deprecated class JYamlLoader extends RefType {
  JYamlLoader() { this.hasQualifiedName("org.ho.yaml", ["Yaml", "YamlConfig"]) }
}

/**
 * DEPRECATED: Now modeled using data extensions instead.
 *
 * A JYaml unsafe load method, declared on either `Yaml` or `YamlConfig`.
 */
deprecated class JYamlLoaderUnsafeLoadMethod extends Method {
  JYamlLoaderUnsafeLoadMethod() {
    this.getDeclaringType() instanceof JYamlLoader and
    this.getName() in ["load", "loadType", "loadStream", "loadStreamOfType"]
  }
}
