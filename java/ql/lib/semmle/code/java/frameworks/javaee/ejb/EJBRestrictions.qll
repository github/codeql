/**
 * Provides classes and predicates for modeling
 * EJB Programming Restrictions (see EJB 3.0 specification, section 21.1.2).
 */

import java
import EJB

/** A method or constructor that may not be called from an EJB. */
abstract class ForbiddenCallable extends Callable { }

/**
 * Holds if there exists a call chain from an EJB-`Callable` `origin` to a `ForbiddenCallable` `target`
 * that does not contain any intermediate EJB-`Callable` or `ForbiddenCallable`,
 * and where `call` is the direct call site of `target`.
 */
predicate ejbCalls(Callable origin, ForbiddenCallable target, Call call) {
  exists(EJB ejb |
    // `origin` is a `Callable` within an EJB.
    origin = ejb.getAnAncestor().getACallable() and
    // There is an EJB call chain from `origin` to the method containing the forbidden call.
    origin = call.getCaller() and
    // `call` is the direct call site of `target`.
    call.getCallee() = target
  )
}

/*
 * Specification of "forbidden callables".
 */

/** A method or constructor that may not be called by an EJB due to container interference. */
class ForbiddenContainerInterferenceCallable extends ForbiddenCallable {
  ForbiddenContainerInterferenceCallable() {
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof ClassLoaderClass or
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof SecurityManagerClass or
    this instanceof ForbiddenContainerInterferenceMethod
  }
}

/** A method or constructor involving file input or output that may not be called by an EJB. */
class ForbiddenFileCallable extends ForbiddenCallable {
  ForbiddenFileCallable() {
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof FileInputOutputClass
  }
}

/** A method or constructor involving graphics operations that may not be called by an EJB. */
class ForbiddenGraphicsCallable extends ForbiddenCallable {
  ForbiddenGraphicsCallable() {
    this.getDeclaringType().getAnAncestor().getPackage() instanceof GraphicsPackage
  }
}

/** A method or constructor involving native code that may not be called by an EJB. */
class ForbiddenNativeCallable extends ForbiddenCallable {
  ForbiddenNativeCallable() {
    this.isNative() or
    this instanceof ForbiddenNativeCodeMethod
  }
}

/** A method or constructor involving reflection that may not be called by and EJB. */
class ForbiddenReflectionCallable extends ForbiddenCallable {
  ForbiddenReflectionCallable() {
    this.getDeclaringType().getAnAncestor().getPackage() instanceof ReflectionPackage
  }
}

/** A method or constructor involving security configuration that may not be called by an EJB. */
class ForbiddenSecurityConfigurationCallable extends ForbiddenCallable {
  ForbiddenSecurityConfigurationCallable() {
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof SecurityConfigClass
  }
}

/** A method or constructor involving serialization that may not be called by an EJB. */
class ForbiddenSerializationCallable extends ForbiddenCallable instanceof ForbiddenSerializationMethod
{ }

/** A method or constructor involving network factory operations that may not be called by an EJB. */
class ForbiddenSetFactoryCallable extends ForbiddenCallable instanceof ForbiddenSetFactoryMethod { }

/** A method or constructor involving server socket operations that may not be called by an EJB. */
class ForbiddenServerSocketCallable extends ForbiddenCallable {
  ForbiddenServerSocketCallable() {
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof ServerSocketsClass
  }
}

/** A method or constructor involving synchronization that may not be called by an EJB. */
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

/** A method or constructor involving static field access that may not be called by an EJB. */
class ForbiddenStaticFieldCallable extends ForbiddenCallable {
  ForbiddenStaticFieldCallable() { exists(forbiddenStaticFieldUse(this)) }
}

/**
 * Gets an access to a non-final static field in callable `c`
 * that is disallowed by the EJB specification.
 */
FieldAccess forbiddenStaticFieldUse(Callable c) {
  result.getEnclosingCallable() = c and
  result.getField().isStatic() and
  not result.getField().isFinal()
}

/** A method or constructor involving thread operations that may not be called by an EJB. */
class ForbiddenThreadingCallable extends ForbiddenCallable {
  ForbiddenThreadingCallable() {
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof ThreadingClass
  }
}

/** A method or constructor referencing `this` that may not be called by an EJB. */
class ForbiddenThisCallable extends ForbiddenCallable {
  ForbiddenThisCallable() { exists(forbiddenThisUse(this)) }
}

/**
 * Gets an access to `this` in callable `c`
 * that is disallowed by the EJB specification.
 */
ThisAccess forbiddenThisUse(Callable c) {
  result.getEnclosingCallable() = c and
  (
    exists(MethodCall ma | ma.getAnArgument() = result) or
    exists(ReturnStmt rs | rs.getResult() = result)
  )
}

/*
 * Specification of "forbidden packages".
 */

/** The package `java.lang.reflect` or a subpackage thereof. */
class ReflectionPackage extends Package {
  ReflectionPackage() {
    this.getName() = "java.lang.reflect" or
    this.getName().matches("java.lang.reflect.%")
  }
}

/** The package `java.awt` or `javax.swing` or a subpackage thereof. */
class GraphicsPackage extends Package {
  GraphicsPackage() {
    this.getName() = "java.awt" or
    this.getName().matches("java.awt.%") or
    this.getName() = "javax.swing" or
    this.getName().matches("javax.swing.%")
  }
}

/** The package `java.util.concurrent` or a subpackage thereof. */
class ConcurrentPackage extends Package {
  ConcurrentPackage() {
    this.getName() = "java.util.concurrent" or
    this.getName().matches("java.util.concurrent.%")
  }
}

/*
 * Specification of "forbidden classes".
 */

/** The class `java.lang.Thread` or `java.lang.ThreadGroup`. */
class ThreadingClass extends Class {
  ThreadingClass() {
    this.hasQualifiedName("java.lang", "Thread") or
    this.hasQualifiedName("java.lang", "ThreadGroup")
  }
}

/**
 * The class `java.net.ServerSocket`, `java.net.MulticastSocket`
 * or `java.nio.channels.ServerSocketChannel`.
 */
class ServerSocketsClass extends Class {
  ServerSocketsClass() {
    this.hasQualifiedName("java.net", "ServerSocket") or
    this.hasQualifiedName("java.net", "MulticastSocket") or
    this.hasQualifiedName("java.nio.channels", "ServerSocketChannel")
  }
}

/**
 * A class in the package `java.security` named `Policy`,
 * `Security`, `Provider`, `Signer` or `Identity`.
 */
class SecurityConfigClass extends Class {
  SecurityConfigClass() {
    this.hasQualifiedName("java.security", "Policy") or
    this.hasQualifiedName("java.security", "Security") or
    this.hasQualifiedName("java.security", "Provider") or
    this.hasQualifiedName("java.security", "Signer") or
    this.hasQualifiedName("java.security", "Identity")
  }
}

/** The class `java.lang.ClassLoader`. */
class ClassLoaderClass extends Class {
  ClassLoaderClass() { this.hasQualifiedName("java.lang", "ClassLoader") }
}

/** The class `java.lang.SecurityManager`. */
class SecurityManagerClass extends Class {
  SecurityManagerClass() { this.hasQualifiedName("java.lang", "SecurityManager") }
}

/** A class involving file input or output. */
class FileInputOutputClass extends Class {
  FileInputOutputClass() {
    this instanceof TypeFile or
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

/** A method that may cause EJB container interference. */
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

/**
 * A method named `exit` declared in
 * the class `java.lang.System`.
 */
class SystemExitMethod extends Method {
  SystemExitMethod() {
    this.hasName("exit") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(PrimitiveType).hasName("int") and
    this.getDeclaringType()
        .getAnAncestor()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

/**
 * A method named `exit` or `halt` declared in
 * the class `java.lang.Runtime` or a subclass thereof.
 */
class RuntimeExitOrHaltMethod extends Method {
  RuntimeExitOrHaltMethod() {
    (this.hasName("exit") or this.hasName("halt")) and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(PrimitiveType).hasName("int") and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeRuntime
  }
}

/**
 * A method named `addShutdownHook` or `removeShutdownHook` declared in
 * the class `java.lang.Runtime` or a subclass thereof.
 */
class RuntimeAddOrRemoveShutdownHookMethod extends Method {
  RuntimeAddOrRemoveShutdownHookMethod() {
    (this.hasName("addShutdownHook") or this.hasName("removeShutdownHook")) and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.lang", "Thread") and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeRuntime
  }
}

/**
 * A method named `setErr` or `setOut` declared in
 * the class `java.lang.System`.
 */
class SystemSetPrintStreamMethod extends Method {
  SystemSetPrintStreamMethod() {
    (this.hasName("setErr") or this.hasName("setOut")) and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.io", "PrintStream") and
    this.getDeclaringType()
        .getAnAncestor()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

/**
 * A method named `setIn` declared in
 * the class `java.lang.System`.
 */
class SystemSetInputStreamMethod extends Method {
  SystemSetInputStreamMethod() {
    this.hasName("setIn") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeInputStream and
    this.getDeclaringType()
        .getAnAncestor()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

/**
 * A method named `getSecurityManager` declared in
 * the class `java.lang.System`.
 */
class SystemGetSecurityManagerMethod extends Method {
  SystemGetSecurityManagerMethod() {
    this.hasName("getSecurityManager") and
    this.hasNoParameters() and
    this.getDeclaringType()
        .getAnAncestor()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

/**
 * A method named `setSecurityManager` declared in
 * the class `java.lang.System`.
 */
class SystemSetSecurityManagerMethod extends Method {
  SystemSetSecurityManagerMethod() {
    this.hasName("setSecurityManager") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.lang", "SecurityManager") and
    this.getDeclaringType()
        .getAnAncestor()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

/**
 * A method named `inheritedChannel` declared in
 * the class `java.lang.System`.
 */
class SystemInheritedChannelMethod extends Method {
  SystemInheritedChannelMethod() {
    this.hasName("inheritedChannel") and
    this.hasNoParameters() and
    this.getDeclaringType()
        .getAnAncestor()
        .getSourceDeclaration()
        .hasQualifiedName("java.lang", "System")
  }
}

/** A method involving serialization that may not be called from an EJB. */
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

/**
 * A method named `enableReplaceObject` declared in
 * the class `java.io.ObjectOutputStream` or a subclass thereof.
 */
class EnableReplaceObjectMethod extends Method {
  EnableReplaceObjectMethod() {
    this.hasName("enableReplaceObject") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(PrimitiveType).hasName("boolean") and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeObjectOutputStream
  }
}

/**
 * A method named `replaceObject` declared in
 * the class `java.io.ObjectOutputStream` or a subclass thereof.
 */
class ReplaceObjectMethod extends Method {
  ReplaceObjectMethod() {
    this.hasName("replaceObject") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeObject and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeObjectOutputStream
  }
}

/**
 * A method named `enableResolveObject` declared in
 * the class `java.io.ObjectInputStream` or a subclass thereof.
 */
class EnableResolveObjectMethod extends Method {
  EnableResolveObjectMethod() {
    this.hasName("enableResolveObject") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(PrimitiveType).hasName("boolean") and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeObjectInputStream
  }
}

/**
 * A method named `resolveObject` declared in
 * the class `java.io.ObjectInputStream` or a subclass thereof.
 */
class ResolveObjectMethod extends Method {
  ResolveObjectMethod() {
    this.hasName("resolveObject") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeObject and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeObjectInputStream
  }
}

/**
 * A method named `resolveClass` declared in
 * the class `java.io.ObjectInputStream` or a subclass thereof.
 */
class ResolveClassMethod extends Method {
  ResolveClassMethod() {
    this.hasName("resolveClass") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.io", "ObjectStreamClass") and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeObjectInputStream
  }
}

/**
 * A method named `resolveProxyClass` declared in
 * the class `java.io.ObjectInputStream` or a subclass thereof.
 */
class ResolveProxyClassMethod extends Method {
  ResolveProxyClassMethod() {
    this.hasName("resolveProxyClass") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(Array).getComponentType() instanceof TypeString and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeObjectInputStream
  }
}

/** A method involving network factory operations that may not be called from an EJB. */
class ForbiddenSetFactoryMethod extends Method {
  ForbiddenSetFactoryMethod() {
    this instanceof SetSocketFactoryMethod or
    this instanceof SetSocketImplFactoryMethod or
    this instanceof SetUrlStreamHandlerFactoryMethod
  }
}

/**
 * A method named `setSocketFactory` declared in
 * the class `java.net.ServerSocket` or a subclass thereof.
 */
class SetSocketFactoryMethod extends Method {
  SetSocketFactoryMethod() {
    this.hasName("setSocketFactory") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0)
        .getType()
        .(RefType)
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "SocketImplFactory") and
    this.getDeclaringType()
        .getAnAncestor()
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "ServerSocket")
  }
}

/**
 * A method named `setSocketImplFactory` declared in
 * the class `java.net.Socket` or a subclass thereof.
 */
class SetSocketImplFactoryMethod extends Method {
  SetSocketImplFactoryMethod() {
    this.hasName("setSocketImplFactory") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0)
        .getType()
        .(RefType)
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "SocketImplFactory") and
    this.getDeclaringType()
        .getAnAncestor()
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "Socket")
  }
}

/**
 * A method named `setURLStreamHandlerFactory` declared in
 * the class `java.net.URL` or a subclass thereof.
 */
class SetUrlStreamHandlerFactoryMethod extends Method {
  SetUrlStreamHandlerFactoryMethod() {
    this.hasName("setURLStreamHandlerFactory") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0)
        .getType()
        .(RefType)
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "URLStreamHandlerFactory") and
    this.getDeclaringType()
        .getAnAncestor()
        .getSourceDeclaration()
        .hasQualifiedName("java.net", "URL")
  }
}

/** A method involving native code that may not be called by an EJB. */
class ForbiddenNativeCodeMethod extends Method {
  ForbiddenNativeCodeMethod() {
    this instanceof SystemOrRuntimeLoadLibraryMethod or
    this instanceof RuntimeExecMethod
  }
}

/**
 * A method named `load` or `loadLibrary` declared in the class
 * `java.lang.System` or `java.lang.Runtime` or a subclass thereof.
 */
class SystemOrRuntimeLoadLibraryMethod extends Method {
  SystemOrRuntimeLoadLibraryMethod() {
    (this.hasName("load") or this.hasName("loadLibrary")) and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeString and
    (
      this.getDeclaringType()
          .getAnAncestor()
          .getSourceDeclaration()
          .hasQualifiedName("java.lang", "System") or
      this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeRuntime
    )
  }
}

/**
 * A method named `exec` declared in the class
 * `java.lang.Runtime` or in a subclass thereof.
 */
class RuntimeExecMethod extends Method {
  RuntimeExecMethod() {
    this.hasName("exec") and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration() instanceof TypeRuntime
  }
}
