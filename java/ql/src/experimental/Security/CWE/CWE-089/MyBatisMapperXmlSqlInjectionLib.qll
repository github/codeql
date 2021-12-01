/**
 * Provide classes for SQL injection detection in MyBatis Mapper XML.
 */

import java
import MyBatisCommonLib
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

/** Get the #{...} or ${...} parameters in the Mybatis mapper xml file */
private string getAnMybatiXmlSetValue(XMLElement xmle) {
  result = xmle.getTextValue().trim().regexpFind("(#|\\$)\\{[^\\}]*\\}", _, _)
}

predicate isMapperXmlSqlInjection(DataFlow::Node node, XMLElement xmle) {
  // MyBatis Mapper method Param Annotation sql injection vulnerabilities.
  // e.g. MyBatis Mapper method: `void test(@Param("orderby") String name);` and MyBatis Mapper XML file:`select id,name from test order by ${orderby,jdbcType=VARCHAR}`
  exists(MyBatisMapperSqlOperation mbmxe, MethodAccess ma, int i, Annotation annotation |
    mbmxe.getMapperMethod() = ma.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      exists(MyBatisMapperSql mbms |
        mbmxe.getInclude().getRefid() = mbms.getId() and
        mbms.getAChild*() = xmle
      )
    ) and
    ma.getMethod().getParameter(i).getAnAnnotation() = annotation and
    annotation.getType() instanceof TypeParam and
    getAnMybatiXmlSetValue(xmle)
        .matches("%${" + annotation.getValue("value").(CompileTimeConstantExpr).getStringValue() +
            "%}") and
    ma.getArgument(i) = node.asExpr()
  )
  or
  // MyBatis Mapper method Class Field sql injection vulnerabilities.
  // e.g. MyBatis Mapper method: `void test(Test test);` and MyBatis Mapper XML file:`select id,name from test order by ${name,jdbcType=VARCHAR}`
  exists(MyBatisMapperSqlOperation mbmxe, MethodAccess ma, int i, RefType t |
    mbmxe.getMapperMethod() = ma.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      exists(MyBatisMapperSql mbms |
        mbmxe.getInclude().getRefid() = mbms.getId() and
        mbms.getAChild*() = xmle
      )
    ) and
    not ma.getMethod().getParameter(i).getAnAnnotation().getType() instanceof TypeParam and
    ma.getMethod().getParameterType(i).getName() = t.getName() and
    getAnMybatiXmlSetValue(xmle).matches("%${" + t.getAField().getName() + "%}") and
    ma.getArgument(i) = node.asExpr()
  )
  or
  // The parameter type of MyBatis Mapper method is Map or List or Array, which may cause SQL injection vulnerability.
  // e.g. MyBatis Mapper method: `void test(Map<String, String> params);` and MyBatis Mapper XML file:`select id,name from test where name like '%${name}%'`
  exists(
    MyBatisMapperSqlOperation mbmxe, MyBatisMapperForeach mbmf, MethodAccess ma, int i, string res
  |
    mbmxe.getMapperMethod() = ma.getMethod()
  |
    mbmf = xmle and
    (
      mbmxe.getAChild*() = xmle
      or
      exists(MyBatisMapperSql mbms |
        mbmxe.getInclude().getRefid() = mbms.getId() and
        mbms.getAChild*() = xmle
      )
    ) and
    not ma.getMethod().getParameter(i).getAnAnnotation().getType() instanceof TypeParam and
    (
      ma.getMethod().getParameterType(i) instanceof MapType or
      ma.getMethod().getParameterType(i) instanceof ListType or
      ma.getMethod().getParameterType(i) instanceof Array
    ) and
    res = getAnMybatiXmlSetValue(xmle) and
    res.matches("%${%}") and
    not res = "${" + getAnMybatisConfigurationVariableKey() + "}" and
    ma.getArgument(i) = node.asExpr()
  )
  or
  // SQL injection vulnerability where the MyBatis Mapper method has only one parameter and the parameter is not annotated with `@Param`.
  // e.g. MyBatis Mapper method: `void test(String name);` and MyBatis Mapper XML file:`select id,name from test where name like '%${value}%'`
  exists(MyBatisMapperSqlOperation mbmxe, MethodAccess ma, string res |
    mbmxe.getMapperMethod() = ma.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      exists(MyBatisMapperSql mbms |
        mbmxe.getInclude().getRefid() = mbms.getId() and
        mbms.getAChild*() = xmle
      )
    ) and
    res = getAnMybatiXmlSetValue(xmle) and
    ma.getMethod().getNumberOfParameters() = 1 and
    not ma.getMethod().getAParameter().getAnAnnotation().getType() instanceof TypeParam and
    res.matches("%${%}") and
    not res = "${" + getAnMybatisConfigurationVariableKey() + "}" and
    ma.getAnArgument() = node.asExpr()
  )
  or
  // MyBatis Mapper method default parameter sql injection vulnerabilities.the default parameter form of the method is arg[0...n] or param[1...n].
  // e.g. MyBatis Mapper method: `void test(String name);` and MyBatis Mapper XML file:`select id,name from test where name like '%${arg0 or param1}%'`
  exists(MyBatisMapperSqlOperation mbmxe, MethodAccess ma, int i, string res |
    mbmxe.getMapperMethod() = ma.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      exists(MyBatisMapperSql mbms |
        mbmxe.getInclude().getRefid() = mbms.getId() and
        mbms.getAChild*() = xmle
      )
    ) and
    not ma.getMethod().getParameter(i).getAnAnnotation().getType() instanceof TypeParam and
    res = getAnMybatiXmlSetValue(xmle) and
    (
      res.matches("%${param" + (i + 1) + "%}")
      or
      res.matches("%${arg" + i + "%}")
    ) and
    not res = "${" + getAnMybatisConfigurationVariableKey() + "}" and
    ma.getArgument(i) = node.asExpr()
  )
}
