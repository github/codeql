/**
 * @name Cross-File Data Flow Analysis
 * @description Tracks data flow across multiple PHP files
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.crossfile.FunctionSummary

/**
 * A global declaration that imports a global variable.
 */
class GlobalVariableRef extends TS::PHP::GlobalDeclaration {
  /** Gets a variable being imported as global */
  TS::PHP::VariableName getGlobalVariable() {
    result = this.getChild(_)
  }

  /** Gets the name of a global variable */
  string getGlobalName() {
    result = this.getGlobalVariable().getChild().(TS::PHP::Name).getValue()
  }
}

/**
 * Include or require expression.
 */
class FileInclude extends TS::PHP::AstNode {
  FileInclude() {
    this instanceof TS::PHP::IncludeExpression or
    this instanceof TS::PHP::IncludeOnceExpression or
    this instanceof TS::PHP::RequireExpression or
    this instanceof TS::PHP::RequireOnceExpression
  }

  /** Gets the included file expression */
  TS::PHP::AstNode getIncludedFileExpr() {
    result = this.(TS::PHP::IncludeExpression).getChild() or
    result = this.(TS::PHP::IncludeOnceExpression).getChild() or
    result = this.(TS::PHP::RequireExpression).getChild() or
    result = this.(TS::PHP::RequireOnceExpression).getChild()
  }

  /** Checks if this is a static include (string literal) */
  predicate isStaticInclude() {
    this.getIncludedFileExpr() instanceof TS::PHP::String
  }

  /** Checks if this is a dynamic include (variable or expression) */
  predicate isDynamicInclude() {
    not this.isStaticInclude()
  }
}

/**
 * A superglobal variable access.
 */
class SuperglobalRef extends TS::PHP::VariableName {
  SuperglobalRef() {
    exists(string name | name = this.getChild().(TS::PHP::Name).getValue() |
      name in ["$_GET", "$_POST", "$_REQUEST", "$_COOKIE", "$_SESSION", "$_SERVER", "$_FILES", "$_ENV", "$GLOBALS"]
    )
  }

  /** Gets the superglobal name */
  string getSuperglobalName() {
    result = this.getChild().(TS::PHP::Name).getValue()
  }

  /** Checks if this is a user input superglobal */
  predicate isUserInput() {
    this.getSuperglobalName() in ["$_GET", "$_POST", "$_REQUEST", "$_COOKIE", "$_FILES"]
  }
}

/**
 * A subscript access on a superglobal.
 * Matches patterns like $_GET['key'], $_POST['value'], etc.
 */
class CrossFileSuperglobalArrayAccess extends TS::PHP::SubscriptExpression {
  SuperglobalRef base;

  CrossFileSuperglobalArrayAccess() {
    // SubscriptExpression uses getChild(0) for the base array and getChild(1) for the index
    base = this.getChild(0)
  }

  /** Gets the superglobal being accessed */
  SuperglobalRef getSuperglobal() {
    result = base
  }

  /** Gets the array key if it's a string literal */
  string getKeyName() {
    result = this.getChild(1).(TS::PHP::String).getChild(_).(TS::PHP::Token).getValue()
  }
}

/**
 * A potential data source.
 */
class DataSource extends TS::PHP::AstNode {
  DataSource() {
    this instanceof SuperglobalRef or
    this instanceof CrossFileSuperglobalArrayAccess or
    // File input
    exists(TS::PHP::FunctionCallExpression call |
      this = call and
      call.getFunction().(TS::PHP::Name).getValue() in [
        "file_get_contents", "fgets", "fread", "file", "stream_get_contents"
      ]
    ) or
    // Database results
    exists(TS::PHP::FunctionCallExpression call |
      this = call and
      call.getFunction().(TS::PHP::Name).getValue() in [
        "mysqli_fetch_array", "mysqli_fetch_assoc", "mysqli_fetch_row"
      ]
    )
  }
}

/**
 * A potential data sink.
 */
class DataSink extends TS::PHP::AstNode {
  DataSink() {
    // Echo statement
    this instanceof TS::PHP::EchoStatement or
    // Print intrinsic
    this instanceof TS::PHP::PrintIntrinsic or
    // Database query
    exists(TS::PHP::FunctionCallExpression call |
      this = call and
      call.getFunction().(TS::PHP::Name).getValue() in [
        "mysqli_query", "mysql_query", "pg_query"
      ]
    ) or
    // Command execution
    exists(TS::PHP::FunctionCallExpression call |
      this = call and
      call.getFunction().(TS::PHP::Name).getValue() in [
        "exec", "system", "passthru", "shell_exec", "popen"
      ]
    ) or
    // File operations
    exists(TS::PHP::FunctionCallExpression call |
      this = call and
      call.getFunction().(TS::PHP::Name).getValue() in [
        "file_put_contents", "fwrite"
      ]
    )
  }
}

/**
 * Call graph node for inter-procedural analysis.
 */
class CallGraphNode extends TS::PHP::AstNode {
  CallGraphNode() {
    this instanceof TS::PHP::FunctionCallExpression or
    this instanceof TS::PHP::MemberCallExpression or
    this instanceof TS::PHP::FunctionDefinition or
    this instanceof TS::PHP::MethodDeclaration
  }
}
