/**
 * Provides classes and predicates for working with serverless handlers.
 * E.g. [AWS](https://docs.aws.amazon.com/lambda/latest/dg/nodejs-handler.html) or [serverless](https://npmjs.com/package/serverless)
 * In particular a `RemoteFlowSource` is added for AWS, Alibaba, and serverless.
 */

import javascript
private import codeql.serverless.ServerLess

private module YamlImpl implements Input {
  import semmle.javascript.Files
  import semmle.javascript.YAML
}

module SL = ServerLess<YamlImpl>;

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
  exists(File file, string stem, string handler, Module mod |
    SL::hasServerlessHandler(stem, handler, _, _) and
    file.getAbsolutePath() = stem + ".js"
  |
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
