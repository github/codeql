/** Definitions used by the queries for mybatis mapper.xml query injection. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.DataFlow3
import DataFlow::PathGraph
import MybatisMapper

/** estimate if there are SqlInjection vulnerability in sql string, in another way find the ${param} */
predicate hasSqlInjection(MapperXMLFile xmlFile, Mapper mapper, SqlStatement sql, string sqlString) {
  sql.getFile() = xmlFile and
  mapper.getFile() = xmlFile and
  sqlString = getSqlString(sql) and
  sqlString.regexpMatch(".*\\$\\{.*\\}.*") 
}

/** find the sql ineject point that is param int ${param} or ${ param } */
bindingset[sqlString]
private string getInjectPointParam(string sqlString){
  exists(string param| param = sqlString.regexpFind("\\$\\{[^,}]+", _, _) | result = param.substring(2, param.length()).trim())
}

/** get the total sql string include two section,One is string of include label <sql>, two is all tag include sqlString, two section consist the total sqlString, if there are comment in the sql, might led to incorrect result. */
private string getSqlString(SqlStatement sql) {
  result = (concat(any(string includeSqlString|
                        exists(Sql sqlElement, MybatisInclude include |
                          include = sql.getAChild()
                          and include.getRefId().getValue() = sqlElement.getId().getValue()
                          and includeSqlString = sqlElement.getACharactersSet().toString().trim()
                        )
                      )
                    , " "
                  )
              + " "
              + concat(sql.getAChild*().getACharactersSet().toString().trim(), " ")
            )
            // .regexpReplaceAll("--.*?\\n", " ")
            .regexpReplaceAll("\\n", " ")
            .regexpReplaceAll("\\r", " ")
            .regexpReplaceAll("\\t", " ")
            // .regexpReplaceAll("/\\*.*\\*/", " ")
}

/** A sink for Java Mybatis XML Query Language injection vulnerabilities. */
predicate unsafeMybatisQuery(MethodAccess ma, int index) {
  exists(MapperXMLFile xmlFile, Mapper mapper, SqlStatement sql, string sqlString, Method m|
    hasSqlInjection(xmlFile, mapper, sql, sqlString) and
    m = ma.getMethod() and
    m.hasName(sql.getId().getValue()) and
    m.getDeclaringType()
      .hasQualifiedName(mapper.getnamespace().getValue().regexpCapture("(.*)+\\.(.*)+", 1),
        mapper.getnamespace().getValue().regexpCapture("(.*)+\\.(.*)+", 2))
    and m.getParameter(index).toString() = getInjectPointParam(sqlString) 
  )
}

class MapperSinkCall extends Call {
  MapperSinkCall() { getQualifier().getType() instanceof MybatisInterface }
}

class MybatisInterface extends Interface {
  MybatisInterface() { getAnAnnotation() instanceof MapperAnnotation }
}

class MapperAnnotation extends Annotation {
  MapperAnnotation() {
    getType().getAnAncestor().hasQualifiedName("org.apache.ibatis.annotations", "Mapper")
  }
}

/** The class `java.util.Date`. */
class DateType extends RefType {
  DateType() { this.hasQualifiedName("java.util", "Date") }
}

class MybatisQueryInjectionFlowConfig extends TaintTracking::Configuration {
  MybatisQueryInjectionFlowConfig() { this = "MybatisQueryInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Call call |
      call.getCallee() = ma.getMethod()
      and exists(int index |
        call.getArgument(index) = sink.asExpr()
        and unsafeMybatisQuery(ma, index)
      )
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType or
    node.getType() instanceof DateType or
    exists(ParameterizedType pt, RefType type|
            node.getType() = pt and pt.getTypeArgument(0) = type and 
            ( 
              type instanceof BoxedType or
              type instanceof NumberType or
              type instanceof DateType
            )
          )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      node1.asExpr() = ma.getArgument(0) and
      node2.asExpr() = ma
    )
  }
  
  /** get SqlStatement in MybatisXml file, eg <select>/<update> */
  SqlStatement getSql(DataFlow::Node sink, SqlStatement sql) {
    exists(MethodAccess ma, Call call, Mapper mapper|
      call.getCallee() = ma.getMethod() and
      call.getAnArgument() = sink.asExpr() and
      mapper.getAChild() = sql and
      ma.getMethod().hasName(sql.getId().getValue()) and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName(mapper.getnamespace().getValue().regexpCapture("(.*)+\\.(.*)+", 1),
            mapper.getnamespace().getValue().regexpCapture("(.*)+\\.(.*)+", 2))
    )
    and result = sql
  }
}
