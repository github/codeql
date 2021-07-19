/** Provides classes to reason about MVEL injection attacks. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/** A data flow sink for unvalidated user input that is used to construct MVEL expressions. */
abstract class MvelEvaluationSink extends DataFlow::Node { }

/** A sanitizer that prevents MVEL injection attacks. */
abstract class MvelInjectionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `MvelInjectionFlowConfig`.
 */
class MvelInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `MvelInjectionFlowConfig` configuration.
   */
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

/** Default sink for MVEL injection vulnerabilities. */
private class DefaultMvelEvaluationSink extends MvelEvaluationSink {
  DefaultMvelEvaluationSink() { sinkNode(this, "mvel") }
}

/** A default sanitizer that considers numeric and boolean typed data safe for building MVEL expressions */
private class DefaultMvelInjectionSanitizer extends MvelInjectionSanitizer {
  DefaultMvelInjectionSanitizer() {
    this.getType() instanceof NumericType or this.getType() instanceof BooleanType
  }
}

/** A set of additional taint steps to consider when taint tracking MVEL related data flows. */
private class DefaultMvelInjectionAdditionalTaintStep extends MvelInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    expressionCompilationStep(node1, node2) or
    createExpressionCompilerStep(node1, node2) or
    expressionCompilerCompileStep(node1, node2) or
    createCompiledAccExpressionStep(node1, node2) or
    scriptCompileStep(node1, node2) or
    createMvelCompiledScriptStep(node1, node2) or
    templateCompileStep(node1, node2) or
    createTemplateCompilerStep(node1, node2)
  }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a MVEL expression.
 */
class MvelInjectionFlowConfig extends TaintTracking::Configuration {
  MvelInjectionFlowConfig() { this = "MvelInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof MvelEvaluationSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof MvelInjectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(MvelInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

/**
 * Holds if `node1` to `node2` is a dataflow step that compiles a MVEL expression
 * by callilng `MVEL.compileExpression(tainted)`.
 */
private predicate expressionCompilationStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(StaticMethodAccess ma, Method m | ma.getMethod() = m |
    m.getDeclaringType() instanceof MVEL and
    m.hasName("compileExpression") and
    ma.getAnArgument() = node1.asExpr() and
    node2.asExpr() = ma
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that creates `ExpressionCompiler`
 * by calling `new ExpressionCompiler(tainted)`.
 */
private predicate createExpressionCompilerStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof ExpressionCompiler and
    cc = node2.asExpr() and
    cc.getArgument(0) = node1.asExpr()
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step creates `CompiledAccExpression`
 * by calling `new CompiledAccExpression(tainted, ...)`.
 */
private predicate createCompiledAccExpressionStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof CompiledAccExpression and
    cc = node2.asExpr() and
    cc.getArgument(0) = node1.asExpr()
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that compiles a MVEL expression
 * by calling `ExpressionCompiler.compile()`.
 */
private predicate expressionCompilerCompileStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m.getDeclaringType() instanceof ExpressionCompiler and
    m.hasName("compile") and
    ma = node2.asExpr() and
    ma.getQualifier() = node1.asExpr()
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that compiles a script via `MvelScriptEngine`
 * by calling `engine.compile(tainted)` or `engine.compiledScript(tainted)`.
 */
private predicate scriptCompileStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m instanceof MvelScriptEngineCompilationMethod and
    ma = node2.asExpr() and
    ma.getArgument(0) = node1.asExpr()
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that creates `MvelCompiledScript`
 * by calling `new MvelCompiledScript(engine, tainted)`.
 */
private predicate createMvelCompiledScriptStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof MvelCompiledScript and
    cc = node2.asExpr() and
    cc.getArgument(1) = node1.asExpr()
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step creates `TemplateCompiler`
 * by calling `new TemplateCompiler(tainted)`.
 */
private predicate createTemplateCompilerStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof TemplateCompiler and
    cc = node2.asExpr() and
    cc.getArgument(0) = node1.asExpr()
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that compiles a script via `TemplateCompiler`
 * by calling `compiler.compile()` or `TemplateCompiler.compileTemplate(tainted)`.
 */
private predicate templateCompileStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m instanceof TemplateCompilerCompileMethod and
    ma.getQualifier() = node1.asExpr() and
    ma = node2.asExpr()
  )
  or
  exists(StaticMethodAccess ma, Method m | ma.getMethod() = m |
    m instanceof TemplateCompilerCompileTemplateMethod and
    ma = node2.asExpr() and
    ma.getArgument(0) = node1.asExpr()
  )
}

/**
 * Methods in `MvelScriptEngine` that compile a MVEL expression.
 */
private class MvelScriptEngineCompilationMethod extends Method {
  MvelScriptEngineCompilationMethod() {
    getDeclaringType() instanceof MvelScriptEngine and
    (hasName("compile") or hasName("compiledScript"))
  }
}

/**
 * `TemplateCompiler.compile()` method that compiles a MVEL template.
 */
private class TemplateCompilerCompileMethod extends Method {
  TemplateCompilerCompileMethod() {
    getDeclaringType() instanceof TemplateCompiler and
    hasName("compile")
  }
}

/**
 * `TemplateCompiler.compileTemplate(tainted)` static method that compiles a MVEL template.
 */
private class TemplateCompilerCompileTemplateMethod extends Method {
  TemplateCompilerCompileTemplateMethod() {
    getDeclaringType() instanceof TemplateCompiler and
    hasName("compileTemplate")
  }
}

private class MVEL extends RefType {
  MVEL() { hasQualifiedName("org.mvel2", "MVEL") }
}

private class ExpressionCompiler extends RefType {
  ExpressionCompiler() { hasQualifiedName("org.mvel2.compiler", "ExpressionCompiler") }
}

private class CompiledAccExpression extends RefType {
  CompiledAccExpression() { hasQualifiedName("org.mvel2.compiler", "CompiledAccExpression") }
}

private class MvelScriptEngine extends RefType {
  MvelScriptEngine() { hasQualifiedName("org.mvel2.jsr223", "MvelScriptEngine") }
}

private class MvelCompiledScript extends RefType {
  MvelCompiledScript() { hasQualifiedName("org.mvel2.jsr223", "MvelCompiledScript") }
}

private class TemplateCompiler extends RefType {
  TemplateCompiler() { hasQualifiedName("org.mvel2.templates", "TemplateCompiler") }
}
