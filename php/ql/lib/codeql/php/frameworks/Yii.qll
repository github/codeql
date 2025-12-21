/**
 * Provides classes for modeling Yii framework patterns.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.frameworks.Core

/**
 * A Yii request input method call.
 */
class YiiRequestInput extends MethodCall {
  YiiRequestInput() {
    this.getMethodName() in [
      "get", "post", "getBodyParam", "getQueryParam", "getQueryParams",
      "getBodyParams", "getCookies", "getHeaders"
    ]
  }
}

/**
 * A Yii database command method call.
 */
class YiiDbCommand extends MethodCall {
  YiiDbCommand() {
    this.getMethodName() in [
      "createCommand", "setSql", "bindValue", "bindValues", "bindParam",
      "execute", "queryAll", "queryOne", "queryColumn", "queryScalar"
    ]
  }
}

/**
 * A Yii Active Record query.
 */
class YiiActiveQuery extends MethodCall {
  YiiActiveQuery() {
    this.getMethodName() in [
      "find", "findOne", "findAll", "findBySql",
      "where", "andWhere", "orWhere", "filterWhere",
      "orderBy", "groupBy", "having", "limit", "offset",
      "select", "with", "joinWith", "innerJoinWith",
      "all", "one", "count", "sum", "average", "min", "max", "exists"
    ]
  }
}

/**
 * A Yii unsafe raw query.
 */
class YiiUnsafeQuery extends MethodCall {
  YiiUnsafeQuery() {
    this.getMethodName() = "createCommand"
  }
}

/**
 * A Yii view rendering call.
 */
class YiiViewRender extends MethodCall {
  YiiViewRender() {
    this.getMethodName() in ["render", "renderFile", "renderPartial", "renderAjax", "renderContent"]
  }
}

/**
 * A Yii HTML encoding.
 */
class YiiHtmlEncode extends StaticMethodCall {
  YiiHtmlEncode() {
    this.getClassName() = "Html" and
    this.getMethodName() in ["encode", "decode"]
  }
}

/**
 * A Yii validation method.
 */
class YiiValidation extends MethodCall {
  YiiValidation() {
    this.getMethodName() in ["validate", "validateAttribute", "validateMultiple"]
  }
}
