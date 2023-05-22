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
    private Folder getEnclosingFolder() { result = this.getFile().getParentContainer() }

    /** Holds if this configuration file applies to the code in `tl`. */
    predicate appliesTo(TopLevel tl) {
      tl.getFile().getParentContainer+() = this.getEnclosingFolder()
    }

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
      this.isTopLevel() and
      exists(string n | n = this.getFile().getBaseName() | n = ".eslintrc.json" or n = ".eslintrc")
    }

    override ConfigurationObject getGlobals() { result = this.getPropValue("globals") }
  }

  /** An ESLint configuration object in JSON format. */
  private class JsonConfigurationObject extends ConfigurationObject, JsonObject {
    override Configuration getConfiguration() { this = result.(JsonConfiguration).getPropValue(_) }

    override boolean getBooleanProperty(string p) {
      exists(string v | v = this.getPropValue(p).(JsonBoolean).getValue() |
        v = "true" and result = true
        or
        v = "false" and result = false
      )
    }
  }

  /** An `.eslintrc.yaml` file. */
  private class EslintrcYaml extends Configuration instanceof YamlMapping, YamlDocument {
    EslintrcYaml() {
      exists(string n | n = this.(Locatable).getFile().getBaseName() |
        n = ".eslintrc.yaml" or n = ".eslintrc.yml" or n = ".eslintrc"
      )
    }

    override ConfigurationObject getGlobals() { result = super.lookup("globals") }
  }

  /** An ESLint configuration object in YAML format. */
  private class YamlConfigurationObject extends ConfigurationObject instanceof YamlMapping {
    override Configuration getConfiguration() {
      this = result.(EslintrcYaml).(YamlMapping).getValue(_)
    }

    override boolean getBooleanProperty(string p) {
      exists(string v | v = super.lookup(p).(YamlBool).getValue() |
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

    override ConfigurationObject getGlobals() { result = this.getPropValue("globals") }
  }

  /** An ESLint `globals` configuration object. */
  class GlobalsConfigurationObject extends Linting::GlobalDeclaration, ConfigurationObject {
    GlobalsConfigurationObject() { this = any(Configuration cfg).getGlobals() }

    override predicate declaresGlobal(string name, boolean writable) {
      this.getBooleanProperty(name) = writable
    }

    override predicate appliesTo(ExprOrStmt s) {
      this.getConfiguration().appliesTo(s.getTopLevel())
    }

    abstract override Configuration getConfiguration();

    abstract override boolean getBooleanProperty(string p);
  }
}
