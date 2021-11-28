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
  result = xmle.getTextValue().trim().regexpFind("(#|\\$)(\\{([^\\}]*\\}))", _, _)
}

predicate isMapperXmlSqlInjection(DataFlow::Node node, XMLElement xmle) {
  // MyBatis Mapper method Param Annotation sql injection vulnerabilities.
  // e.g. MyBatis Mapper method: `void test(@Param("orderby") String name);` and MyBatis Mapper XML file:`select id,name from test order by ${orderby,jdbcType=VARCHAR}`
  exists(
    MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, int i,
    Annotation annotation
  |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    mc.getMethod().getParameter(i).hasAnnotation() and
    mc.getMethod().getParameter(i).getAnAnnotation() = annotation and
    annotation.getType() instanceof TypeParam and
    getAnMybatiXmlSetValue(xmle)
        .matches("%${" + annotation.getValue("value").(CompileTimeConstantExpr).getStringValue() +
            "%}") and
    mc.getArgument(i) = node.asExpr()
  )
  or
  // MyBatis Mapper method Class Field sql injection vulnerabilities.
  // e.g. MyBatis Mapper method: `void test(Test test);` and MyBatis Mapper XML file:`select id,name from test order by ${name,jdbcType=VARCHAR}`
  exists(MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, int i, Class c |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    not mc.getMethod().getParameter(i).hasAnnotation() and
    mc.getMethod().getParameterType(i).getName() = c.getName() and
    getAnMybatiXmlSetValue(xmle).matches("%${" + c.getAField().getName() + "%}") and
    mc.getArgument(i) = node.asExpr()
  )
  or
  // The parameter type of MyBatis Mapper method is Map or List or Array, which may cause SQL injection vulnerability.
  // e.g. MyBatis Mapper method: `void test(Map<String, String> params);` and MyBatis Mapper XML file:`select id,name from test where name like '%${name}%'`
  exists(
    MyBatisMapperSqlOperation mbmxe, MyBatisMapperForeach mbmf, MyBatisMapperSql mbms,
    MethodAccess mc, int i, string res
  |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    mbmf = xmle and
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    not mc.getMethod().getParameter(i).hasAnnotation() and
    (
      mc.getMethod().getParameterType(i) instanceof MapType or
      mc.getMethod().getParameterType(i) instanceof ListType or
      mc.getMethod().getParameterType(i) instanceof Array
    ) and
    res = getAnMybatiXmlSetValue(xmle) and
    res.matches("%${%}") and
    not res.matches("${" + getAnMybatisConfigurationVariableKey() + "}") and
    mc.getArgument(i) = node.asExpr()
  )
  or
  // SQL injection vulnerability where the MyBatis Mapper method has only one parameter and the parameter is not annotated with `@Param`.
  // e.g. MyBatis Mapper method: `void test(String name);` and MyBatis Mapper XML file:`select id,name from test where name like '%${value}%'`
  exists(MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, string res |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    res = getAnMybatiXmlSetValue(xmle) and
    mc.getMethod().getNumberOfParameters() = 1 and
    not mc.getMethod().getAParameter().hasAnnotation() and
    res.matches("%${%}") and
    not res.matches("${" + getAnMybatisConfigurationVariableKey() + "}") and
    mc.getAnArgument() = node.asExpr()
  )
  or
  // MyBatis Mapper method default parameter sql injection vulnerabilities.the default parameter form of the method is arg[0...n] or param[1...n].
  // e.g. MyBatis Mapper method: `void test(String name);` and MyBatis Mapper XML file:`select id,name from test where name like '%${arg0 or param1}%'`
  exists(
    MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, int i, string res
  |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    not mc.getMethod().getParameter(i).hasAnnotation() and
    res = getAnMybatiXmlSetValue(xmle) and
    (
      res.matches("%${param" + (i + 1) + "%}")
      or
      res.matches("%${arg" + i + "%}")
    ) and
    mc.getArgument(i) = node.asExpr()
  )
}
