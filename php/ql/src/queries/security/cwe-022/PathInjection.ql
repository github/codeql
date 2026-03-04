/**
 * @name Path built from user-controlled sources
 * @description Using user-controlled data to construct a file path may allow
 *              an attacker to access or modify unintended files.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @id php/path-injection
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 */

import codeql.php.AST
import codeql.php.DataFlow
import codeql.php.TaintTracking

/**
 * A source of user input from PHP superglobals.
 */
class UserInputSource extends DataFlow::ExprNode {
  UserInputSource() {
    exists(VariableName v | v = this.asExpr() |
      v.getValue() = "$_GET" or
      v.getValue() = "$_POST" or
      v.getValue() = "$_REQUEST" or
      v.getValue() = "$_COOKIE"
    )
    or
    exists(SubscriptExpr sub, VariableName v |
      sub = this.asExpr() and
      v = sub.getObject() and
      (
        v.getValue() = "$_GET" or
        v.getValue() = "$_POST" or
        v.getValue() = "$_REQUEST" or
        v.getValue() = "$_COOKIE"
      )
    )
  }
}

/**
 * A sink that uses a file path.
 */
class PathSink extends DataFlow::ExprNode {
  PathSink() {
    exists(FunctionCallExpr call |
      call.getFunctionName() =
        [
          "fopen", "file_get_contents", "file_put_contents", "readfile", "include", "include_once",
          "require", "require_once", "file", "fread", "fwrite", "unlink", "rename", "copy",
          "mkdir", "rmdir", "is_file", "is_dir", "realpath", "glob"
        ] and
      this.asExpr() = call.getArgument(0)
    )
  }
}

module PathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UserInputSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof PathSink }

  predicate isBarrier(DataFlow::Node node) {
    exists(FunctionCallExpr call |
      call.getFunctionName() = ["basename", "realpath"] and
      node.asExpr() = call
    )
  }
}

module PathInjectionFlow = TaintTracking::Global<PathInjectionConfig>;

import PathInjectionFlow::PathGraph

from PathInjectionFlow::PathNode source, PathInjectionFlow::PathNode sink
where PathInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on a $@.", source.getNode(),
  "user-provided value"
