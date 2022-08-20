/**
 * Provides classes and predicates for working with the MyBatis framework.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow

/** The class `org.apache.ibatis.jdbc.SqlRunner`. */
class MyBatisSqlRunner extends RefType {
  MyBatisSqlRunner() { this.hasQualifiedName("org.apache.ibatis.jdbc", "SqlRunner") }
}

private class SqlSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "org.apache.ibatis.jdbc;SqlRunner;false;delete;(String,Object[]);;Argument[0];sql;manual",
        "org.apache.ibatis.jdbc;SqlRunner;false;insert;(String,Object[]);;Argument[0];sql;manual",
        "org.apache.ibatis.jdbc;SqlRunner;false;run;(String);;Argument[0];sql;manual",
        "org.apache.ibatis.jdbc;SqlRunner;false;selectAll;(String,Object[]);;Argument[0];sql;manual",
        "org.apache.ibatis.jdbc;SqlRunner;false;selectOne;(String,Object[]);;Argument[0];sql;manual",
        "org.apache.ibatis.jdbc;SqlRunner;false;update;(String,Object[]);;Argument[0];sql;manual"
      ]
  }
}

/** The class `org.apache.ibatis.session.Configuration`. */
class IbatisConfiguration extends RefType {
  IbatisConfiguration() { this.hasQualifiedName("org.apache.ibatis.session", "Configuration") }
}

/**
 * The method `getVariables()` declared in `org.apache.ibatis.session.Configuration`.
 */
class IbatisConfigurationGetVariablesMethod extends Method {
  IbatisConfigurationGetVariablesMethod() {
    this.getDeclaringType() instanceof IbatisConfiguration and
    this.hasName("getVariables") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * An annotation type that identifies Ibatis select.
 */
private class IbatisSelectAnnotationType extends AnnotationType {
  IbatisSelectAnnotationType() { this.hasQualifiedName("org.apache.ibatis.annotations", "Select") }
}

/**
 * An annotation type that identifies Ibatis delete.
 */
private class IbatisDeleteAnnotationType extends AnnotationType {
  IbatisDeleteAnnotationType() { this.hasQualifiedName("org.apache.ibatis.annotations", "Delete") }
}

/**
 * An annotation type that identifies Ibatis insert.
 */
private class IbatisInsertAnnotationType extends AnnotationType {
  IbatisInsertAnnotationType() { this.hasQualifiedName("org.apache.ibatis.annotations", "Insert") }
}

/**
 * An annotation type that identifies Ibatis update.
 */
private class IbatisUpdateAnnotationType extends AnnotationType {
  IbatisUpdateAnnotationType() { this.hasQualifiedName("org.apache.ibatis.annotations", "Update") }
}

/**
 * An Ibatis SQL operation annotation.
 */
class IbatisSqlOperationAnnotation extends Annotation {
  IbatisSqlOperationAnnotation() {
    this.getType() instanceof IbatisSelectAnnotationType or
    this.getType() instanceof IbatisDeleteAnnotationType or
    this.getType() instanceof IbatisInsertAnnotationType or
    this.getType() instanceof IbatisUpdateAnnotationType
  }

  /**
   * Gets this annotation's SQL statement string.
   */
  string getSqlValue() {
    result = this.getAValue("value").(CompileTimeConstantExpr).getStringValue()
  }
}

/**
 * Methods annotated with `@org.apache.ibatis.annotations.Select` or `@org.apache.ibatis.annotations.Delete`
 * or `@org.apache.ibatis.annotations.Update` or `@org.apache.ibatis.annotations.Insert`.
 */
class MyBatisSqlOperationAnnotationMethod extends Method {
  MyBatisSqlOperationAnnotationMethod() {
    this.getAnAnnotation() instanceof IbatisSqlOperationAnnotation
  }
}

/** The interface `org.apache.ibatis.annotations.Param`. */
class TypeParam extends Interface {
  TypeParam() { this.hasQualifiedName("org.apache.ibatis.annotations", "Param") }
}

private class MyBatisProvider extends RefType {
  MyBatisProvider() {
    this.hasQualifiedName("org.apache.ibatis.annotations",
      ["Select", "Delete", "Insert", "Update"] + "Provider")
  }
}

/**
 * A return statement of a method used in a MyBatis Provider.
 *
 * See
 * - `MyBatisProvider`
 * - https://mybatis.org/mybatis-3/apidocs/org/apache/ibatis/annotations/package-summary.html
 */
class MyBatisInjectionSink extends DataFlow::Node {
  MyBatisInjectionSink() {
    exists(Annotation a, Method m |
      a.getType() instanceof MyBatisProvider and
      m.getDeclaringType() = a.getValue(["type", "value"]).(TypeLiteral).getTypeName().getType() and
      m.hasName(a.getValue("method").(StringLiteral).getValue()) and
      exists(ReturnStmt ret | this.asExpr() = ret.getResult() and ret.getEnclosingCallable() = m)
    )
  }
}

private class MyBatisProviderStep extends TaintTracking::AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess ma, Annotation a, Method providerMethod |
      exists(int i |
        ma.getArgument(pragma[only_bind_into](i)) = n1.asExpr() and
        providerMethod.getParameter(pragma[only_bind_into](i)) = n2.asParameter()
      )
    |
      a.getType() instanceof MyBatisProvider and
      ma.getMethod().getAnAnnotation() = a and
      providerMethod.getDeclaringType() =
        a.getValue(["type", "value"]).(TypeLiteral).getTypeName().getType() and
      providerMethod.hasName(a.getValue("method").(StringLiteral).getValue())
    )
  }
}

private class MyBatisAbstractSqlToStringStep extends SummaryModelCsv {
  override predicate row(string row) {
    row = "org.apache.ibatis.jdbc;AbstractSQL;true;toString;;;Argument[-1];ReturnValue;taint;manual"
  }
}

private class MyBatisAbstractSqlMethodsStep extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.ibatis.jdbc;AbstractSQL;true;toString;;;Argument[-1];ReturnValue;taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;WHERE;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;WHERE;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;WHERE;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;WHERE;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;VALUES;(String,String);;Argument[0..1];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;UPDATE;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;SET;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;SET;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;SET;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;SET;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;SELECT_DISTINCT;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;SELECT_DISTINCT;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;SELECT_DISTINCT;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;SELECT_DISTINCT;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;SELECT;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;RIGHT_OUTER_JOIN;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;RIGHT_OUTER_JOIN;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;RIGHT_OUTER_JOIN;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;RIGHT_OUTER_JOIN;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;OUTER_JOIN;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;OUTER_JOIN;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;OUTER_JOIN;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;OUTER_JOIN;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;ORDER_BY;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;ORDER_BY;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;ORDER_BY;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;ORDER_BY;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;OFFSET_ROWS;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;OFFSET;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;LIMIT;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;LEFT_OUTER_JOIN;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;LEFT_OUTER_JOIN;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;LEFT_OUTER_JOIN;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;LEFT_OUTER_JOIN;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;JOIN;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;INTO_VALUES;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;INTO_COLUMNS;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;INSERT_INTO;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;INNER_JOIN;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;INNER_JOIN;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;INNER_JOIN;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;INNER_JOIN;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;HAVING;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;HAVING;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;HAVING;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;HAVING;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;GROUP_BY;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;GROUP_BY;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;GROUP_BY;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;GROUP_BY;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;FROM;(String[]);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;FROM;(String[]);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;FROM;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;FROM;(String);;Argument[0].ArrayElement;Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;FETCH_FIRST_ROWS_ONLY;(String);;Argument[0];Argument[-1];taint;manual",
        "org.apache.ibatis.jdbc;AbstractSQL;true;DELETE_FROM;(String);;Argument[0];Argument[-1];taint;manual"
      ]
  }
}
