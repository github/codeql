/**
 * Provide classes for SQL injection detection in MyBatis Mapper XML.
 */

import java
import semmle.code.xml.MyBatisMapperXML
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Properties

/** A sink for MyBatis Mapper method call an argument. */
class MyBatisMapperMethodCallAnArgument extends DataFlow::Node {
  MyBatisMapperMethodCallAnArgument() {
    exists(MyBatisMapperSqlOperation mbmxe, MethodAccess ma |
      mbmxe.getMapperMethod() = ma.getMethod()
    |
      ma.getAnArgument() = this.asExpr()
    )
  }
}
