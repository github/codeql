/**
 * Provides classes and predicates for Groovy Code Injection
 * taint-tracking configuration.
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/** A data flow sink for Groovy expression injection vulnerabilities. */
abstract private class GroovyInjectionSink extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to evaluate a Groovy expression.
 */
class GroovyInjectionConfig extends TaintTracking::Configuration {
  GroovyInjectionConfig() { this = "GroovyInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GroovyInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    groovyCodeSourceTaintStep(fromNode, toNode)
  }
}

/** The class `groovy.lang.GroovyShell`. */
private class TypeGroovyShell extends RefType {
  TypeGroovyShell() { this.hasQualifiedName("groovy.lang", "GroovyShell") }
}

/** The class `groovy.lang.GroovyCodeSource`. */
private class TypeGroovyCodeSource extends RefType {
  TypeGroovyCodeSource() { this.hasQualifiedName("groovy.lang", "GroovyCodeSource") }
}

/**
 * Methods in the `GroovyShell` class that evaluate a Groovy expression.
 */
private class GroovyShellMethod extends Method {
  GroovyShellMethod() {
    this.getDeclaringType() instanceof TypeGroovyShell and
    this.getName() in ["evaluate", "parse", "run"]
  }
}

private class GroovyShellMethodAccess extends MethodAccess {
  GroovyShellMethodAccess() { this.getMethod() instanceof GroovyShellMethod }
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step from a tainted string to
 * a `GroovyCodeSource` instance, i.e. `new GroovyCodeSource(tainted, ...)`.
 */
private predicate groovyCodeSourceTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(ConstructorCall gcscc |
    gcscc.getConstructedType() instanceof TypeGroovyCodeSource and
    gcscc = toNode.asExpr() and
    gcscc.getArgument(0) = fromNode.asExpr()
  )
}

/**
 * A sink for Groovy Injection via the `GroovyShell` class.
 *
 * ```
 * GroovyShell gs = new GroovyShell();
 * gs.evaluate(sink, ....)
 * gs.run(sink, ....)
 * gs.parse(sink,...)
 * ```
 */
private class GroovyShellSink extends GroovyInjectionSink {
  GroovyShellSink() {
    exists(GroovyShellMethodAccess ma, Argument firstArg |
      ma.getArgument(0) = firstArg and
      firstArg = this.asExpr() and
      (
        firstArg.getType() instanceof TypeString or
        firstArg.getType() instanceof TypeGroovyCodeSource
      )
    )
  }
}

/** The class `groovy.util.Eval`. */
private class TypeEval extends RefType {
  TypeEval() { this.hasQualifiedName("groovy.util", "Eval") }
}

/**
 * Methods in the `Eval` class that evaluate a Groovy expression.
 */
private class EvalMethod extends Method {
  EvalMethod() {
    this.getDeclaringType() instanceof TypeEval and
    this.getName() in ["me", "x", "xy", "xyz"]
  }
}

private class EvalMethodAccess extends MethodAccess {
  EvalMethodAccess() { this.getMethod() instanceof EvalMethod }

  Expr getArgumentExpr() { result = this.getArgument(this.getNumArgument() - 1) }
}

/**
 * A sink for Groovy Injection via the `Eval` class.
 *
 * ```
 * Eval.me(sink)
 * Eval.me("p1", "p2", sink)
 * Eval.x("p1", sink)
 * Eval.xy("p1", "p2" sink)
 * Eval.xyz("p1", "p2", "p3", sink)
 * ```
 */
private class EvalSink extends GroovyInjectionSink {
  EvalSink() { exists(EvalMethodAccess ma | ma.getArgumentExpr() = this.asExpr()) }
}

/** The class `groovy.lang.GroovyClassLoader`. */
private class TypeGroovyClassLoader extends RefType {
  TypeGroovyClassLoader() { this.hasQualifiedName("groovy.lang", "GroovyClassLoader") }
}

/**
 * A method in the `GroovyClassLoader` class that evaluates a Groovy expression.
 */
private class GroovyClassLoaderParseClassMethod extends Method {
  GroovyClassLoaderParseClassMethod() {
    this.getDeclaringType() instanceof TypeGroovyClassLoader and
    this.hasName("parseClass")
  }
}

private class GroovyClassLoaderParseClassMethodAccess extends MethodAccess {
  GroovyClassLoaderParseClassMethodAccess() {
    this.getMethod() instanceof GroovyClassLoaderParseClassMethod
  }
}

/**
 * A sink for Groovy Injection via the `GroovyClassLoader` class.
 *
 * ```
 * GroovyClassLoader classLoader = new GroovyClassLoader();
 * Class groovy = classLoader.parseClass(script);
 * ```
 *
 * Groovy supports compile-time metaprogramming, so just calling the `parseClass`
 * method is enough to achieve RCE.
 */
private class GroovyClassLoadParseClassSink extends GroovyInjectionSink {
  GroovyClassLoadParseClassSink() {
    exists(GroovyClassLoaderParseClassMethodAccess ma | ma.getArgument(0) = this.asExpr())
  }
}
