/**
 * Provides classes and predicates for working with serverless handlers.
 * E.g. [AWS](https://docs.aws.amazon.com/lambda/latest/dg/nodejs-handler.html) or [serverless](https://npmjs.com/package/serverless)
 */

import javascript

/**
 * Provides classes and predicates for working with serverless handlers.
 * In particular a `RemoteFlowSource` is added for AWS, Alibaba, and serverless.
 */
private module ServerLess {
  /**
   * Holds if the `.yml` file `ymlFile` contains a serverless configuration with `handler` and `codeURI` properties.
   * `codeURI` defaults to the empty string if no explicit value is set in the configuration.
   */
  private predicate hasServerlessHandler(File ymlFile, string handler, string codeURI) {
    exists(YAMLMapping resource | ymlFile = resource.getFile() |
      // There exists at least "AWS::Serverless::Function" and "Aliyun::Serverless::Function"
      resource.lookup("Type").(YAMLScalar).getValue().regexpMatch(".*::Serverless::Function") and
      exists(YAMLMapping properties | properties = resource.lookup("Properties") |
        handler = properties.lookup("Handler").(YAMLScalar).getValue() and
        if exists(properties.lookup("CodeUri"))
        then codeURI = properties.lookup("CodeUri").(YAMLScalar).getValue()
        else codeURI = ""
      )
      or
      // The `serverless` library, which specifies a top-level `functions` property
      exists(YAMLMapping functions |
        functions = resource.lookup("functions") and
        not exists(resource.getParentNode()) and
        handler = functions.getValue(_).(YAMLMapping).lookup("handler").(YAMLScalar).getValue() and
        codeURI = ""
      )
    )
  }

  /**
   * Gets a string where an ending "/." is simplified to "/" (if it exists).
   */
  bindingset[base]
  private string removeTrailingDot(string base) {
    if base.regexpMatch(".*/\\.")
    then result = base.substring(0, base.length() - 1)
    else result = base
  }

  /**
   * Gets a string where a leading "./" is simplified to "" (if it exists).
   */
  bindingset[base]
  private string removeLeadingDotSlash(string base) {
    if base.regexpMatch("\\./.*") then result = base.substring(2, base.length()) else result = base
  }

  /**
   * Gets a path to a file from a `codeURI` property and a file name from a serverless configuration.
   *
   * For example if `codeURI` is "function/." and `file` is "index", then the result becomes "function/index.js".
   */
  bindingset[codeURI, file]
  private string getPathFromHandlerProperties(string codeURI, string file) {
    exists(string folder | folder = removeLeadingDotSlash(removeTrailingDot(codeURI)) |
      result = folder + file + ".js"
    )
  }

  /**
   * Holds if `file` has a serverless handler function with name `func`.
   */
  private predicate hasServerlessHandler(File file, string func) {
    exists(File ymlFile, string handler, string codeURI, string fileName |
      hasServerlessHandler(ymlFile, handler, codeURI) and
      // Splits a `handler` into two components. The `fileName` to the left of the dot, and the `func` to the right.
      // E.g. if `handler` is "index.foo", then `fileName` is "index" and `func` is "foo".
      exists(string pattern | pattern = "(.*)\\.(.*)" |
        fileName = handler.regexpCapture(pattern, 1) and
        func = handler.regexpCapture(pattern, 2)
      )
    |
      file.getAbsolutePath() =
        ymlFile.getParentContainer().getAbsolutePath() + "/" +
          getPathFromHandlerProperties(codeURI, fileName)
    )
  }

  /**
   * Gets a function that is a serverless request handler.
   *
   * For example: if an AWS serverless resource contains the following properties (in the "template.yml" file):
   * ```yaml
   * Handler: mylibrary.handler
   * Runtime: nodejs12.x
   * CodeUri: backend/src/
   * ```
   *
   * And a file "mylibrary.js" exists in the folder "backend/src" (relative to the "template.yml" file).
   * Then the result of this predicate is a function exported as "handler" from "mylibrary.js".
   * The "mylibrary.js" file could for example look like:
   *
   * ```JavaScript
   * module.exports.handler = function (event) { ... }
   * ```
   */
  private DataFlow::FunctionNode getAServerlessHandler() {
    exists(File file, string handler, Module mod | hasServerlessHandler(file, handler) |
      mod.getFile() = file and
      result = mod.getAnExportedValue(handler).getAFunctionValue()
    )
  }

  /**
   * A serverless request handler event, seen as a RemoteFlowSource.
   */
  private class ServerlessHandlerEventAsRemoteFlow extends RemoteFlowSource {
    ServerlessHandlerEventAsRemoteFlow() { this = getAServerlessHandler().getParameter(0) }

    override string getSourceType() { result = "Serverless event" }
  }
}
