/**
 * Provides classes and predicates for working with those serverless handlers,
 * handled by the shared library.
 *
 * E.g. [AWS](https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html).
 *
 * In particular a `RemoteFlowSource` is added for each.
 */

import python
private import codeql.serverless.ServerLess
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.RemoteFlowSources

private module YamlImpl implements Input {
  import semmle.python.Files
  import semmle.python.Yaml
}

module SL = ServerLess<YamlImpl>;

/**
 * Gets a function that is a serverless request handler.
 *
 * For example: if an AWS serverless resource contains the following properties (in the "template.yml" file):
 * ```yaml
 * Handler: mylibrary.handler
 * Runtime: pythonXXX
 * CodeUri: backend/src/
 * ```
 *
 * And a file "mylibrary.py" exists in the folder "backend/src" (relative to the "template.yml" file).
 * Then the result of this predicate is a function exported as "handler" from "mylibrary.py".
 * The "mylibrary.py" file could for example look like:
 *
 * ```python
 * def handler(event):
 *  ...
 * ```
 */
private Function getAServerlessHandler() {
  exists(File file, string stem, string handler, string runtime, Module mod |
    SL::hasServerlessHandler(stem, handler, _, runtime) and
    file.getAbsolutePath() = stem + ".py" and
    // if runtime is specified, it should be python
    (runtime = "" or runtime.matches("python%"))
  |
    mod.getFile() = file and
    result.getScope() = mod and
    result.getName() = handler
  )
}

private DataFlow::ParameterNode getAHandlerEventParameter() {
  exists(Function func | func = getAServerlessHandler() |
    result.getParameter() in [func.getArg(0), func.getArgByName("event")]
  )
}

/**
 * A serverless request handler event, seen as a RemoteFlowSource.
 */
private class ServerlessHandlerEventAsRemoteFlow extends RemoteFlowSource::Range {
  ServerlessHandlerEventAsRemoteFlow() { this = getAHandlerEventParameter() }

  override string getSourceType() { result = "Serverless event" }
}
