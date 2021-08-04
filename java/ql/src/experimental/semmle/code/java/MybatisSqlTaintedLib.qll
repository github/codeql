/** Definitions used by the queries for mybatis mapper.xml query injection. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.DataFlow3
import DataFlow::PathGraph
import experimental.semmle.code.xml.MybatisMapper

predicate hasSqlInjection(MapperXMLFile xmlFile, Mapper mapper, SqlStatement sql, string sqlString) {
  sql.getFile() = xmlFile and
  mapper.getFile() = xmlFile and
  sqlString =
    sql.getTextValue()
        .regexpReplaceAll("\\\n", " ")
        .regexpReplaceAll("\\\r", " ")
        .regexpReplaceAll("\\\t", " ") and
  sqlString.regexpMatch(".*\\$\\{.*\\}.*") 
}

bindingset[sqlString]
private string getInjectPointParam(string sqlString){
  exists(string param| param = sqlString.regexpFind("\\$\\{[^,}]+", _, _) | result = param.substring(2, param.length()))
}

/** A sink for Java Mybatis XML Query Language injection vulnerabilities. */
predicate unsafeMybatisQuery(MethodAccess ma, DataFlow::Node sink) {
  exists(MapperXMLFile xmlFile, Mapper mapper, SqlStatement sql, string sqlString |
    hasSqlInjection(xmlFile, mapper, sql, sqlString) and
    ma.getMethod().hasName(sql.getId().getValue()) and
    ma.getMethod()
        .getDeclaringType()
        .hasQualifiedName(mapper.getnamespace().getValue().regexpCapture("(.*)+\\.(.*)+", 1),
          mapper.getnamespace().getValue().regexpCapture("(.*)+\\.(.*)+", 2))
    and sink.asExpr().toString() = getInjectPointParam(sqlString)
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

class MybatisQueryInjectionFlowConfig extends TaintTracking::Configuration {
  MybatisQueryInjectionFlowConfig() { this = "MybatisQueryInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, MapperSinkCall call |
      unsafeMybatisQuery(ma, sink) and
      call.getCallee() = ma.getMethod() and
      call.getAnArgument() = sink.asExpr()
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      node1.asExpr() = ma.getArgument(0) and
      node2.asExpr() = ma
    )
  }
}