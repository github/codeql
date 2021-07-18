import java
import semmle.code.xml.MyBatisMapperXML
import semmle.code.java.dataflow.FlowSources

/** A sink for MyBatis Mapper XML file sql injection vulnerabilities. */
class MyBatisMapperXmlSqlInjectionSink extends DataFlow::Node {
  MyBatisMapperXmlSqlInjectionSink() {
    exists(MyBatisMapperSqlOperation mbmxe, MethodAccess ma |
      mbmxe.getAChild*().getTextValue().trim().matches("%${%") and
      mbmxe.getId() = ma.getMethod().getName() and
      ma.getMethod().getDeclaringType() =
        mbmxe.getParent().(MyBatisMapperXMLElement).getNamespaceRefType() and
      ma.getAnArgument() = this.asExpr()
    )
    or
    exists(MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess ma |
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*().getTextValue().trim().matches("%${%") and
      mbmxe.getId() = ma.getMethod().getName() and
      ma.getMethod().getDeclaringType() =
        mbmxe.getParent().(MyBatisMapperXMLElement).getNamespaceRefType() and
      ma.getAnArgument() = this.asExpr()
    )
  }
}
