/**
 * Provides a taint-tracking configuration for reasoning about user input treated as code vulnerabilities.
 */

import csharp

module CodeInjection {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.security.dataflow.flowsources.Local
  import semmle.code.csharp.frameworks.system.codedom.Compiler
  import semmle.code.csharp.security.Sanitizers

  /**
   * A data flow source for user input treated as code vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for user input treated as code vulnerabilities.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for user input treated as code vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for user input treated as code vulnerabilities.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "CodeInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** A source of remote user input. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /** A source of local user input. */
  class LocalSource extends Source {
    LocalSource() { this instanceof LocalFlowSource }
  }

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
        c.hasQualifiedName("Microsoft.CodeAnalysis.CSharp.Scripting", "CSharpScript")
      |
        this.getExpr() = c.getAMethod().getACall().getArgumentForName("code")
      )
    }
  }
}
