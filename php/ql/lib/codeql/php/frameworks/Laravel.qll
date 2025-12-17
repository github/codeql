/**
 * Provides classes for modeling Laravel framework patterns.
 *
 * This module covers common Laravel patterns:
 * - Request object method calls
 * - Eloquent ORM queries
 * - Database facade
 * - Blade template rendering
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.ast.Declaration
private import codeql.php.frameworks.Core

/**
 * A Laravel request method call (e.g., $request->input('id')).
 */
class LaravelRequestMethodCall extends MethodCall {
  LaravelRequestMethodCall() {
    // Check if the object is a $request variable
    exists(Variable v | v = this.getObject() |
      v.getName() in ["request", "req"]
    ) and
    this.getMethodName() in [
      "input", "query", "post", "all", "get", "only", "except",
      "has", "filled", "missing", "boolean", "date", "file"
    ]
  }

  /** Gets the input key argument, if present. */
  TS::PHP::AstNode getKeyArgument() { result = this.getArgument(0) }

  /** Gets the input key as a string, if it's a literal. */
  string getInputKey() { result = this.getKeyArgument().(StringLiteral).getValue() }
}

/**
 * A Laravel DB facade static method call (e.g., DB::table(), DB::raw()).
 */
class LaravelDbFacadeCall extends StaticMethodCall {
  LaravelDbFacadeCall() {
    this.getClassName() = "DB" and
    this.getMethodName() in [
      "raw", "table", "select", "insert", "update", "delete",
      "statement", "unprepared", "connection", "transaction"
    ]
  }
}

/**
 * A Laravel DB::raw() call (potentially dangerous).
 */
class LaravelRawQuery extends LaravelDbFacadeCall {
  LaravelRawQuery() { this.getMethodName() = "raw" }

  /** Gets the raw SQL argument. */
  TS::PHP::AstNode getSqlArgument() { result = this.getArgument(0) }
}

/**
 * A Laravel query builder method call.
 */
class LaravelQueryBuilderCall extends MethodCall {
  LaravelQueryBuilderCall() {
    this.getMethodName() in [
      "select", "selectRaw", "addSelect",
      "where", "whereRaw", "orWhere", "orWhereRaw",
      "whereIn", "whereNotIn", "whereBetween", "whereNotBetween",
      "whereNull", "whereNotNull", "whereDate", "whereMonth", "whereDay", "whereYear",
      "whereColumn", "whereExists", "whereNested",
      "join", "leftJoin", "rightJoin", "crossJoin", "joinSub",
      "orderBy", "orderByRaw", "orderByDesc", "latest", "oldest", "inRandomOrder",
      "groupBy", "groupByRaw", "having", "havingRaw",
      "limit", "take", "skip", "offset", "forPage",
      "get", "first", "find", "findOrFail", "firstOrFail", "value", "pluck",
      "count", "sum", "avg", "min", "max", "exists", "doesntExist",
      "insert", "insertOrIgnore", "insertGetId", "update", "delete", "truncate",
      "increment", "decrement", "paginate", "simplePaginate", "cursorPaginate"
    ]
  }
}

/**
 * A Laravel raw query method (potentially dangerous).
 */
class LaravelRawQueryMethod extends LaravelQueryBuilderCall {
  LaravelRawQueryMethod() {
    this.getMethodName() in [
      "selectRaw", "whereRaw", "orWhereRaw", "havingRaw", "orderByRaw", "groupByRaw"
    ]
  }

  /** Gets the raw SQL argument. */
  TS::PHP::AstNode getSqlArgument() { result = this.getArgument(0) }
}

/**
 * An Eloquent model class.
 */
class EloquentModel extends ClassDef {
  EloquentModel() {
    exists(TS::PHP::BaseClause bc | bc = this.getBaseClause() |
      exists(TS::PHP::Name n | n = bc.getChild(_) |
        n.getValue() in ["Model", "Eloquent"]
      )
    )
  }
}

/**
 * An Eloquent query method call.
 */
class EloquentQueryCall extends MethodCall {
  EloquentQueryCall() {
    this.getMethodName() in [
      "all", "find", "findOrFail", "findOr", "findMany",
      "first", "firstOrFail", "firstOr", "firstWhere",
      "create", "forceCreate", "updateOrCreate", "firstOrCreate", "firstOrNew",
      "update", "delete", "destroy", "forceDelete", "restore", "truncate",
      "where", "whereRaw", "orWhere", "orWhereRaw",
      "with", "load", "loadMissing", "refresh",
      "save", "push", "touch"
    ]
  }
}

/**
 * A Laravel validation method call.
 */
class LaravelValidation extends MethodCall {
  LaravelValidation() {
    // $request->validate() or Validator::make()
    this.getMethodName() in ["validate", "validated", "safe"]
  }

  /** Gets the rules argument. */
  TS::PHP::AstNode getRulesArgument() { result = this.getArgument(0) }
}

/**
 * A Laravel Validator facade call.
 */
class LaravelValidatorFacade extends StaticMethodCall {
  LaravelValidatorFacade() {
    this.getClassName() = "Validator" and
    this.getMethodName() in ["make", "validate"]
  }

  /** Gets the data argument. */
  TS::PHP::AstNode getDataArgument() { result = this.getArgument(0) }

  /** Gets the rules argument. */
  TS::PHP::AstNode getRulesArgument() { result = this.getArgument(1) }
}

/**
 * A Laravel response method.
 */
class LaravelResponseMethod extends MethodCall {
  LaravelResponseMethod() {
    this.getMethodName() in [
      "json", "download", "file", "redirect", "redirectTo", "redirectRoute",
      "view", "make", "header", "cookie", "withCookie"
    ]
  }
}

/**
 * A Laravel response helper function.
 */
class LaravelResponseHelper extends FunctionCall {
  LaravelResponseHelper() {
    this.getFunctionName() in [
      "response", "redirect", "back", "view", "abort", "abort_if", "abort_unless"
    ]
  }
}

/**
 * A Laravel view function/method (Blade rendering).
 */
class LaravelViewCall extends FunctionCall {
  LaravelViewCall() {
    this.getFunctionName() = "view"
  }

  /** Gets the view name argument. */
  TS::PHP::AstNode getViewNameArgument() { result = this.getArgument(0) }

  /** Gets the data argument, if present. */
  TS::PHP::AstNode getDataArgument() { result = this.getArgument(1) }
}

/**
 * A Laravel auth check.
 */
class LaravelAuthCheck extends FunctionCall {
  LaravelAuthCheck() {
    this.getFunctionName() in ["auth", "gate"]
  }
}

/**
 * A Laravel Auth facade method call.
 */
class LaravelAuthFacadeCall extends StaticMethodCall {
  LaravelAuthFacadeCall() {
    this.getClassName() = "Auth" and
    this.getMethodName() in [
      "check", "guest", "user", "id", "attempt", "login", "logout",
      "loginUsingId", "once", "onceUsingId", "viaRemember"
    ]
  }
}

/**
 * A Laravel Gate facade method call (authorization).
 */
class LaravelGateFacadeCall extends StaticMethodCall {
  LaravelGateFacadeCall() {
    this.getClassName() = "Gate" and
    this.getMethodName() in [
      "allows", "denies", "check", "any", "none", "authorize",
      "forUser", "define", "resource", "policy"
    ]
  }

  /** Gets the ability argument. */
  TS::PHP::AstNode getAbilityArgument() { result = this.getArgument(0) }
}

/**
 * A Laravel route definition.
 */
class LaravelRouteDefinition extends StaticMethodCall {
  LaravelRouteDefinition() {
    this.getClassName() = "Route" and
    this.getMethodName() in [
      "get", "post", "put", "patch", "delete", "options", "any", "match",
      "resource", "apiResource", "singleton", "group", "middleware"
    ]
  }

  /** Gets the route pattern argument. */
  TS::PHP::AstNode getRoutePattern() { result = this.getArgument(0) }

  /** Gets the action/controller argument. */
  TS::PHP::AstNode getAction() { result = this.getArgument(1) }
}

/**
 * A Laravel Cache facade call.
 */
class LaravelCacheFacadeCall extends StaticMethodCall {
  LaravelCacheFacadeCall() {
    this.getClassName() = "Cache" and
    this.getMethodName() in [
      "get", "put", "forever", "forget", "flush", "has", "missing",
      "remember", "rememberForever", "pull", "add", "increment", "decrement"
    ]
  }
}

/**
 * A Laravel Log facade call.
 */
class LaravelLogFacadeCall extends StaticMethodCall {
  LaravelLogFacadeCall() {
    this.getClassName() = "Log" and
    this.getMethodName() in [
      "emergency", "alert", "critical", "error", "warning", "notice", "info", "debug", "log"
    ]
  }
}

/**
 * A Laravel event dispatch.
 */
class LaravelEventDispatch extends FunctionCall {
  LaravelEventDispatch() {
    this.getFunctionName() in ["event", "dispatch"]
  }
}

/**
 * A Laravel Mail facade call.
 */
class LaravelMailFacadeCall extends StaticMethodCall {
  LaravelMailFacadeCall() {
    this.getClassName() = "Mail" and
    this.getMethodName() in ["to", "send", "queue", "later", "raw"]
  }
}
