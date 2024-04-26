/**
 * Provides classes and predicates for identifying sensitive data and methods for security.
 *
 * 'Sensitive' data in general is anything that should not be sent around in unencrypted form. This
 * library tries to guess where sensitive data may either be stored in a variable or produced by a
 * method.
 *
 * In addition, there are methods that ought not to be executed or not in a fashion that the user
 * can control. This includes authorization methods such as logins, and sending of data, etc.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
import codeql.ruby.security.internal.SensitiveDataHeuristics
private import HeuristicNames
private import codeql.ruby.CFG

/** An expression that might contain sensitive data. */
cached
abstract class SensitiveNode extends DataFlow::Node {
  /** Gets a human-readable description of this expression for use in alert messages. */
  cached
  abstract string describe();

  /** Gets a classification of the kind of sensitive data this expression might contain. */
  cached
  abstract SensitiveDataClassification getClassification();
}

/** A method call that might produce sensitive data. */
abstract class SensitiveCall extends SensitiveNode { }

private class SensitiveDataMethodNameCall extends SensitiveCall instanceof DataFlow::CallNode {
  SensitiveDataClassification classification;

  SensitiveDataMethodNameCall() {
    classification = this.getMethodName().(SensitiveDataMethodName).getClassification()
  }

  override string describe() { result = "a call to " + super.getMethodName() }

  override SensitiveDataClassification getClassification() { result = classification }
}

private class SensitiveArgumentCall extends SensitiveCall instanceof DataFlow::CallNode {
  string argName;

  SensitiveArgumentCall() {
    // This is particularly to pick up methods with an argument like "password", which may indicate
    // a lookup.
    super.getArgument(_).asExpr().getConstantValue().isStringlikeValue(argName) and
    nameIndicatesSensitiveData(argName)
  }

  override string describe() { result = "a call to " + super.getMethodName() }

  override SensitiveDataClassification getClassification() {
    nameIndicatesSensitiveData(argName, result)
  }
}

/** An access to a variable or hash value that might contain sensitive data. */
abstract class SensitiveVariableAccess extends SensitiveNode {
  string name;

  SensitiveVariableAccess() {
    this.asExpr().(CfgNodes::ExprNodes::VariableAccessCfgNode).getExpr().getVariable().hasName(name)
    or
    this.asExpr()
        .(CfgNodes::ExprNodes::ElementReferenceCfgNode)
        .getAnArgument()
        .getConstantValue()
        .isStringlikeValue(name)
  }

  override string describe() { result = "an access to " + name }
}

/** A write to a location that might contain sensitive data. */
abstract class SensitiveWrite extends DataFlow::Node { }

/**
 * Holds if `node` is a write to a variable or hash value named `name`.
 *
 * Helper predicate factored out for performance,
 * to filter `name` as much as possible before using it in
 * regex matching.
 */
pragma[nomagic]
private predicate writesProperty(DataFlow::Node node, string name) {
  exists(VariableWriteAccess vwa | vwa.getVariable().getName() = name |
    node.asExpr().getExpr() = vwa
  )
  or
  // hash value assignment
  node.(DataFlow::CallNode).getMethodName() = "[]=" and
  node.(DataFlow::CallNode).getArgument(0).asExpr().getConstantValue().isStringlikeValue(name)
}

/**
 * Instance and class variable names are reported with their respective `@`
 * and `@@` prefixes. This predicate strips these prefixes.
 */
bindingset[name]
private string unprefixedVariableName(string name) { result = name.regexpReplaceAll("^@*", "") }

/** A write to a variable or property that might contain sensitive data. */
private class BasicSensitiveWrite extends SensitiveWrite {
  string unprefixedName;

  BasicSensitiveWrite() {
    exists(string name |
      /*
       * PERFORMANCE OPTIMISATION:
       * `nameIndicatesSensitiveData` performs a `regexpMatch` on `name`.
       * To carry out a regex match, we must first compute the Cartesian product
       * of all possible `name`s and regexes, then match.
       * To keep this product as small as possible,
       * we want to filter `name` as much as possible before the product.
       *
       * Do this by factoring out a helper predicate containing the filtering
       * logic that restricts `name`. This helper predicate will get picked first
       * in the join order, since it is the only call here that binds `name`.
       */

      writesProperty(this, name) and
      unprefixedName = unprefixedVariableName(name) and
      nameIndicatesSensitiveData(unprefixedName)
    )
  }

  /** Gets a classification of the kind of sensitive data the write might handle. */
  SensitiveDataClassification getClassification() {
    nameIndicatesSensitiveData(unprefixedName, result)
  }
}

/** An access to a variable or hash value that might contain sensitive data. */
private class BasicSensitiveVariableAccess extends SensitiveVariableAccess {
  string unprefixedName;

  BasicSensitiveVariableAccess() {
    unprefixedName = unprefixedVariableName(name) and
    nameIndicatesSensitiveData(unprefixedName)
  }

  override SensitiveDataClassification getClassification() {
    nameIndicatesSensitiveData(unprefixedName, result)
  }
}

/** A method name that suggests it may be sensitive. */
abstract class SensitiveMethodName extends string {
  SensitiveMethodName() { this = any(MethodBase m).getName() }
}

/** A method name that suggests it may produce sensitive data. */
abstract class SensitiveDataMethodName extends SensitiveMethodName {
  /** Gets a classification of the kind of sensitive data this method may produce. */
  abstract SensitiveDataClassification getClassification();
}

/** A method name that might return sensitive credential data. */
class CredentialsMethodName extends SensitiveDataMethodName {
  CredentialsMethodName() { nameIndicatesSensitiveData(this) }

  override SensitiveDataClassification getClassification() {
    nameIndicatesSensitiveData(this, result)
  }
}

/**
 * A sensitive action, such as transfer of sensitive data.
 */
abstract class SensitiveAction extends DataFlow::Node { }

/** Holds if the return value from call `c` is ignored. */
private predicate callWithIgnoredReturnValue(Call c) {
  exists(StmtSequence s, int i |
    (
      // If the call is a top-level statement within a statement sequence, its
      // return value (if any) is unused.
      c = s.getStmt(i)
      or
      // Or if the statement is an if-/unless-modifier expr and the call is its
      // branch.
      exists(ConditionalExpr cond |
        cond = s.getStmt(i) and
        c = cond.getBranch(_) and
        (cond instanceof IfModifierExpr or cond instanceof UnlessModifierExpr)
      )
    ) and
    // But exclude calls that are the last statement, since they are evaluated
    // as the overall value of the sequence.
    exists(s.getStmt(i + 1))
  ) and
  not c instanceof YieldCall and
  // Ignore statements in ERB output directives, which are evaluated.
  not exists(ErbOutputDirective d | d.getAChildStmt() = c)
}

/** A call that may perform authorization. */
class AuthorizationCall extends SensitiveAction, DataFlow::CallNode {
  AuthorizationCall() {
    exists(MethodCall c, string s |
      c = this.asExpr().getExpr() and
      s = c.getMethodName() // name contains `login` or `auth`, but not as part of `loginfo` or `unauth`;
    |
      // also exclude `author`
      s.regexpMatch("(?i).*(log_?in(?!fo)|(?<!un)auth(?!or\\b)|verify).*") and
      // but it does not start with `get` or `set`
      not s.regexpMatch("(?i)(get|set).*") and
      // Setter calls are unlikely to be sensitive actions.
      not c instanceof SetterMethodCall and
      (
        // Calls that have no return value (or ignore it) are likely to be
        // to methods that are actions.
        callWithIgnoredReturnValue(c)
        or
        // Method names ending in `!` are likely to be actions.
        s.matches("%!")
      )
    )
  }
}
