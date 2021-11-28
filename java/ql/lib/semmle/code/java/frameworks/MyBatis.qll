/**
 * Provides classes and predicates for working with the MyBatis framework.
 */

import java
import semmle.code.java.dataflow.ExternalFlow

/** The class `org.apache.ibatis.jdbc.SqlRunner`. */
class MyBatisSqlRunner extends RefType {
  MyBatisSqlRunner() { this.hasQualifiedName("org.apache.ibatis.jdbc", "SqlRunner") }
}

private class SqlSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "org.apache.ibatis.jdbc;SqlRunner;false;delete;(String,Object[]);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;insert;(String,Object[]);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;run;(String);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;selectAll;(String,Object[]);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;selectOne;(String,Object[]);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;update;(String,Object[]);;Argument[0];sql"
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
    getDeclaringType() instanceof IbatisConfiguration and
    hasName("getVariables") and
    getNumberOfParameters() = 0
  }
}

/**
 * An annotation type that identifies Ibatis select.
 */
private class IbatisSelectAnnotationType extends AnnotationType {
  IbatisSelectAnnotationType() {
    this.hasQualifiedName("org.apache.ibatis.annotations", "Select") or
    this.getAnAnnotation().getType() instanceof IbatisSelectAnnotationType
  }
}

/**
 * An annotation type that identifies Ibatis delete.
 */
private class IbatisDeleteAnnotationType extends AnnotationType {
  IbatisDeleteAnnotationType() {
    this.hasQualifiedName("org.apache.ibatis.annotations", "Delete") or
    this.getAnAnnotation().getType() instanceof IbatisDeleteAnnotationType
  }
}

/**
 * An annotation type that identifies Ibatis insert.
 */
private class IbatisInsertAnnotationType extends AnnotationType {
  IbatisInsertAnnotationType() {
    this.hasQualifiedName("org.apache.ibatis.annotations", "Insert") or
    this.getAnAnnotation().getType() instanceof IbatisInsertAnnotationType
  }
}

/**
 * An annotation type that identifies Ibatis update.
 */
private class IbatisUpdateAnnotationType extends AnnotationType {
  IbatisUpdateAnnotationType() {
    this.hasQualifiedName("org.apache.ibatis.annotations", "Update") or
    this.getAnAnnotation().getType() instanceof IbatisUpdateAnnotationType
  }
}

/**
 * Ibatis sql operation annotation.
 */
abstract class IbatisSqlOperationAnnotation extends Annotation {
  abstract string getSqlValue();
}

/**
 * A `@org.apache.ibatis.annotations.Select` annotation.
 */
private class IbatisSelectAnnotation extends IbatisSqlOperationAnnotation {
  IbatisSelectAnnotation() { this.getType() instanceof IbatisSelectAnnotationType }

  string getSelectValue() {
    result = this.getValue("value").(CompileTimeConstantExpr).getStringValue() or
    result =
      this.getValue("value").(ArrayInit).getInit(_).(CompileTimeConstantExpr).getStringValue()
  }

  override string getSqlValue() { result = getSelectValue() }
}

/**
 * A `@org.apache.ibatis.annotations.Delete` annotation.
 */
private class IbatisDeleteAnnotation extends IbatisSqlOperationAnnotation {
  IbatisDeleteAnnotation() { this.getType() instanceof IbatisDeleteAnnotationType }

  string getDeleteValue() {
    result = this.getValue("value").(CompileTimeConstantExpr).getStringValue() or
    result =
      this.getValue("value").(ArrayInit).getInit(_).(CompileTimeConstantExpr).getStringValue()
  }

  override string getSqlValue() { result = getDeleteValue() }
}

/**
 * A `@org.apache.ibatis.annotations.Insert` annotation.
 */
private class IbatisInsertAnnotation extends IbatisSqlOperationAnnotation {
  IbatisInsertAnnotation() { this.getType() instanceof IbatisInsertAnnotationType }

  string getInsertValue() {
    result = this.getValue("value").(CompileTimeConstantExpr).getStringValue() or
    result =
      this.getValue("value").(ArrayInit).getInit(_).(CompileTimeConstantExpr).getStringValue()
  }

  override string getSqlValue() { result = getInsertValue() }
}

/**
 * A `@org.apache.ibatis.annotations.Update` annotation.
 */
private class IbatisUpdateAnnotation extends IbatisSqlOperationAnnotation {
  IbatisUpdateAnnotation() { this.getType() instanceof IbatisUpdateAnnotationType }

  string getUpdateValue() {
    result = this.getValue("value").(CompileTimeConstantExpr).getStringValue() or
    result =
      this.getValue("value").(ArrayInit).getInit(_).(CompileTimeConstantExpr).getStringValue()
  }

  override string getSqlValue() { result = getUpdateValue() }
}

// Mybatis uses sql operation to annotate the method of interacting with the database.
class MybatisSqlOperationAnnotationMethod extends Method {
  MybatisSqlOperationAnnotationMethod() {
    exists(IbatisSqlOperationAnnotation isoa |
      this.getAnAnnotation() = isoa  
    )
  }
}
