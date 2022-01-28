/**
 * @name Overly permissive file permissions
 * @description Allowing files to be readable or writable by users other than the owner may allow sensitive information to be accessed.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @id rb/overly-permissive-file
 * @tags external/cwe/cwe-732
 *       security
 * @precision low
 */

import ruby
import codeql.ruby.Concepts
import codeql.ruby.DataFlow
import DataFlow::PathGraph
import codeql.ruby.ApiGraphs

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

/** An expression specifying a file permission that allows group/others read or write access */
class PermissivePermissionsExpr extends Expr {
  // TODO: non-literal expressions?
  PermissivePermissionsExpr() {
    exists(int perm, string acc |
      perm = this.(IntegerLiteral).getValue() and
      (acc = access(world_permission(perm)) or acc = access(group_permission(perm)))
    )
    or
    // adding/setting read or write permissions for all/group/other
    this.(StringLiteral)
        .getConstantValue()
        .getString()
        .regexpMatch(".*[ago][^-=+]*[+=][xXst]*[rw].*")
  }
}

class PermissivePermissionsConfig extends DataFlow::Configuration {
  PermissivePermissionsConfig() { this = "PermissivePermissionsConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().getExpr() instanceof PermissivePermissionsExpr
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FileSystemPermissionModification mod | mod.getAPermissionNode() = sink)
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, PermissivePermissionsConfig conf,
  FileSystemPermissionModification mod
where conf.hasFlowPath(source, sink) and mod.getAPermissionNode() = sink.getNode()
select source.getNode(), source, sink, "Overly permissive mask in $@ sets file to $@.", mod,
  mod.toString(), source.getNode(), source.getNode().toString()
