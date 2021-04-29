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
private import codeql_ruby.dataflow.SSA
private import codeql_ruby.dataflow.internal.DataFlowImpl as DataFlow

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
int world_permission(int p) { result = p % 8 }

bindingset[p]
int group_permission(int p) { result = (p / 8) % 8 }

bindingset[p]
string access(int p) {
  p % 4 >= 2 and result = "writable"
  or
  p % 8 in [4, 5] and result = "readable"
}

bindingset[s]
int parseInt(string s) {
  exists(string values, string str |
    s.matches("0b%") and values = "01" and str = s.suffix(2)
    or
    s.matches("0x%") and values = "0123456789abcdef" and str = s.suffix(2)
    or
    s.charAt(0) = "0" and not s.charAt(1) = ["b", "x"] and values = "01234567" and str = s.suffix(1)
    or
    s.charAt(0) != "0" and values = "0123456789" and str = s
  |
    result =
      sum(int index, string c, int v, int exp |
        c = str.replaceAll("_", "").charAt(index) and
        v = values.indexOf(c.toLowerCase()) and
        exp = str.replaceAll("_", "").length() - index - 1
      |
        v * values.length().pow(exp)
      )
  )
}

/** An expression specifing a file permission that allows group/others read or write access */
class PermissivePermissionsExpr extends Expr {
  // TODO: non-literal expressions?
  PermissivePermissionsExpr() {
    exists(int perm, string acc |
      perm = parseInt(this.(IntegerLiteral).getValueText()) and
      (acc = access(world_permission(perm)) or acc = access(group_permission(perm)))
    )
    or
    // adding/setting read or write permissions for all/group/owner
    this.(StringLiteral).getValueText().regexpMatch(".*[ago][^-=+]*[+=]*[xXst]*[rw].*")
  }
}

/** A call to a method of File or FileUtils that may modify file permissions */
class PermissionSettingMethodCall extends MethodCall {
  private string methodName;
  private Expr permArg;

  PermissionSettingMethodCall() {
    this.getReceiver() instanceof FileModuleAccess and
    this.getMethodName() = methodName and
    (
      methodName in ["chmod", "chmod_R", "lchmod"] and permArg = this.getArgument(0)
      or
      methodName = "mkfifo" and permArg = this.getArgument(1)
      or
      methodName in ["new", "open"] and permArg = this.getArgument(2)
      or
      methodName in ["install", "makedirs", "mkdir", "mkdir_p", "mkpath"] and
      permArg = this.getKeywordArgument("mode")
      // TODO: defaults for optional args? This may depend on the umask
    )
  }

  Expr getPermissionArgument() { result = permArg }
}

class PermissivePermissionsConfig extends DataFlow::Configuration {
  PermissivePermissionsConfig() { this = "PermissivePermissionsConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(PermissivePermissionsExpr ppe | source.asExpr().getExpr() = ppe)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(PermissionSettingMethodCall c | sink.asExpr().getExpr() = c.getPermissionArgument())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, PermissivePermissionsConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Overly permissive mask sets file to $@.", source.getNode(),
  source.getNode().toString()
