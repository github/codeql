import java
import EJB

/*
 * EJB Programming Restrictions (see EJB 3.0 specification, section 21.1.2).
 */

abstract class ForbiddenCallable extends Callable { }

/**
 * Specialized version of the `polyCalls(..)` predicate for the use
 * case of finding "shortest" call chains from EJBs to forbidden
 * methods. This is the same as `polyCalls(..)`, with two exceptions:
 *
 * - It does not consider calls into an EJB method.
 * - It does not consider calls from "forbidden callables".
 */
private predicate ejbPolyCalls(Callable origin, Callable target) {
  origin.polyCalls(target) and
  not exists(EJB ejb | target = ejb.getACallable()) and
  not origin instanceof ForbiddenCallable
}

private predicate ejbPolyCallsPlus(Callable origin, Callable target) {
  exists(EJB ejb | origin = ejb.getACallable() | ejbPolyCalls(origin, target))
  or
  exists(Callable mid | ejbPolyCallsPlus(origin, mid) and ejbPolyCalls(mid, target))
}

/**
 * Holds if there exists a call chain from an EJB-`Callable` `origin` to a `ForbiddenCallable` `target`
 * that does not contain any intermediate EJB-`Callable` or `ForbiddenCallable`,
 * and where `call` is the direct call site of `target`.
 */
predicate ejbCalls(Callable origin, ForbiddenCallable target, Call call) {
  exists(EJB ejb |
    // `origin` is a `Callable` within an EJB.
    origin = ejb.getASupertype*().getACallable() and
    // There is an EJB call chain from `origin` to the method containing the forbidden call.
    origin = call.getCaller() and
    // `call` is the direct call site of `target`.
    call.getCallee() = target
  )
}

/*
 * Specification of "forbidden callables".
 */

class ForbiddenContainerInterferenceCallable extends ForbiddenCallable {
  ForbiddenContainerInterferenceCallable() {
    this.getDeclaringType().getASupertype*().getSourceDeclaration() instanceof ClassLoaderClass or
    this.getDeclaringType().getASupertype*().getSourceDeclaration() instanceof SecurityManagerClass or
    this instanceof ForbiddenContainerInterferenceMethod
  }
}

class ForbiddenFileCallable extends ForbiddenCallable {
  ForbiddenFileCallable() {
    this.getDeclaringType().getASupertype*().getSourceDeclaration() instanceof FileInputOutputClass
  }
}

class ForbiddenGraphicsCallable extends ForbiddenCallable {
  ForbiddenGraphicsCallable() {
    this.getDeclaringType().getASupertype*().getPackage() instanceof GraphicsPackage
  }
}

class ForbiddenNativeCallable extends ForbiddenCallable {
  ForbiddenNativeCallable() {
    this.isNative() or
    this instanceof ForbiddenNativeCodeMethod
  }
}

class ForbiddenReflectionCallable extends ForbiddenCallable {
  ForbiddenReflectionCallable() {
    this.getDeclaringType().getASupertype*().getPackage() instanceof ReflectionPackage
  }
}

class ForbiddenSecurityConfigurationCallable extends ForbiddenCallable {
  ForbiddenSecurityConfigurationCallable() {
    this.getDeclaringType().getASupertype*().getSourceDeclaration() instanceof SecurityConfigClass
  }
}

class ForbiddenSerializationCallable extends ForbiddenCallable {
  ForbiddenSerializationCallable() { this instanceof ForbiddenSerializationMethod }
}

class ForbiddenSetFactoryCallable extends ForbiddenCallable {
  ForbiddenSetFactoryCallable() { this instanceof ForbiddenSetFactoryMethod }
}

class ForbiddenServerSocketCallable extends ForbiddenCallable {
  ForbiddenServerSocketCallable() {
    this.getDeclaringType().getASupertype*().getSourceDeclaration() instanceof ServerSocketsClass
  }
}

class ForbiddenSynchronizationCallable extends ForbiddenCallable {
  ForbiddenSynchronizationCallable() {
    this.isSynchronized()
    or
    exists(SynchronizedStmt synch | synch.getEnclosingCallable() = this)
    or
    exists(FieldAccess fa | fa.getEnclosingCallable() = this and fa.getField().isVolatile())
    or
    this.getDeclaringType().getPackage() instanceof ConcurrentPackage
  }
}

class ForbiddenStaticFieldCallable extends ForbiddenCallable {
  ForbiddenStaticFieldCallable() { exists(forbiddenStaticFieldUse(this)) }
}

FieldAccess forbiddenStaticFieldUse(Callable c) {
  result.getEnclosingCallable() = c and
  result.getField().isStatic() and
  not result.getField().isFinal()
}

class ForbiddenThreadingCallable extends ForbiddenCallable {
  ForbiddenThreadingCallable() {
    this.getDeclaringType().getASupertype*().getSourceDeclaration() instanceof ThreadingClass
  }
}

class ForbiddenThisCallable extends ForbiddenCallable {
  ForbiddenThisCallable() { exists(forbiddenThisUse(this)) }
}

ThisAccess forbiddenThisUse(Callable c) {
  result.getEnclosingCallable() = c and
  (
    exists(MethodAccess ma | ma.getAnArgument() = result) or
    exists(ReturnStmt rs | rs.getResult() = result)
  )
}

/*
 * Specification of "forbidden packages".
 */

class ReflectionPackage extends Package {
  ReflectionPackage() {
    this.getName() = "java.lang.reflect" or
    this.getName().matches("java.lang.reflect.%")
  }
}

class GraphicsPackage extends Package {
  GraphicsPackage() {
    this.getName() = "java.awt" or
    this.getName().matches("java.awt.%") or
    this.getName() = "javax.swing" or
    this.getName().matches("javax.swing.%")
  }
}

class ConcurrentPackage extends Package {
  ConcurrentPackage() {
    this.getName() = "java.util.concurrent" or
    this.getName().matches("java.util.concurrent.%")
  }
}

/*
 * Specification of "forbidden classes".
 */

class ThreadingClass extends Class {
  ThreadingClass() {
    this.hasQualifiedName("java.lang", "Thread") or
    this.hasQualifiedName("java.lang", "ThreadGroup")
  }
}

class ServerSocketsClass extends Class {
  ServerSocketsClass() {
    this.hasQualifiedName("java.net", "ServerSocket") or
    this.hasQualifiedName("java.net", "MulticastSocket") or
    this.hasQualifiedName("java.nio.channels", "ServerSocketChannel")
  }
}

class SecurityConfigClass extends Class {
  SecurityConfigClass() {
    this.hasQualifiedName("java.security", "Policy") or
    this.hasQualifiedName("java.security", "Security") or
    this.hasQualifiedName("java.security", "Provider") or
    this.hasQualifiedName("java.security", "Signer") or
    this.hasQualifiedName("java.security", "Identity")
  }
}

class ClassLoaderClass extends Class {
  ClassLoaderClass() { this.hasQualifiedName("java.lang", "ClassLoader") }
}

class SecurityManagerClass extends Class {
  SecurityManagerClass() { this.hasQualifiedName("java.lang", "SecurityManager") }
}

class FileInputOutputClass extends Class {
  FileInputOutputClass() {
    this.hasQualifiedName("java.io", "File") or
    this.hasQualifiedName("java.io", "FileDescriptor") or
    this.hasQualifiedName("java.io", "FileInputStream") or
    this.hasQualifiedName("java.io", "FileOutputStream") or
    this.hasQualifiedName("java.io", "RandomAccessFile") or
    this.hasQualifiedName("java.io", "FileReader") or
    this.hasQualifiedName("java.io", "FileWriter") or
    this.hasQualifiedName("java.nio.channels", "FileChannel") or
    this.hasQualifiedName("java.nio.channels", "FileLock")
  }
}

/*
 * Specification of "forbidden methods".
 */

// Forbidden container interference.
class ForbiddenContainerInterferenceMethod extends Method {
  ForbiddenContainerInterferenceMethod() {
    this instanceof SystemExitMethod or
    this instanceof RuntimeExitOrHaltMethod or
    this instanceof RuntimeAddOrRemoveShutdownHookMethod or
    this instanceof SystemSetPrintStreamMethod or
    this instanceof SystemSetInputStreamMethod or
    this instanceof SystemGetSecurityManagerMethod or
    this instanceof SystemSetSecurityManagerMethod or
    this instanceof SystemInheritedChannelMethod
  }
}

class SystemExitMethod extends Method {
  SystemExitMethod() {
    this.hasName("exit") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(PrimitiveType).hasName("int") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

class RuntimeExitOrHaltMethod extends Method {
  RuntimeExitOrHaltMethod() {
    (this.hasName("exit") or this.hasName("halt")) and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(PrimitiveType).hasName("int") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "Runtime")
  }
}

class RuntimeAddOrRemoveShutdownHookMethod extends Method {
  RuntimeAddOrRemoveShutdownHookMethod() {
    (this.hasName("addShutdownHook") or this.hasName("removeShutdownHook")) and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.lang", "Thread") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "Runtime")
  }
}

class SystemSetPrintStreamMethod extends Method {
  SystemSetPrintStreamMethod() {
    (this.hasName("setErr") or this.hasName("setOut")) and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.io", "PrintStream") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

class SystemSetInputStreamMethod extends Method {
  SystemSetInputStreamMethod() {
    this.hasName("setIn") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.io", "InputStream") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

class SystemGetSecurityManagerMethod extends Method {
  SystemGetSecurityManagerMethod() {
    this.hasName("getSecurityManager") and
    this.hasNoParameters() and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

class SystemSetSecurityManagerMethod extends Method {
  SystemSetSecurityManagerMethod() {
    this.hasName("setSecurityManager") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.lang", "SecurityManager") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

class SystemInheritedChannelMethod extends Method {
  SystemInheritedChannelMethod() {
    this.hasName("inheritedChannel") and
    this.hasNoParameters() and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

// Forbidden serialization.
class ForbiddenSerializationMethod extends Method {
  ForbiddenSerializationMethod() {
    this instanceof EnableReplaceObjectMethod or
    this instanceof ReplaceObjectMethod or
    this instanceof EnableResolveObjectMethod or
    this instanceof ResolveObjectMethod or
    this instanceof ResolveClassMethod or
    this instanceof ResolveProxyClassMethod
  }
}

class EnableReplaceObjectMethod extends Method {
  EnableReplaceObjectMethod() {
    this.hasName("enableReplaceObject") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(PrimitiveType).hasName("boolean") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.io", "ObjectOutputStream")
  }
}

class ReplaceObjectMethod extends Method {
  ReplaceObjectMethod() {
    this.hasName("replaceObject") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeObject and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.io", "ObjectOutputStream")
  }
}

class EnableResolveObjectMethod extends Method {
  EnableResolveObjectMethod() {
    this.hasName("enableResolveObject") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(PrimitiveType).hasName("boolean") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.io", "ObjectInputStream")
  }
}

class ResolveObjectMethod extends Method {
  ResolveObjectMethod() {
    this.hasName("resolveObject") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeObject and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.io", "ObjectInputStream")
  }
}

class ResolveClassMethod extends Method {
  ResolveClassMethod() {
    this.hasName("resolveClass") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.io", "ObjectStreamClass") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.io", "ObjectInputStream")
  }
}

class ResolveProxyClassMethod extends Method {
  ResolveProxyClassMethod() {
    this.hasName("resolveProxyClass") and
    this.getNumberOfParameters() = 1 and
    this
        .getParameter(0)
        .getType()
        .(Array)
        .getComponentType()
        .(RefType)
        .hasQualifiedName("java.lang", "String") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.io", "ObjectInputStream")
  }
}

// Forbidden "set factory" methods.
class ForbiddenSetFactoryMethod extends Method {
  ForbiddenSetFactoryMethod() {
    this instanceof SetSocketFactoryMethod or
    this instanceof SetSocketImplFactoryMethod or
    this instanceof SetUrlStreamHandlerFactoryMethod
  }
}

class SetSocketFactoryMethod extends Method {
  SetSocketFactoryMethod() {
    this.hasName("setSocketFactory") and
    this.getNumberOfParameters() = 1 and
    this
        .getParameter(0)
        .getType()
        .(RefType)
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "SocketImplFactory") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "ServerSocket")
  }
}

class SetSocketImplFactoryMethod extends Method {
  SetSocketImplFactoryMethod() {
    this.hasName("setSocketImplFactory") and
    this.getNumberOfParameters() = 1 and
    this
        .getParameter(0)
        .getType()
        .(RefType)
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "SocketImplFactory") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "Socket")
  }
}

class SetUrlStreamHandlerFactoryMethod extends Method {
  SetUrlStreamHandlerFactoryMethod() {
    this.hasName("setURLStreamHandlerFactory") and
    this.getNumberOfParameters() = 1 and
    this
        .getParameter(0)
        .getType()
        .(RefType)
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "URLStreamHandlerFactory") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "URL")
  }
}

// Forbidden native code methods.
class ForbiddenNativeCodeMethod extends Method {
  ForbiddenNativeCodeMethod() {
    this instanceof SystemOrRuntimeLoadLibraryMethod or
    this instanceof RuntimeExecMethod
  }
}

class SystemOrRuntimeLoadLibraryMethod extends Method {
  SystemOrRuntimeLoadLibraryMethod() {
    (this.hasName("load") or this.hasName("loadLibrary")) and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.lang", "String") and
    (
      this
          .getDeclaringType()
          .getASupertype*()
          .getSourceDeclaration()
          .hasQualifiedName("java.lang", "System") or
      this
          .getDeclaringType()
          .getASupertype*()
          .getSourceDeclaration()
          .hasQualifiedName("java.lang", "Runtime")
    )
  }
}

class RuntimeExecMethod extends Method {
  RuntimeExecMethod() {
    this.hasName("exec") and
    this
        .getDeclaringType()
        .getASupertype*()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "Runtime")
  }
}
