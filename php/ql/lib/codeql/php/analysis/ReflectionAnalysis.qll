/**
 * @name PHP Reflection Analysis
 * @description Enhanced analysis for PHP reflection API usage
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A function call that uses the PHP Reflection API.
 */
class ReflectionFunctionCall extends TS::PHP::FunctionCallExpression {
  ReflectionFunctionCall() {
    exists(string name | name = this.getFunction().(TS::PHP::Name).getValue() |
      name in [
        "class_exists", "method_exists", "property_exists", "function_exists",
        "get_class", "get_parent_class", "get_class_methods", "get_class_vars",
        "get_object_vars", "get_defined_functions", "get_defined_vars",
        "is_a", "is_subclass_of", "interface_exists", "trait_exists"
      ]
    )
  }

  /** Gets the function name */
  string getFunctionName() {
    result = this.getFunction().(TS::PHP::Name).getValue()
  }

  /** Gets an argument */
  TS::PHP::AstNode getAnArg() {
    result = this.getArguments().getChild(_)
  }

  /** Gets the first argument (usually the class/function name) */
  TS::PHP::AstNode getFirstArg() {
    result = this.getArguments().getChild(0)
  }

  /** Checks if argument is a variable (potentially tainted) */
  predicate usesVariableArg() {
    this.getFirstArg() instanceof TS::PHP::VariableName
  }

  /** Checks if argument is a string literal (hardcoded) */
  predicate usesStringLiteral() {
    this.getFirstArg() instanceof TS::PHP::String
  }
}

/** Helper to get the class name from an ObjectCreationExpression */
private string getCreatedClassName(TS::PHP::ObjectCreationExpression expr) {
  result = expr.getChild(_).(TS::PHP::Name).getValue() or
  result = expr.getChild(_).(TS::PHP::QualifiedName).toString()
}

/** Helper to get Arguments from an ObjectCreationExpression */
private TS::PHP::Arguments getObjectCreationArgs(TS::PHP::ObjectCreationExpression expr) {
  result = expr.getChild(_)
}

/**
 * A new expression that creates a ReflectionClass.
 */
class ReflectionClassInstantiation extends TS::PHP::ObjectCreationExpression {
  ReflectionClassInstantiation() {
    getCreatedClassName(this) in ["ReflectionClass", "\\ReflectionClass"]
  }

  /** Gets the class name argument */
  TS::PHP::AstNode getClassNameArg() {
    result = getObjectCreationArgs(this).getChild(0)
  }

  /** Checks if class name is from a variable */
  predicate usesDynamicClassName() {
    this.getClassNameArg() instanceof TS::PHP::VariableName
  }
}

/**
 * A new expression that creates a ReflectionMethod.
 */
class ReflectionMethodInstantiation extends TS::PHP::ObjectCreationExpression {
  ReflectionMethodInstantiation() {
    getCreatedClassName(this) in ["ReflectionMethod", "\\ReflectionMethod"]
  }

  /** Gets the class name argument */
  TS::PHP::AstNode getClassNameArg() {
    result = getObjectCreationArgs(this).getChild(0)
  }

  /** Gets the method name argument */
  TS::PHP::AstNode getMethodNameArg() {
    result = getObjectCreationArgs(this).getChild(1)
  }

  /** Checks if uses dynamic class/method names */
  predicate usesDynamicNames() {
    this.getClassNameArg() instanceof TS::PHP::VariableName or
    this.getMethodNameArg() instanceof TS::PHP::VariableName
  }
}

/**
 * A new expression that creates a ReflectionFunction.
 */
class ReflectionFunctionInstantiation extends TS::PHP::ObjectCreationExpression {
  ReflectionFunctionInstantiation() {
    getCreatedClassName(this) in ["ReflectionFunction", "\\ReflectionFunction"]
  }

  /** Gets the function name argument */
  TS::PHP::AstNode getFunctionNameArg() {
    result = getObjectCreationArgs(this).getChild(0)
  }

  /** Checks if function name is dynamic */
  predicate usesDynamicName() {
    this.getFunctionNameArg() instanceof TS::PHP::VariableName
  }
}

/**
 * A method call on a Reflection object.
 */
class ReflectionMethodCall extends TS::PHP::MemberCallExpression {
  ReflectionMethodCall() {
    exists(string methodName | methodName = this.getName().(TS::PHP::Name).getValue() |
      methodName in [
        "invoke", "invokeArgs", "newInstance", "newInstanceArgs", "newInstanceWithoutConstructor",
        "setAccessible", "getValue", "setValue", "getMethod", "getProperty",
        "getMethods", "getProperties", "getConstants", "getConstructor"
      ]
    )
  }

  /** Gets the method name being called */
  string getReflectionMethodName() {
    result = this.getName().(TS::PHP::Name).getValue()
  }

  /** Checks if this is an invoke call */
  predicate isInvoke() {
    this.getReflectionMethodName() in ["invoke", "invokeArgs"]
  }

  /** Checks if this creates a new instance */
  predicate isInstantiation() {
    this.getReflectionMethodName() in ["newInstance", "newInstanceArgs", "newInstanceWithoutConstructor"]
  }

  /** Checks if this sets accessibility */
  predicate setsAccessible() {
    this.getReflectionMethodName() = "setAccessible"
  }
}

/**
 * call_user_func and call_user_func_array - dynamic function calls.
 */
class DynamicCallFunction extends TS::PHP::FunctionCallExpression {
  DynamicCallFunction() {
    this.getFunction().(TS::PHP::Name).getValue() in ["call_user_func", "call_user_func_array"]
  }

  /** Gets the callable argument */
  TS::PHP::AstNode getCallableArg() {
    result = this.getArguments().getChild(0)
  }

  /** Checks if callable is a variable */
  predicate usesDynamicCallable() {
    this.getCallableArg() instanceof TS::PHP::VariableName
  }
}

/**
 * Checks if a reflection call might be exploited.
 */
predicate potentiallyUnsafeReflection(TS::PHP::AstNode node) {
  exists(ReflectionClassInstantiation r | node = r and r.usesDynamicClassName()) or
  exists(ReflectionMethodInstantiation r | node = r and r.usesDynamicNames()) or
  exists(ReflectionFunctionInstantiation r | node = r and r.usesDynamicName()) or
  exists(DynamicCallFunction d | node = d and d.usesDynamicCallable())
}
