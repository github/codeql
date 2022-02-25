/** Definitions related to the Server Side Template Injection (SSTI) query. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import experimental.semmle.code.java.frameworks.FreeMarker
import experimental.semmle.code.java.frameworks.Velocity
import experimental.semmle.code.java.frameworks.JinJava
import experimental.semmle.code.java.frameworks.Pebble
import experimental.semmle.code.java.frameworks.Thymeleaf

/** A taint tracking configuration to reason about Server Side Template Injection (SSTI) vulnerabilities */
class TemplateInjectionFlowConfig extends TaintTracking::Configuration {
  TemplateInjectionFlowConfig() { this = "TemplateInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(AdditionalFlowStep a | a.isAdditionalTaintStep(prev, succ))
  }
}

/**
 * A data flow sink for Server Side Template Injection (SSTI) vulnerabilities
 */
abstract private class Sink extends DataFlow::ExprNode { }

/**
 * A data flow step for Server Side Template Injection (SSTI) vulnerabilities
 */
private class AdditionalFlowStep extends Unit {
  abstract predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ);
}

/**
 * An argument to FreeMarker template engine's `process` method call.
 */
private class FreeMarkerProcessSink extends Sink {
  FreeMarkerProcessSink() {
    exists(MethodAccess m |
      m.getCallee() instanceof MethodFreeMarkerTemplateProcess and
      m.getArgument(0) = this.getExpr()
    )
  }
}

/**
 * An reader passed an argument to FreeMarker template engine's `Template`
 *   construtor call.
 */
private class FreeMarkerConstructorSink extends Sink {
  FreeMarkerConstructorSink() {
    // Template(java.lang.String name, java.io.Reader reader)
    // Template(java.lang.String name, java.io.Reader reader, Configuration cfg)
    // Template(java.lang.String name, java.io.Reader reader, Configuration cfg, java.lang.String encoding)
    // Template(java.lang.String name, java.lang.String sourceName, java.io.Reader reader, Configuration cfg)
    // Template(java.lang.String name, java.lang.String sourceName, java.io.Reader reader, Configuration cfg, ParserConfiguration customParserConfiguration, java.lang.String encoding)
    // Template(java.lang.String name, java.lang.String sourceName, java.io.Reader reader, Configuration cfg, java.lang.String encoding)
    exists(ConstructorCall cc, Expr e |
      cc.getConstructor().getDeclaringType() instanceof TypeFreeMarkerTemplate and
      e = cc.getAnArgument() and
      (
        e.getType().(RefType).hasQualifiedName("java.io", "Reader") and
        this.asExpr() = e
      )
    )
    or
    exists(ConstructorCall cc |
      cc.getConstructor().getDeclaringType() instanceof TypeFreeMarkerTemplate and
      // Template(java.lang.String name, java.lang.String sourceCode, Configuration cfg)
      cc.getNumArgument() = 3 and
      cc.getArgument(1).getType() instanceof TypeString and
      this.asExpr() = cc.getArgument(1)
    )
  }
}

/**
 * An argument to FreeMarker template engine's `putTemplate` method call.
 */
private class FreeMarkerStringTemplateLoaderPutTemplateSink extends Sink {
  FreeMarkerStringTemplateLoaderPutTemplateSink() {
    exists(MethodAccess ma |
      this.asExpr() = ma.getArgument(1) and
      ma.getMethod() instanceof MethodFreeMarkerStringTemplateLoaderPutTemplate
    )
  }
}

/**
 * An argument to Pebble template engine's `getLiteralTemplate` or `getTemplate` method call.
 */
private class PebbleGetTemplateSinkTemplateSink extends Sink {
  PebbleGetTemplateSinkTemplateSink() {
    exists(MethodAccess ma |
      this.asExpr() = ma.getArgument(0) and
      ma.getMethod() instanceof MethodPebbleGetTemplate
    )
  }
}

/**
 * An argument to JinJava template engine's `render` or `renderForResult` method call.
 */
private class JinjavaRenderSink extends Sink {
  JinjavaRenderSink() {
    exists(MethodAccess ma |
      this.asExpr() = ma.getArgument(0) and
      (
        ma.getMethod() instanceof MethodJinjavaRenderForResult
        or
        ma.getMethod() instanceof MethodJinjavaRender
      )
    )
  }
}

/**
 * An argument to ThymeLeaf template engine's `process` method call.
 */
private class ThymeLeafRenderSink extends Sink {
  ThymeLeafRenderSink() {
    exists(MethodAccess ma |
      this.asExpr() = ma.getArgument(0) and
      ma.getMethod() instanceof MethodThymeleafProcess
    )
  }
}

/**
 * Tainted data flowing into a Velocity Context through `put` method taints the context.
 */
private class VelocityContextFlow extends AdditionalFlowStep {
  override predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(MethodAccess m | m.getMethod() instanceof MethodVelocityContextPut |
      m.getArgument(1) = prev.asExpr() and
      succ.asExpr() = m.getQualifier()
    )
  }
}

/**
 * An argument to Velocity template engine's `mergeTemplate` method call.
 */
private class VelocityMergeTempSink extends Sink {
  VelocityMergeTempSink() {
    exists(MethodAccess m |
      // static boolean	mergeTemplate(String templateName, String encoding, Context context, Writer writer)
      m.getCallee() instanceof MethodVelocityMergeTemplate and
      m.getArgument(2) = this.getExpr()
    )
  }
}

/**
 * An argument to Velocity template engine's `mergeTemplate` method call.
 */
private class VelocityMergeSink extends Sink {
  VelocityMergeSink() {
    exists(MethodAccess m |
      m.getCallee() instanceof MethodVelocityMerge and
      // public void merge(Context context, Writer writer)
      // public void merge(Context context, Writer writer, List<String> macroLibraries)
      m.getArgument(0) = this.getExpr()
    )
  }
}

/**
 * An argument to Velocity template engine's `evaluate` method call.
 */
private class VelocityEvaluateSink extends Sink {
  VelocityEvaluateSink() {
    exists(MethodAccess m |
      m.getCallee() instanceof MethodVelocityEvaluate and
      m.getArgument([0, 3]) = this.getExpr()
    )
  }
}

/**
 * An argument to Velocity template engine's `parse` method call.
 */
private class VelocityParseSink extends Sink {
  VelocityParseSink() {
    exists(MethodAccess ma |
      this.asExpr() = ma.getArgument(0) and
      ma.getMethod() instanceof MethodVelocityParse
    )
  }
}

/**
 * An argument to Velocity template engine's `putStringResource` method call.
 */
private class VelocityPutStringResSink extends Sink {
  VelocityPutStringResSink() {
    exists(MethodAccess ma |
      this.asExpr() = ma.getArgument(1) and
      ma.getMethod() instanceof MethodVelocityPutStringResource
    )
  }
}
