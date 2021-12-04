/**
 * Provides classes for SQL injection detection regarding MyBatis annotated methods.
 */

import java
import MyBatisCommonLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Properties

/** An argument of a MyBatis annotated method. */
class MyBatisAnnotatedMethodCallArgument extends DataFlow::Node {
  MyBatisAnnotatedMethodCallArgument() {
    exists(MyBatisSqlOperationAnnotationMethod msoam, MethodAccess ma | ma.getMethod() = msoam |
      ma.getAnArgument() = this.asExpr()
    )
  }
}
