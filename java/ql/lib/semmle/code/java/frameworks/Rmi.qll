/* Remote Method Invocation. */
import java

/** The interface `java.rmi.Remote`. */
class TypeRemote extends RefType {
  TypeRemote() { hasQualifiedName("java.rmi", "Remote") }
}

/** A method that is intended to be called via RMI. */
class RemoteCallableMethod extends Method {
  RemoteCallableMethod() { remoteCallableMethod(this) }
}

private predicate remoteCallableMethod(Method method) {
  method.getDeclaringType().getASupertype() instanceof TypeRemote
  or
  exists(Method meth | remoteCallableMethod(meth) and method.overrides(meth))
}
