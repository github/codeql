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

/**
 * Gets the permission value for permission with name `name`.
 *
 * From https://github.com/python/cpython/blob/3.12/Lib/stat.py#L90-L110:
 * ```python
 * # Names for permission bits
 *
 * S_IRWXG = 0o0070  # mask for group permissions
 * S_IRGRP = 0o0040  # read by group
 * S_IWGRP = 0o0020  # write by group
 * S_IXGRP = 0o0010  # execute by group
 * S_IRWXO = 0o0007  # mask for others (not in group) permissions
 * S_IROTH = 0o0004  # read by others
 * S_IWOTH = 0o0002  # write by others
 * S_IXOTH = 0o0001  # execute by others
 * ```
 */
int name_to_permission(string name) {
  name = "S_IRWXG" and result = 7 * 8
  or
  name = "S_IRGRP" and result = 4 * 8
  or
  name = "S_IWGRP" and result = 2 * 8
  or
  name = "S_IXGRP" and result = 1 * 8
  or
  name = "S_IRWXO" and result = 7
  or
  name = "S_IROTH" and result = 4
  or
  name = "S_IWOTH" and result = 2
  or
  name = "S_IXOTH" and result = 1
}

int mode_from_node(DataFlow::Node mode) {
  result = mode.asExpr().(IntegerLiteral).getValue()
  or
  exists(string name |
    mode = API::moduleImport("stat").getMember(name).asSource() and
    result = name_to_permission(name)
  )
}

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
  mode = mode_from_node(call.getParameter(1, "mode").getAValueReachingSink()) and
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
