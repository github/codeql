import java
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.frameworks.android.Android
private import semmle.code.java.frameworks.android.Fragment
private import semmle.code.java.Reflection

/**
 * A sink for Fragment injection vulnerabilities,
 * that is, method calls that dynamically add Fragments to Activities.
 */
abstract class FragmentInjectionSink extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to `FragmentInjectionTaintConf`.
 */
class FragmentInjectionAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

private class FragmentInjectionSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      ["android.app", "android.support.v4.app", "androidx.fragment.app"] +
        ";FragmentTransaction;true;" +
        [
          "add;(Class,Bundle,String);;Argument[0]", "add;(Fragment,String);;Argument[0]",
          "add;(int,Class,Bundle);;Argument[1]", "add;(int,Fragment);;Argument[1]",
          "add;(int,Class,Bundle,String);;Argument[1]", "add;(int,Fragment,String);;Argument[1]",
          "attach;(Fragment);;Argument[0]", "replace;(int,Class,Bundle);;Argument[1]",
          "replace;(int,Fragment);;Argument[1]", "replace;(int,Class,Bundle,String);;Argument[1]",
          "replace;(int,Fragment,String);;Argument[1]",
        ] + ";fragment-injection"
  }
}

private class DefaultFragmentInjectionSink extends FragmentInjectionSink {
  DefaultFragmentInjectionSink() { sinkNode(this, "fragment-injection") }
}

private class DefaultFragmentInjectionAdditionalTaintStep extends FragmentInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(ReflectiveClassIdentifierMethodAccess ma |
      ma.getArgument(0) = n1.asExpr() and ma = n2.asExpr()
    )
    or
    exists(NewInstance ni |
      ni.getQualifier() = n1.asExpr() and
      ni = n2.asExpr()
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof FragmentInstantiateMethod and
      ma.getArgument(1) = n1.asExpr() and
      ma = n2.asExpr()
    )
  }
}
