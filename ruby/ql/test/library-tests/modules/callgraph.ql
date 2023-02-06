import codeql.ruby.AST

query Callable getTarget(Call call) { result = call.getATarget() }

query predicate unresolvedCall(Call call) { not exists(call.getATarget()) }

query predicate privateMethod(MethodBase m) { m.isPrivate() }

query predicate publicMethod(MethodBase m) { m.isPublic() }

query predicate protectedMethod(MethodBase m) { m.isProtected() }
