/**
 * @name Overly permissive file permissions
 * @description Allowing files to be readable or writable by users other than the owner may allow sensitive information to be accessed.
 * @kind path-problem
 * @problem.severity warning
 * @id rb/overly-permissive-file
 * @tags external/cwe/cwe-732
 *       security
 * @precision low
 */

import ruby
import codeql_ruby.DataFlow
import DataFlow::PathGraph
private import codeql_ruby.dataflow.SSA

// TODO: account for flows through tuple assignments
/** An expression referencing the File or FileUtils module */
class FileModuleAccess extends Expr {
  FileModuleAccess() {
    this.(ConstantAccess).getName() = "File"
    or
    this.(ConstantAccess).getName() = "FileUtils"
    or
    exists(FileModuleAccess fma, Ssa::WriteDefinition def |
      def.getARead() = this.getAControlFlowNode() and
      def.getWriteAccess().getParent().(Assignment).getRightOperand() = fma
    )
  }
}

bindingset[p]
int world_permission(int p) { result = p.bitAnd(7) }

// 70 oct = 56 dec
bindingset[p]
int group_permission(int p) { result = p.bitAnd(56) }

bindingset[p]
string access(int p) {
  p.bitAnd(2) != 0 and result = "writable"
  or
  p.bitAnd(4) != 0 and result = "readable"
}

/** An expression specifing a file permission that allows group/others read or write access */
class PermissivePermissionsExpr extends Expr {
  // TODO: non-literal expressions?
  PermissivePermissionsExpr() {
    exists(int perm, string acc |
      perm = this.(IntegerLiteral).getValue() and
      (acc = access(world_permission(perm)) or acc = access(group_permission(perm)))
    )
    or
    // adding/setting read or write permissions for all/group/other
    this.(StringLiteral).getValueText().regexpMatch(".*[ago][^-=+]*[+=][xXst]*[rw].*")
  }
}

/** A permissions argument of a call to a File/FileUtils method that may modify file permissions */
class PermissionArgument extends Expr {
  private MethodCall call;
  private string methodName;

  PermissionArgument() {
    call.getReceiver() instanceof FileModuleAccess and
    call.getMethodName() = methodName and
    (
      methodName in ["chmod", "chmod_R", "lchmod"] and this = call.getArgument(0)
      or
      methodName = "mkfifo" and this = call.getArgument(1)
      or
      methodName in ["new", "open"] and this = call.getArgument(2)
      or
      methodName in ["install", "makedirs", "mkdir", "mkdir_p", "mkpath"] and
      this = call.getKeywordArgument("mode")
      // TODO: defaults for optional args? This may depend on the umask
    )
  }

  MethodCall getCall() { result = call }
}

class PermissivePermissionsConfig extends DataFlow::Configuration {
  PermissivePermissionsConfig() { this = "PermissivePermissionsConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(PermissivePermissionsExpr ppe | source.asExpr().getExpr() = ppe)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(PermissionArgument arg | sink.asExpr().getExpr() = arg)
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, PermissivePermissionsConfig conf,
  PermissionArgument arg
where conf.hasFlowPath(source, sink) and arg = sink.getNode().asExpr().getExpr()
select source.getNode(), source, sink, "Overly permissive mask in $@ sets file to $@.",
  arg.getCall(), arg.getCall().toString(), source.getNode(), source.getNode().toString()
