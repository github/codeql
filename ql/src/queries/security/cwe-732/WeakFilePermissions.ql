/**
 * @name Overly permissive file permissions
 * @description Allowing files to be readable or writable by users other than the owner may allow sensitive information to be accessed.
 * @kind problem
 * @problem.severity warning
 * @id rb/overly-permissive-file
 * @tags external/cwe/cwe-732
 *       security
 * @precision low
 */

import ruby
private import codeql_ruby.dataflow.SSA

// TODO: account for flows through tuple assignments
// TODO: full dataflow?
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

/** An expression specifing a file permission that allows group/others read or write access */
class PermissivePermissionsExpr extends Expr {
  PermissivePermissionsExpr() {
    this.(IntegerLiteral).getValueText().regexpMatch("0[0-7](([2-7].)|.[2-7])")
    or
    this.(IntegerLiteral)
        .getValueText()
        .regexpMatch("0b[01]{3}+((1[01]{5}+)|([01]1[01]{4}+)|([01]{3}+1[01]{2}+)|([01]{4}+1[01]))")
    or
    // TODO: non-literal expressions? underscores? decimal/hex literals?
    // adding/setting read or write permissions for all/group/owner
    this.(StringLiteral).getValueText().regexpMatch(".*[ago][^-=+]*[+=]*[rwxXst]*[rw].*")
    or
    exists(PermissivePermissionsExpr ppe, Ssa::WriteDefinition def |
      def.getARead() = this.getAControlFlowNode() and
      def.getWriteAccess().getParent().(Assignment).getRightOperand() = ppe
    )
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

  predicate isPermissive() { this.getPermissionArgument() instanceof PermissivePermissionsExpr }
}

from PermissionSettingMethodCall c
where c.isPermissive()
select c, "Overly permissive mask sets file to " + c.getPermissionArgument() + "."
