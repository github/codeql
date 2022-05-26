/** Provides classes to reason about Groovy code injection attacks. */

private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.frameworks.Networking

/** A data flow sink for Groovy expression injection vulnerabilities. */
abstract class GroovyInjectionSink extends DataFlow::ExprNode { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `GroovyInjectionConfig`.
 */
class GroovyInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `GroovyInjectionConfig` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

private class DefaultGroovyInjectionSink extends GroovyInjectionSink {
  DefaultGroovyInjectionSink() { sinkNode(this, "groovy") }
}

private class DefaultGroovyInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // Signatures are specified to exclude sinks of the type `File`
        "groovy.lang;GroovyShell;false;evaluate;(GroovyCodeSource);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(Reader);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(Reader,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(String,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(String,String,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(URI);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(Reader);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(Reader,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(String,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(URI);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,String[]);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,List);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(Reader,String,String[]);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(Reader,String,List);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(String,String,String[]);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(String,String,List);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(URI,String[]);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(URI,List);;Argument[0];groovy",
        "groovy.util;Eval;false;me;(String);;Argument[0];groovy",
        "groovy.util;Eval;false;me;(String,Object,String);;Argument[2];groovy",
        "groovy.util;Eval;false;x;(Object,String);;Argument[1];groovy",
        "groovy.util;Eval;false;xy;(Object,Object,String);;Argument[2];groovy",
        "groovy.util;Eval;false;xyz;(Object,Object,Object,String);;Argument[3];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(GroovyCodeSource);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(GroovyCodeSource,boolean);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(InputStream,String);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(Reader,String);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(String);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(String,String);;Argument[0];groovy",
        "org.codehaus.groovy.control;CompilationUnit;false;compile;;;Argument[-1];groovy"
      ]
  }
}

/** A set of additional taint steps to consider when taint tracking Groovy related data flows. */
private class DefaultGroovyInjectionAdditionalTaintStep extends GroovyInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    groovyCodeSourceTaintStep(node1, node2) or
    groovyCompilationUnitTaintStep(node1, node2) or
    groovySourceUnitTaintStep(node1, node2) or
    groovyReaderSourceTaintStep(node1, node2)
  }
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step from a tainted string to
 * a `GroovyCodeSource` instance by calling `new GroovyCodeSource(tainted, ...)`.
 */
private predicate groovyCodeSourceTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(ConstructorCall gcscc |
    gcscc.getConstructedType() instanceof TypeGroovyCodeSource and
    gcscc = toNode.asExpr() and
    gcscc.getArgument(0) = fromNode.asExpr()
  )
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step from a tainted object to
 * a `CompilationUnit` instance by calling `compilationUnit.addSource(..., tainted)`.
 */
private predicate groovyCompilationUnitTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m |
    ma.getMethod() = m and
    m.hasName("addSource") and
    m.getDeclaringType() instanceof TypeGroovyCompilationUnit
  |
    fromNode.asExpr() = ma.getArgument(ma.getNumArgument() - 1) and
    toNode.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = ma.getQualifier()
  )
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step from a tainted object to
 * a `SourceUnit` instance by calling `new SourceUnit(..., tainted, ...)`
 * or `SourceUnit.create(..., tainted)`
 */
private predicate groovySourceUnitTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(ClassInstanceExpr cie, Argument arg, int index |
    cie.getConstructedType() instanceof TypeGroovySourceUnit and
    arg = cie.getArgument(index) and
    (
      index = 0 and arg.getType() instanceof TypeUrl
      or
      index = 1 and
      (
        arg.getType() instanceof TypeString or
        arg.getType() instanceof TypeReaderSource
      )
    )
  |
    fromNode.asExpr() = arg and
    toNode.asExpr() = cie
  )
  or
  exists(MethodAccess ma, Method m |
    ma.getMethod() = m and
    m.hasName("create") and
    m.getDeclaringType() instanceof TypeGroovySourceUnit
  |
    fromNode.asExpr() = ma.getArgument(1) and toNode.asExpr() = ma
  )
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step from a tainted object to
 * a `ReaderSource` instance by calling `new ReaderSource(tainted, ...)`.
 */
private predicate groovyReaderSourceTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(ClassInstanceExpr cie | cie.getConstructedType() instanceof TypeReaderSource |
    fromNode.asExpr() = cie.getArgument(0) and toNode.asExpr() = cie
  )
}

/** The class `groovy.lang.GroovyCodeSource`. */
private class TypeGroovyCodeSource extends RefType {
  TypeGroovyCodeSource() { this.hasQualifiedName("groovy.lang", "GroovyCodeSource") }
}

/** The class `org.codehaus.groovy.control.CompilationUnit`. */
private class TypeGroovyCompilationUnit extends RefType {
  TypeGroovyCompilationUnit() {
    this.hasQualifiedName("org.codehaus.groovy.control", "CompilationUnit")
  }
}

/** The class `org.codehaus.groovy.control.CompilationUnit`. */
private class TypeGroovySourceUnit extends RefType {
  TypeGroovySourceUnit() { this.hasQualifiedName("org.codehaus.groovy.control", "SourceUnit") }
}

/** The class `org.codehaus.groovy.control.io.ReaderSource`. */
private class TypeReaderSource extends RefType {
  TypeReaderSource() {
    this.getAnAncestor().hasQualifiedName("org.codehaus.groovy.control.io", "ReaderSource")
  }
}
