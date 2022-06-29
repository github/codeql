/**
 * @name Overly permissive file permissions
 * @description Allowing files to be readable or writable by users other than the owner may allow sensitive information to be accessed.
 * @kind problem
 * @id py/overly-permissive-file
 * @problem.severity warning
 * @security-severity 7.8
 * @sub-severity high
 * @precision medium
 * @tags external/cwe/cwe-732
 *       security
 */

import python
import semmle.python.ApiGraphs

bindingset[p]
int world_permission(int p) { result = p % 8 }

bindingset[p]
int group_permission(int p) { result = (p / 8) % 8 }

bindingset[p]
string access(int p) {
  p % 4 >= 2 and result = "writable"
  or
  p % 4 < 2 and p != 0 and result = "readable"
}

bindingset[p]
string permissive_permission(int p) {
  result = "world " + access(world_permission(p))
  or
  world_permission(p) = 0 and result = "group " + access(group_permission(p))
}

predicate chmod_call(API::CallNode call, string name, int mode) {
  call = API::moduleImport("os").getMember("chmod").getACall() and
  mode = call.getParameter(1, "mode").getAValueReachingSink().asExpr().(IntegerLiteral).getValue() and
  name = "chmod"
}

predicate open_call(API::CallNode call, string name, int mode) {
  call = API::moduleImport("os").getMember("open").getACall() and
  mode = call.getParameter(2, "mode").getAValueReachingSink().asExpr().(IntegerLiteral).getValue() and
  name = "open"
}

from API::CallNode call, string name, int mode, string permission
where
  (chmod_call(call, name, mode) or open_call(call, name, mode)) and
  permission = permissive_permission(mode)
select call, "Overly permissive mask in " + name + " sets file to " + permission + "."
