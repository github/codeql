/**
 * Provides classes for working with Babel, `.babelrc` files and Babel plugins.
 */

import javascript

module Babel {
  /**
   * A Babel configuration object, either from `package.json` or from a
   * `.babelrc` file.
   */
  class Config extends JSONObject {
    Config() {
      isTopLevel() and getJsonFile().getBaseName().matches(".babelrc%")
      or
      this = any(PackageJSON pkg).getPropValue("babel")
    }

    /**
     * Gets the configuration for the plugin with the given name.
     */
    JSONValue getPluginConfig(string pluginName) {
      exists(JSONArray plugins |
        plugins = getPropValue("plugins") and
        result = plugins.getElementValue(_)
      |
        result.(JSONString).getValue() = pluginName
        or
        result.(JSONArray).getElementStringValue(0) = pluginName
      )
    }

    /**
     * Gets a file affected by this Babel configuration.
     */
    Container getAContainerInScope() {
      result = getJsonFile().getParentContainer()
      or
      result = getAContainerInScope().getAChildContainer() and
      // File-relative .babelrc search stops at any package.json or .babelrc file.
      not result.getAChildContainer() = any(PackageJSON pkg).getJsonFile() and
      not result.getAChildContainer() = any(Config pkg).getJsonFile()
    }

    /**
     * Holds if this configuration applies to `tl`.
     */
    predicate appliesTo(TopLevel tl) { tl.getFile() = getAContainerInScope() }
  }

  /**
   * Configuration object for a Babel plugin.
   */
  class Plugin extends JSONValue {
    Config cfg;
    string pluginName;

    Plugin() { this = cfg.getPluginConfig(pluginName) }

    /** Gets the name of the plugin being installed. */
    string getPluginName() { result = pluginName }

    /** Gets the enclosing Babel configuration object. */
    Config getConfig() { result = cfg }

    /** Gets the options value passed to the plugin, if any. */
    JSONValue getOptions() { result = this.(JSONArray).getElementValue(1) }

    /** Gets a named option from the option object, if present. */
    JSONValue getOption(string name) { result = getOptions().(JSONObject).getPropValue(name) }

    /** Holds if this plugin applies to `tl`. */
    predicate appliesTo(TopLevel tl) { cfg.appliesTo(tl) }
  }

  /**
   * A configuration object for the `babel-plugin-root-import` plugin.
   *
   * This is either of the form `["babel-plugin-root-import"]`, simply specifying that the plugin
   * should be used, or of the form `["babel-plugin-root-import", { "paths": [ <path>... ] }]`, where
   * each path is of the form `{ "rootPathPrefix": "...", "rootPathSuffix": "..." }` and explicitly
   * specifies a mapping from a path prefix to a root.
   */
  class RootImportConfig extends Plugin {
    RootImportConfig() { pluginName = "babel-plugin-root-import" }

    /**
     * Gets the root specified for the given prefix.
     */
    string getRoot(string prefix) {
      result = getExplicitRoot(prefix)
      or
      // by default, `~` is mapped to the folder containing the configuration
      prefix = "~" and
      not exists(getExplicitRoot(prefix)) and
      result = "."
    }

    /**
     * Gets an object specifying a root prefix.
     */
    private JSONObject getARootPathSpec() {
      // ["babel-plugin-root-import", <spec>]
      result = getOptions() and
      exists(result.getPropValue("rootPathSuffix"))
      or
      exists(JSONArray pathSpecs |
        // ["babel-plugin-root-import", [ <spec>... ] ]
        pathSpecs = getOptions()
        or
        // ["babel-plugin-root-import", { "paths": [ <spec> ... ] }]
        pathSpecs = getOption("paths")
      |
        result = pathSpecs.getElementValue(_)
      )
    }

    /**
     * Gets the (explicitly specified) root for the given prefix.
     */
    private string getExplicitRoot(string prefix) {
      exists(JSONObject rootPathSpec |
        rootPathSpec = getARootPathSpec() and
        result = rootPathSpec.getPropStringValue("rootPathSuffix")
      |
        if exists(rootPathSpec.getPropStringValue("rootPathPrefix"))
        then prefix = rootPathSpec.getPropStringValue("rootPathPrefix")
        else prefix = "~"
      )
    }

    /**
     * Gets the folder in which this configuration is located.
     */
    Folder getFolder() { result = getJsonFile().getParentContainer() }
  }

  /**
   * An import path expression that may be transformed by `babel-plugin-root-import`.
   */
  private class BabelRootTransformedPathExpr extends PathExpr, Expr {
    RootImportConfig plugin;
    string rawPath;
    string prefix;
    string mappedPrefix;
    string suffix;

    BabelRootTransformedPathExpr() {
      this instanceof PathExpr and
      plugin.appliesTo(getTopLevel()) and
      rawPath = getStringValue() and
      prefix = rawPath.regexpCapture("(.)/(.*)", 1) and
      suffix = rawPath.regexpCapture("(.)/(.*)", 2) and
      mappedPrefix = plugin.getRoot(prefix)
    }

    /** Gets the configuration that applies to this path. */
    RootImportConfig getPlugin() { result = plugin }

    override string getValue() { result = mappedPrefix + "/" + suffix }

    override Folder getSearchRoot(int priority) {
      priority = 0 and
      result = plugin.getFolder()
    }
  }

  /**
   * An import path transformed by `babel-plugin-root-import`.
   */
  private class BabelRootTransformedPath extends PathString {
    BabelRootTransformedPathExpr pathExpr;

    BabelRootTransformedPath() { this = pathExpr.getValue() }

    override Folder getARootFolder() { result = pathExpr.getPlugin().getFolder() }
  }

  /**
   * A configuration object for the `transform-react-jsx` plugin.
   *
   * The plugin option `{"pragma": xxx}` specifies a variable name used to instantiate
   * JSX elements.
   */
  class TransformReactJsxConfig extends Plugin {
    TransformReactJsxConfig() { pluginName = "transform-react-jsx" }

    /** Gets the name of the variable used to create JSX elements. */
    string getJsxFactoryVariableName() { result = getOption("pragma").(JSONString).getValue() }
  }
}
