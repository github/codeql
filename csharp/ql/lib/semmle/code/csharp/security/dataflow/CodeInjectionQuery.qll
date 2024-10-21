/**
 * Provides a taint-tracking configuration for reasoning about user input treated as code vulnerabilities.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.system.codedom.Compiler
private import semmle.code.csharp.security.Sanitizers
private import semmle.code.csharp.dataflow.internal.ExternalFlow

/**
 * A data flow source for user input treated as code vulnerabilities.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for user input treated as code vulnerabilities.
 */
abstract class Sink extends ApiSinkExprNode { }

/**
 * A sanitizer for user input treated as code vulnerabilities.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for user input treated as code vulnerabilities.
 */
private module CodeInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for user input treated as code vulnerabilities.
 */
module CodeInjection = TaintTracking::Global<CodeInjectionConfig>;

/**
 * DEPRECATED: Use `ThreatModelSource` instead.
 *
 * A source of remote user input.
 */
deprecated class RemoteSource extends DataFlow::Node instanceof RemoteFlowSource { }

/**
 * DEPRECATED: Use `ThreatModelSource` instead.
 *
 * A source of local user input.
 */
deprecated class LocalSource extends DataFlow::Node instanceof LocalFlowSource { }

/** A source supported by the current threat model. */
class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }

/**
 * A `source` argument to a call to `ICodeCompiler.CompileAssemblyFromSource*` which is a sink for
 * code injection vulnerabilities.
 */
class CompileAssemblyFromSourceSink extends Sink {
  CompileAssemblyFromSourceSink() {
    exists(Method m, MethodCall mc |
      m.getName().matches("CompileAssemblyFromSource%") and
      m = any(SystemCodeDomCompilerICodeCompilerClass c).getAMethod() and
      mc = m.getAnOverrider*().getACall()
    |
      this.getExpr() = mc.getArgumentForName("source") or
      this.getExpr() = mc.getArgumentForName("sources")
    )
  }
}

/**
 * A `code` argument to a call to a method on `CSharpScript`.
 *
 * This class is provided by Roslyn, and allows dynamic evaluation of C#.
 */
class RoslynCSharpScriptSink extends Sink {
  RoslynCSharpScriptSink() {
    exists(Class c |
      c.hasFullyQualifiedName("Microsoft.CodeAnalysis.CSharp.Scripting", "CSharpScript")
    |
      this.getExpr() = c.getAMethod().getACall().getArgumentForName("code")
    )
  }
}

/** Code injection sinks defined through CSV models. */
private class ExternalCodeInjectionExprSink extends Sink {
  ExternalCodeInjectionExprSink() { sinkNode(this, "code-injection") }
}
