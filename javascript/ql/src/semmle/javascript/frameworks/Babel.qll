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
      isTopLevel() and getFile().getBaseName().matches(".babelrc%")
      or
      this = any(PackageJSON pkg).getPropValue("babel")
    }

    /**
     * Gets the configuration for the plugin with the given name.
     */
    JSONValue getPluginConfig(string pluginName) {
      exists (JSONArray plugins |
        plugins = getPropValue("plugins") and
        result = plugins.getElementValue(_) |
        result.(JSONString).getValue() = pluginName
        or
        result.(JSONArray).getElementStringValue(0) = pluginName
      )
    }
  }

  /**
   * A configuration object for the `babel-plugin-root-import` plugin.
   *
   * This is either of the form `["babel-plugin-root-import"]`, simply specifying that the plugin
   * should be used, or of the form `["babel-plugin-root-import", { "paths": [ <path>... ] }]`, where
   * each path is of the form `{ "rootPathPrefix": "...", "rootPathSuffix": "..." }` and explicitly
   * specifies a mapping from a path prefix to a root.
   */
  class RootImportConfig extends JSONArray {
    Config cfg;

    RootImportConfig() {
      this = cfg.getPluginConfig("babel-plugin-root-import")
    }

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
      result = getElementValue(1) and
      exists(result.getPropValue("rootPathSuffix"))
      or
      exists (JSONArray pathSpecs |
        // ["babel-plugin-root-import", [ <spec>... ] ]
        pathSpecs = getElementValue(1)
        or
        // ["babel-plugin-root-import", { "paths": [ <spec> ... ] }]
        pathSpecs = getElementValue(1).(JSONObject).getPropValue("paths") |
        result = pathSpecs.getElementValue(_)
      )
    }

    /**
     * Gets the (explicitly specified) root for the given prefix.
     */
    private string getExplicitRoot(string prefix) {
      exists (JSONObject rootPathSpec |
        rootPathSpec = getARootPathSpec() and
        result = rootPathSpec.getPropStringValue("rootPathSuffix") |
        if exists(rootPathSpec.getPropStringValue("rootPathPrefix")) then
          prefix = rootPathSpec.getPropStringValue("rootPathPrefix")
        else
          prefix = "~"
      )
    }

    /**
     * Gets the folder in which this configuration is located.
     */
    Folder getFolder() {
      result = getFile().getParentContainer()
    }

    /**
     * Holds if this configuration applies to `tl`.
     */
    predicate appliesTo(TopLevel tl) {
      tl.getFile().getParentContainer+() = getFolder()
    }
  }

  /**
   * An import path expression that may be transformed by `babel-plugin-root-import`.
   */
  private class BabelRootTransformedPathExpr extends PathExpr, Expr {
    RootImportConfig cfg;
    string rawPath;
    string prefix;
    string mappedPrefix;
    string suffix;

    BabelRootTransformedPathExpr() {
      this instanceof PathExpr and
      cfg.appliesTo(getTopLevel()) and
      rawPath = getStringValue() and
      prefix = rawPath.regexpCapture("(.)/(.*)", 1) and
      suffix = rawPath.regexpCapture("(.)/(.*)", 2) and
      mappedPrefix = cfg.getRoot(prefix)
    }

    /** Gets the configuration that applies to this path. */
    RootImportConfig getConfig() {
      result = cfg
    }

    override string getValue() {
      result = mappedPrefix + "/" + suffix
    }

    override Folder getSearchRoot(int priority) {
      priority = 0 and
      result = cfg.getFolder()
    }
  }

  /**
   * An import path transformed by `babel-plugin-root-import`.
   */
  private class BabelRootTransformedPath extends PathString {
    BabelRootTransformedPathExpr pathExpr;

    BabelRootTransformedPath() {
      this = pathExpr.getValue()
    }

    override Folder getARootFolder() {
      result = pathExpr.getConfig().getFolder()
    }
  }
}
