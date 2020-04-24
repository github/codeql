import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import experimental.semmle.code.java.frameworks.FreeMarker
import experimental.semmle.code.java.frameworks.Velocity
import experimental.semmle.code.java.frameworks.Jinjava
import experimental.semmle.code.java.frameworks.Pebble
import experimental.semmle.code.java.frameworks.Thymeleaf

module TemplateInjection {
  class TemplateInjectionFlowConfig extends TaintTracking::Configuration {
    // import TemplateInjectionCustomizations::TemplateInjection;
    TemplateInjectionFlowConfig() { this = "TemplateInjectionFlowConfig" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
    }

    override predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ) {
      exists(AdditionalFlowStep a | a.isAdditionalTaintStep(prev, succ))
    }
  }

  class Source extends DataFlow::Node {
    Source() { this instanceof RemoteFlowSource or this instanceof LocalUserInput }
  }

  /**
   * A data flow sink for `Configuration`.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  abstract class AdditionalFlowStep extends string {
    bindingset[this]
    AdditionalFlowStep() { any() }

    abstract predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ);
  }

  /**
   * Tainted data flowing into a Velocity Context through `put` method taints the context.
   */
  class VelocityContextFlow extends AdditionalFlowStep {
    VelocityContextFlow() { this = "Velocity Context Flow" }

    override predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ) {
      exists(MethodAccess m | m.getMethod() instanceof MethodVelocityContextPut |
        m.getArgument(1) = prev.asExpr() and
        (succ.asExpr() = m or succ.asExpr() = m.getQualifier())
      )
    }
  }

  /**
   * An argument to FreeMarker template engine's `process` method call is a sink for `Configuration`.
   */
  class FreeMarkerProcessSink extends Sink {
    FreeMarkerProcessSink() {
      exists(MethodAccess m |
        m.getCallee() instanceof MethodFreeMarkerTemplateProcess and
        m.getArgument(0) = this.getExpr()
      )
    }
  }

  /**
   * An reader passed an argument to FreeMarker template engine's `Template`
   *   construtor call is a sink for `Configuration`.
   */
  class FreeMarkerConstructorSink extends Sink {
    FreeMarkerConstructorSink() {
      // Template(java.lang.String name, java.io.Reader reader)
      // Template(java.lang.String name, java.io.Reader reader, Configuration cfg)
      // Template(java.lang.String name, java.io.Reader reader, Configuration cfg, java.lang.String encoding)
      // Template(java.lang.String name, java.lang.String sourceCode, Configuration cfg)
      // Template(java.lang.String name, java.lang.String sourceName, java.io.Reader reader, Configuration cfg)
      // Template(java.lang.String name, java.lang.String sourceName, java.io.Reader reader, Configuration cfg, ParserConfiguration customParserConfiguration, java.lang.String encoding)
      // Template(java.lang.String name, java.lang.String sourceName, java.io.Reader reader, Configuration cfg, java.lang.String encoding)
      exists(ConstructorCall cc |
        cc.getConstructor().getDeclaringType() instanceof TypeFreeMarkerTemplate and
        exists(Expr e |
          e = cc.getAnArgument() and
          e.getType().(RefType).hasQualifiedName("java.io", "Reader") and
          this.asExpr() = e
        )
      )
    }
  }

  /**
   * An argument to FreeMarker template engine's `putTemplate` method call is a sink for `Configuration`.
   */
  class FreeMarkerStringTemplateLoaderPutTemplateSink extends Sink {
    FreeMarkerStringTemplateLoaderPutTemplateSink() {
      exists(MethodAccess ma |
        this.asExpr() = ma.getArgument(1) and
        ma.getMethod() instanceof MethodFreeMarkerStringTemplateLoaderPutTemplate
      )
    }
  }

  /**
   * An argument to Velocity template engine's `mergeTemplate` method call is a sink for `Configuration`.
   */
  class VelocityMergeTempSink extends Sink {
    VelocityMergeTempSink() {
      exists(MethodAccess m |
        // static boolean	mergeTemplate(String templateName, String encoding, Context context, Writer writer)
        m.getCallee() instanceof MethodVelocityMergeTemplate and
        m.getArgument(2) = this.getExpr()
      )
    }
  }

  /**
   * An argument to Velocity template engine's `evaluate` method call is a sink for `Configuration`.
   */
  class VelocityEvaluateSink extends Sink {
    VelocityEvaluateSink() {
      exists(MethodAccess m |
        m.getCallee() instanceof MethodVelocityEvaluate and
        m.getArgument([0, 3]) = this.getExpr()
      )
    }
  }

  /**
   * An argument to Velocity template engine's `evaluate` method call is a sink for `Configuration`.
   */
  class VelocityEvaluateSink extends Sink {
    VelocityEvaluateSink() {
      exists(MethodAccess m |
        m.getCallee() instanceof MethodVelocityEvaluate and
        m.getArgument([0, 3]) = this.getExpr()
      )
    }
  }
}
