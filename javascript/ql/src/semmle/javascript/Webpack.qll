/**
 * Models the behavior of `webpack` configuration files.
 */

private import javascript

private class WebpackConfigModule extends TopLevel {
  WebpackConfigModule() { getFile().getStem() = "webpack.config" }

  DataFlow::Node getExportedNode() { result = this.(Module).getABulkExportedValue() }

  DataFlow::SourceNode getMainObject() {
    result = getExportedNode().getALocalSource()
    or
    result = getMainObject().(DataFlow::ObjectLiteralNode).getASpreadProperty().getALocalSource()
  }

  DataFlow::SourceNode getResolveObject() {
    result = getMainObject().getAPropertySource("resolve")
    or
    result = getResolveObject().(DataFlow::ObjectLiteralNode).getASpreadProperty().getALocalSource()
  }

  DataFlow::SourceNode getAliasObject() {
    result = getResolveObject().getAPropertySource("alias")
    or
    result = getAliasObject().(DataFlow::ObjectLiteralNode).getASpreadProperty().getALocalSource()
  }

  predicate hasAlias(string name, DataFlow::Node value) {
    getAliasObject().getAPropertyWrite(name).getRhs() = value
  }

  predicate hasAliasValue(string name, string value) {
    exists(DataFlow::Node node |
      hasAlias(name, node) and
      value = [node.getStringValue(), node.asExpr().(PathExpr).getValue()]
    )
  }

  /**
   * Gets the folder affected by this webpack configuration.
   *
   * If there is no sibling `package.json` file, it will use the parent folder
   * if a `package.json` file could be found there.
   */
  Folder getEffectiveFolder() {
    exists(Folder folder | folder = getFile().getParentContainer() |
      if
        not exists(folder.getFile("package.json")) and
        exists(folder.getParentContainer().getFile("package.json"))
      then result = folder.getParentContainer()
      else result = folder
    )
  }
}

private class WebpackPathAlias extends ImportResolution::ScopedPathMapping {
  WebpackConfigModule config;

  WebpackPathAlias() { this = config.getEffectiveFolder() }

  override predicate replaceByPrefix(string oldPrefix, string newPrefix) {
    config.hasAliasValue(oldPrefix, newPrefix)
  }
}
