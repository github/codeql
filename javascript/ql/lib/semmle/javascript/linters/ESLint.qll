/**
 * Provides classes for working with ESLint directives and configurations.
 */

import javascript

module ESLint {
  /**
   * An ESLint configuration file.
   */
  abstract class Configuration extends Locatable {
    /** Gets the folder in which this configuration file is located. */
    private Folder getEnclosingFolder() { result = getFile().getParentContainer() }

    /** Holds if this configuration file applies to the code in `tl`. */
    predicate appliesTo(TopLevel tl) { tl.getFile().getParentContainer+() = getEnclosingFolder() }

    /** Gets the `globals` configuration object of this file, if any. */
    abstract ConfigurationObject getGlobals();
  }

  /**
   * An ESLint configuration object appearing in a configuration file.
   */
  abstract class ConfigurationObject extends Locatable {
    /** Gets the configuration file to which this object belongs. */
    abstract Configuration getConfiguration();

    /**
     * Gets the value of the Boolean property `p` defined in this
     * configuration object, if any.
     */
    abstract boolean getBooleanProperty(string p);
  }

  /** An ESLint configuration file in JSON format. */
  abstract private class JsonConfiguration extends Configuration, JsonObject { }

  /** An `.eslintrc.json` file. */
  private class EslintrcJson extends JsonConfiguration {
    EslintrcJson() {
      isTopLevel() and
      exists(string n | n = getFile().getBaseName() | n = ".eslintrc.json" or n = ".eslintrc")
    }

    override ConfigurationObject getGlobals() { result = getPropValue("globals") }
  }

  /** An ESLint configuration object in JSON format. */
  private class JsonConfigurationObject extends ConfigurationObject, JsonObject {
    override Configuration getConfiguration() { this = result.(JsonConfiguration).getPropValue(_) }

    override boolean getBooleanProperty(string p) {
      exists(string v | v = getPropValue(p).(JsonBoolean).getValue() |
        v = "true" and result = true
        or
        v = "false" and result = false
      )
    }
  }

  /** An `.eslintrc.yaml` file. */
  private class EslintrcYaml extends Configuration, YAMLDocument, YAMLMapping {
    EslintrcYaml() {
      exists(string n | n = getFile().getBaseName() |
        n = ".eslintrc.yaml" or n = ".eslintrc.yml" or n = ".eslintrc"
      )
    }

    override ConfigurationObject getGlobals() { result = lookup("globals") }
  }

  /** An ESLint configuration object in YAML format. */
  private class YamlConfigurationObject extends ConfigurationObject, YAMLMapping {
    override Configuration getConfiguration() { this = result.(EslintrcYaml).getValue(_) }

    override boolean getBooleanProperty(string p) {
      exists(string v | v = lookup(p).(YAMLBool).getValue() |
        v = "true" and result = true
        or
        v = "false" and result = false
      )
    }
  }

  /** An ESLint configuration embedded in a `package.json` file. */
  private class EslintConfigInPackageJson extends JsonConfiguration {
    EslintConfigInPackageJson() {
      exists(PackageJson pkg | this = pkg.getPropValue("eslintConfig"))
    }

    override ConfigurationObject getGlobals() { result = getPropValue("globals") }
  }

  /** An ESLint `globals` configuration object. */
  class GlobalsConfigurationObject extends Linting::GlobalDeclaration, ConfigurationObject {
    GlobalsConfigurationObject() { this = any(Configuration cfg).getGlobals() }

    override predicate declaresGlobal(string name, boolean writable) {
      getBooleanProperty(name) = writable
    }

    override predicate appliesTo(ExprOrStmt s) { getConfiguration().appliesTo(s.getTopLevel()) }

    abstract override Configuration getConfiguration();

    abstract override boolean getBooleanProperty(string p);
  }
}
