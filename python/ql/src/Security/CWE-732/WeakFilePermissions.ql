/**
 * @name Overly permissive file permissions
 * @description Allowing files to be readable or writable by users other than the owner may allow sensitive information to be accessed.
 * @kind problem
 * @id py/overly-permissive-file
 * @problem.severity warning
 * @sub-severity high
 * @precision medium
 * @tags external/cwe/cwe-732
 *       security
 */
import python

bindingset[p]
int world_permission(int p) {
    result = p % 8
}

bindingset[p]
int group_permission(int p) {
    result = (p/8) % 8
}

bindingset[p]
string access(int p) {
    p%4 >= 2 and result = "writable" or
    p%4 < 2 and p != 0 and result = "readable"
}

bindingset[p]
string permissive_permission(int p) {
    result = "world " + access(world_permission(p))
    or
    world_permission(p) = 0 and result = "group " + access(group_permission(p))
}

predicate chmod_call(CallNode call, FunctionObject chmod, NumericObject num) {
    ModuleObject::named("os").attr("chmod") = chmod and
    chmod.getACall() = call and call.getArg(1).refersTo(num)
}

predicate open_call(CallNode call, FunctionObject open, NumericObject num) {
    ModuleObject::named("os").attr("open") = open and
    open.getACall() = call and call.getArg(2).refersTo(num)
}


from CallNode call, FunctionObject func, NumericObject num, string permission
where
    (chmod_call(call, func, num) or open_call(call, func, num))
    and
    permission = permissive_permission(num.intValue())
select call, "Overly permissive mask in " + func.getName() + " sets file to " + permission + "."
