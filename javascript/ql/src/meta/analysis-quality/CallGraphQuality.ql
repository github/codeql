/**
 * @name Call graph quality
 * @description Measures the number of resolved and unresolved calls, for diagnostic purposes.
 * @id js/meta/call-graph-quality
 */

import javascript::DataFlow
import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps
import semmle.javascript.dependencies.Dependencies
import semmle.javascript.dependencies.FrameworkLibraries
import semmle.javascript.frameworks.Testing

/** A file we ignore because it is a test file or compiled/generated/bundled code. */
class IgnoredFile extends File {
  IgnoredFile() {
    any(Test t).getFile() = this
    or
    getRelativePath().regexpMatch("(?i).*/test(case)?s?/.*")
    or
    getBaseName().regexpMatch("(?i)(.*[._\\-]|^)(min|bundle|concat|spec|tests?)\\.[a-zA-Z]+")
    or
    exists(TopLevel tl | tl.getFile() = this |
      tl.isExterns()
      or
      tl instanceof FrameworkLibraryInstance
    )
  }
}

/** An call site that is relevant for analysis quality. */
class RelevantInvoke extends InvokeNode {
  RelevantInvoke() { not getFile() instanceof IgnoredFile }
}

/**
 * Holds if `name` is a the name of an external module.
 */
predicate isExternalLibrary(string name) {
  // Mentioned in package.json
  any(Dependency dep).info(name, _) or
  // Node.js built-in
  name = "assert" or
  name = "async_hooks" or
  name = "child_process" or
  name = "cluster" or
  name = "crypto" or
  name = "dns" or
  name = "domain" or
  name = "events" or
  name = "fs" or
  name = "http" or
  name = "http2" or
  name = "https" or
  name = "inspector" or
  name = "net" or
  name = "os" or
  name = "path" or
  name = "perf_hooks" or
  name = "process" or
  name = "punycode" or
  name = "querystring" or
  name = "readline" or
  name = "repl" or
  name = "stream" or
  name = "string_decoder" or
  name = "timer" or
  name = "tls" or
  name = "trace_events" or
  name = "tty" or
  name = "dgram" or
  name = "url" or
  name = "util" or
  name = "v8" or
  name = "vm" or
  name = "worker_threads" or
  name = "zlib"
}

predicate isExternalGlobal(string name) {
  exists(ExternalGlobalDecl decl |
    decl.getName() = name
  )
  or
  exists(Dependency dep |
    // If name is never assigned anywhere, and it coincides with a dependency,
    // it's most likely coming from there.
    dep.info(name, _) and
    not exists(Assignment assign |
      assign.getLhs().(GlobalVarAccess).getName() = name
    )
  )
  or
  name = "_"
}

/**
 * Gets a node that was derived from an import of `moduleName`.
 *
 * This is a rough approximation as it follows all property reads, invocations,
 * and callbacks, so some of these might refer to internal objects.
 *
 * Additionally, we don't recognize when a project imports another file in the
 * same project using it module name (e.g. import "vscode" from inside the vscode project).
 */
SourceNode externalNode() {
  exists(string moduleName |
    result = moduleImport(moduleName) and
    isExternalLibrary(moduleName)
  )
  or
  exists(string name |
    result = globalVarRef(name) and
    isExternalGlobal(name)
  )
  or
  result = DOM::domValueRef()
  or
  result = jquery()
  or
  result = externalNode().getAPropertyRead()
  or
  result = externalNode().getAnInvocation()
  or
  result = externalNode().(InvokeNode).getCallback(_).getParameter(_)
}

/**
 * Gets a data flow node that can be resolved to a callback.
 *
 * These are not part of the static call graph, but the data flow analysis can
 * track them, so we consider them resolved.
 */
SourceNode resolvableCallback() {
  result instanceof FunctionNode
  or
  exists(Node arg |
    FlowSteps::argumentPassing(_, arg, _, result) and
    resolvableCallback().flowsTo(arg)
  )
}

/**
 * Gets a call site that can be resolved to an function in the same project.
 */
RelevantInvoke resolvedCall() {
  FlowSteps::calls(result, _)
  or
  result = resolvableCallback().getAnInvocation()
}

/**
 * Gets a call site that is believed to call an external function.
 */
RelevantInvoke externalCall() {
  not result = resolvedCall() and // avoid double counting
  (
    // Call to modelled external library
    result = externalNode()
    or
    // 'require' call or similar
    result = moduleImport(_)
    or
    // Resolved to externs file
    exists(result.(InvokeNode).getACallee(1))
    or
    // Modelled as taint step but isn't from an NPM module. E.g. `substring` or `push`.
    exists(TaintTracking::AdditionalTaintStep step |
      step.step(_, result)
      or
      step.step(result.getAnArgument(), _)
      or
      step.step(_, result.getCallback(_).getParameter(_))
    )
    or
    // Commonly used methods that are usually external and not found by the above
    exists(string name | name = result.(MethodCallNode).getMethodName() |
      name = "indexOf" or
      name = "lastIndexOf" or
      name = "then"
    )
  )
}

/**
 * Gets a call site that could not be resolved.
 */
RelevantInvoke unresolvedCall() {
  not result = resolvedCall() and
  not result = externalCall()
}

// Name all columns in the 'from' clause to get named columns in metadata
from int resolved, int calls, float ratio
where
  calls = count(resolvedCall()) + count(unresolvedCall()) and
  resolved = count(resolvedCall()) and
  ratio = resolved / (float)calls
select resolved, calls, ratio
