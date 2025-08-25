/**
 * Provides classes for SQL injection detection regarding MyBatis annotated methods.
 */
deprecated module;

import java
import MyBatisCommonLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Properties

/** An argument of a MyBatis annotated method. */
class MyBatisAnnotatedMethodCallArgument extends DataFlow::Node {
  MyBatisAnnotatedMethodCallArgument() {
    exists(MyBatisSqlOperationAnnotationMethod msoam, MethodCall ma | ma.getMethod() = msoam |
      ma.getAnArgument() = this.asExpr()
    )
  }
}
