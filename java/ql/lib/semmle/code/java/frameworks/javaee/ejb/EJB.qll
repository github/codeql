/** Provides classes and predicates for working with Enterprise Java Beans. */

import java
import EJBJarXML

/**
 * Common superclass for various kinds of EJBs.
 */
abstract class EJB extends Class {
  /** Gets a `Callable` that is directly or indirectly called from within the EJB. */
  Callable getAUsedCallable() { this.getACallable().polyCalls*(result) }
}

/**
 * A session EJB.
 */
class SessionEjb extends EJB {
  SessionEjb() {
    // Subtype of `javax.ejb.SessionBean`.
    this instanceof SessionBean or
    // EJB annotations.
    this.getAnAnnotation().getType().hasName("Stateless") or
    this.getAnAnnotation().getType().hasName("Stateful") or
    // XML deployment descriptor.
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getASessionElement().getAnEjbClassElement().getACharactersSet().getCharacters()
    )
  }

  /** Any business interface of this EJB. */
  Interface getABusinessInterface() {
    // Either the EJB does not declare any business interfaces explicitly
    // and implements a single interface candidate,
    // which is then considered to be the business interface...
    count(this.getAnExplicitBusinessInterface()) = 0 and
    count(this.getAnImplementedBusinessInterfaceCandidate()) = 1 and
    result = this.getAnImplementedBusinessInterfaceCandidate()
    or
    // ...or each business interface needs to be declared explicitly.
    (
      count(this.getAnImplementedBusinessInterfaceCandidate()) != 1 or
      count(this.getAnExplicitBusinessInterface()) != 0
    ) and
    result = this.getAnExplicitBusinessInterface()
  }

  /**
   * Any business interfaces that are declared explicitly
   * using either an annotation or an XML deployment descriptor.
   */
  private BusinessInterface getAnExplicitBusinessInterface() {
    result.(AnnotatedBusinessInterface).getAnEjb() = this or
    result.(XmlSpecifiedBusinessInterface).getAnEjb() = this
  }

  /**
   * Any implemented interfaces that are not explicitly excluded
   * from being a business interface by the EJB 3.0 specification.
   */
  private Interface getAnImplementedBusinessInterfaceCandidate() {
    result = this.getASupertype() and
    not result.hasQualifiedName("java.io", "Serializable") and
    not result.hasQualifiedName("java.io", "Externalizable") and
    not result.getPackage().getName() = "javax.ejb"
  }

  /** Any remote interfaces of this EJB. */
  LegacyEjbRemoteInterface getARemoteInterface() {
    result = this.getASupertype() and result instanceof ExtendedRemoteInterface
    or
    exists(AnnotatedRemoteHomeInterface i | i.getAnEjb() = this |
      result = i.getAnAssociatedRemoteInterface()
    )
    or
    result.(XmlSpecifiedRemoteInterface).getAnEjb() = this
  }

  /** Any remote home interfaces of this EJB. */
  LegacyEjbRemoteHomeInterface getARemoteHomeInterface() {
    result = this.getASupertype() and result instanceof ExtendedRemoteHomeInterface
    or
    result.(AnnotatedRemoteHomeInterface).getAnEjb() = this
    or
    result.(XmlSpecifiedRemoteHomeInterface).getAnEjb() = this
  }

  /** Any local interfaces of this EJB. */
  LegacyEjbLocalInterface getALocalInterface() {
    result = this.getASupertype() and result instanceof ExtendedLocalInterface
    or
    exists(AnnotatedLocalHomeInterface i | i.getAnEjb() = this |
      result = i.getAnAssociatedLocalInterface()
    )
    or
    result.(XmlSpecifiedLocalInterface).getAnEjb() = this
  }

  /** Any local home interfaces of this EJB. */
  LegacyEjbLocalHomeInterface getALocalHomeInterface() {
    result = this.getASupertype() and result instanceof ExtendedLocalHomeInterface
    or
    result.(AnnotatedLocalHomeInterface).getAnEjb() = this
    or
    result.(XmlSpecifiedLocalHomeInterface).getAnEjb() = this
  }

  /** Any `ejbCreate*` methods required for legacy remote or local home interfaces. */
  EjbCreateMethod getAnEjbCreateMethod() { this.inherits(result) }

  /** Any `@Init` methods required for `@RemoteHome` or `@LocalHome` legacy interfaces. */
  EjbAnnotatedInitMethod getAnAnnotatedInitMethod() { this.inherits(result) }
}

/**
 * A stateful session EJB.
 */
class StatefulSessionEjb extends SessionEjb {
  StatefulSessionEjb() {
    // EJB annotations.
    this.getAnAnnotation().getType().hasName("Stateful")
    or
    // XML deployment descriptor.
    exists(EjbJarXmlFile f, EjbJarSessionElement se |
      se = f.getASessionElement() and
      this.getQualifiedName() = se.getAnEjbClassElement().getACharactersSet().getCharacters() and
      se.getASessionTypeElement().isStateful()
    )
  }
}

/**
 * A stateless session EJB.
 */
class StatelessSessionEjb extends SessionEjb {
  StatelessSessionEjb() {
    // EJB annotations.
    this.getAnAnnotation().getType().hasName("Stateless")
    or
    // XML deployment descriptor.
    exists(EjbJarXmlFile f, EjbJarSessionElement se |
      se = f.getASessionElement() and
      this.getQualifiedName() = se.getAnEjbClassElement().getACharactersSet().getCharacters() and
      se.getASessionTypeElement().isStateless()
    )
  }
}

/**
 * A message-driven EJB.
 */
class MessageDrivenBean extends EJB {
  MessageDrivenBean() {
    // Subtype of `javax.ejb.MessageBean`.
    this instanceof MessageBean
    or
    // EJB annotations.
    this.getAnAnnotation().getType().hasName("MessageDriven")
    or
    // XML deployment descriptor.
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getAMessageDrivenElement().getAnEjbClassElement().getACharactersSet().getCharacters()
    )
  }
}

/**
 * An entity EJB (deprecated as of EJB 3.0).
 */
class EntityEjb extends EJB {
  EntityEjb() {
    // Subtype of `javax.ejb.EntityBean`.
    this instanceof EntityBean
    or
    // XML deployment descriptor.
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getAnEntityElement().getAnEjbClassElement().getACharactersSet().getCharacters()
    )
  }
}

/*
 * Business interfaces (applicable to session beans).
 */

/**
 * Common superclass representing EJB interface annotations with a "value" element.
 */
abstract class EjbInterfaceAnnotation extends Annotation {
  /**
   * Gets a type named within the "value" element of this annotation.
   *
   * For example, types `Foo` and `Bar` are named within `@Remote({Foo.class, Bar.class})`.
   */
  RefType getANamedType() {
    // Returns the type `Foo` of any type literal `Foo.class` occurring
    // within the "value" element of this annotation.
    // Uses `getAChildExpr*()` since the "value" element can have type `Class` or `Class[]`.
    exists(TypeLiteral tl | tl = this.getValue("value").getAChildExpr*() |
      result = tl.getReferencedType()
    )
  }
}

/**
 * Common superclass representing a `@Remote` or `@Local` annotation
 * used to declare a remote or local business interface.
 */
abstract class BusinessInterfaceAnnotation extends EjbInterfaceAnnotation { }

/**
 * An instance of a `@Remote` annotation.
 */
class RemoteAnnotation extends BusinessInterfaceAnnotation {
  RemoteAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Remote") }
}

/**
 * An instance of a `@Local` annotation.
 */
class LocalAnnotation extends BusinessInterfaceAnnotation {
  LocalAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Local") }
}

/**
 * Common superclass representing all local and remote business interfaces,
 * which can be designated either using annotations or within an
 * XML deployment descriptor (`ejb-jar.xml`) file.
 */
abstract class BusinessInterface extends Interface {
  /** Gets an EJB to which this business interface belongs. */
  abstract SessionEjb getAnEjb();

  /** Holds if this business interface is declared local. */
  abstract predicate isDeclaredLocal();

  /** Holds if this business interface is declared remote. */
  abstract predicate isDeclaredRemote();
}

/**
 * A business interface declared using an XML deployment descriptor (`ejb-jar.xml`) file.
 */
class XmlSpecifiedBusinessInterface extends BusinessInterface {
  XmlSpecifiedBusinessInterface() {
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getASessionElement().getABusinessElement().getACharactersSet().getCharacters()
    )
  }

  override SessionEjb getAnEjb() {
    exists(EjbJarXmlFile f, EjbJarSessionElement se |
      se = f.getASessionElement() and
      this.getQualifiedName() = se.getABusinessElement().getACharactersSet().getCharacters() and
      result.getQualifiedName() = se.getAnEjbClassElement().getACharactersSet().getCharacters()
    )
  }

  override predicate isDeclaredLocal() {
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getASessionElement().getABusinessLocalElement().getACharactersSet().getCharacters()
    )
  }

  override predicate isDeclaredRemote() {
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getASessionElement().getABusinessRemoteElement().getACharactersSet().getCharacters()
    )
  }
}

/**
 * A business interface annotated with `@Local` or `@Remote` or
 * named within a `@Local` or `@Remote` annotation of another type.
 */
class AnnotatedBusinessInterface extends BusinessInterface {
  AnnotatedBusinessInterface() {
    // An interface annotated as `@Remote` or `@Local`.
    this.getAnAnnotation() instanceof BusinessInterfaceAnnotation
    or
    // An interface named within a `@Local` or `@Remote` annotation of another type.
    exists(BusinessInterfaceAnnotation a | a.getANamedType() = this)
  }

  /**
   * Any class that has a `@Local` or `@Remote` annotation that names this interface
   * is an EJB to which this business interface belongs.
   */
  override SessionEjb getAnEjb() {
    result.getAnAnnotation().(BusinessInterfaceAnnotation).getANamedType() = this
  }

  override predicate isDeclaredLocal() { this instanceof LocalAnnotatedBusinessInterface }

  override predicate isDeclaredRemote() { this instanceof RemoteAnnotatedBusinessInterface }
}

/**
 * A remote business interface declared using the `@Remote` annotation.
 */
class RemoteAnnotatedBusinessInterface extends AnnotatedBusinessInterface {
  RemoteAnnotatedBusinessInterface() {
    this.getAnAnnotation() instanceof RemoteAnnotation or
    exists(RemoteAnnotation a | a.getANamedType() = this)
  }
}

/**
 * A local business interface declared using the `@Local` annotation.
 */
class LocalAnnotatedBusinessInterface extends AnnotatedBusinessInterface {
  LocalAnnotatedBusinessInterface() {
    this.getAnAnnotation() instanceof LocalAnnotation or
    exists(LocalAnnotation a | a.getANamedType() = this)
  }
}

/*
 * Init and create methods for session beans.
 */

/**
 * A `@javax.ejb.Init` annotation.
 */
class InitAnnotation extends Annotation {
  InitAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Init") }
}

/**
 * A method annotated with a `@javax.ejb.Init` annotation
 * that is declared in or inherited by a session EJB.
 */
class EjbAnnotatedInitMethod extends Method {
  EjbAnnotatedInitMethod() {
    this.getAnAnnotation() instanceof InitAnnotation and
    exists(SessionEjb ejb | ejb.inherits(this))
  }
}

/**
 * A method whose name starts with `ejbCreate` that is
 * declared in or inherited by a session EJB.
 */
class EjbCreateMethod extends Method {
  EjbCreateMethod() {
    this.getName().matches("ejbCreate%") and
    exists(SessionEjb ejb | ejb.inherits(this))
  }

  /** Gets the suffix of the method name without the `ejbCreate` prefix. */
  string getMethodSuffix() { result = this.getName().substring(9, this.getName().length()) }
}

/**
 * A method whose name starts with `create` that is
 * declared in or inherited by a legacy EJB home interface.
 */
class EjbInterfaceCreateMethod extends Method {
  EjbInterfaceCreateMethod() {
    this.getName().matches("create%") and
    exists(LegacyEjbHomeInterface i | i.inherits(this))
  }

  /** Gets the suffix of the method name without the `create` prefix. */
  string getMethodSuffix() { result = this.getName().substring(6, this.getName().length()) }
}

/*
 * Legacy interfaces (for backwards compatibility, prior to EJB 3.0).
 */

/** Common superclass for `@RemoteHome` and `@LocalHome` annotations. */
abstract class HomeAnnotation extends EjbInterfaceAnnotation { }

/**
 * An instance of a `@RemoteHome` annotation.
 */
class RemoteHomeAnnotation extends HomeAnnotation {
  RemoteHomeAnnotation() { this.getType().hasQualifiedName("javax.ejb", "RemoteHome") }
}

/**
 * An instance of a `@LocalHome` annotation.
 */
class LocalHomeAnnotation extends HomeAnnotation {
  LocalHomeAnnotation() { this.getType().hasQualifiedName("javax.ejb", "LocalHome") }
}

/**
 * Common superclass for legacy EJB interfaces (prior to EJB 3.0).
 */
abstract class LegacyEjbInterface extends Interface { }

/** Common superclass for legacy EJB remote home and local home interfaces. */
abstract class LegacyEjbHomeInterface extends LegacyEjbInterface {
  /** Any `create*` method of this (remote or local) home interface. */
  EjbInterfaceCreateMethod getACreateMethod() { this.inherits(result) }
}

/** A legacy remote interface. */
abstract class LegacyEjbRemoteInterface extends LegacyEjbInterface { }

/** A legacy remote interface that extends `javax.ejb.EjbObject`. */
class ExtendedRemoteInterface extends LegacyEjbRemoteInterface, RemoteEjbInterface { }

/** A legacy remote interface specified within an XML deployment descriptor. */
class XmlSpecifiedRemoteInterface extends LegacyEjbRemoteInterface {
  XmlSpecifiedRemoteInterface() {
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getASessionElement().getARemoteElement().getACharactersSet().getCharacters()
    )
  }

  /**
   * Gets a session EJB specified in the XML deployment descriptor
   * for this legacy EJB remote interface.
   */
  SessionEjb getAnEjb() {
    exists(EjbJarXmlFile f, EjbJarSessionElement se |
      se = f.getASessionElement() and
      this.getQualifiedName() = se.getARemoteElement().getACharactersSet().getCharacters() and
      result.getQualifiedName() = se.getAnEjbClassElement().getACharactersSet().getCharacters()
    )
  }
}

/** A legacy remote home interface. */
abstract class LegacyEjbRemoteHomeInterface extends LegacyEjbHomeInterface { }

/** A legacy remote home interface that extends `javax.ejb.EjbHome`. */
class ExtendedRemoteHomeInterface extends LegacyEjbRemoteHomeInterface, RemoteEjbHomeInterface { }

/** A legacy remote home interface specified by means of a `@RemoteHome` annotation. */
class AnnotatedRemoteHomeInterface extends LegacyEjbRemoteHomeInterface {
  AnnotatedRemoteHomeInterface() {
    // An interface named within a `@RemoteHome` annotation of another type.
    exists(RemoteHomeAnnotation a | a.getANamedType() = this)
  }

  /** Gets an EJB to which this interface belongs. */
  SessionEjb getAnEjb() { result.getAnAnnotation().(RemoteHomeAnnotation).getANamedType() = this }

  /** Gets a remote interface associated with this legacy remote home interface. */
  Interface getAnAssociatedRemoteInterface() { result = this.getACreateMethod().getReturnType() }
}

/** A legacy remote home interface specified within an XML deployment descriptor. */
class XmlSpecifiedRemoteHomeInterface extends LegacyEjbRemoteHomeInterface {
  XmlSpecifiedRemoteHomeInterface() {
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getASessionElement().getARemoteHomeElement().getACharactersSet().getCharacters()
    )
  }

  /** Gets an EJB to which this interface belongs. */
  SessionEjb getAnEjb() {
    exists(EjbJarXmlFile f, EjbJarSessionElement se |
      se = f.getASessionElement() and
      this.getQualifiedName() = se.getARemoteHomeElement().getACharactersSet().getCharacters() and
      result.getQualifiedName() = se.getAnEjbClassElement().getACharactersSet().getCharacters()
    )
  }
}

/** A legacy local interface. */
abstract class LegacyEjbLocalInterface extends LegacyEjbInterface { }

/** A legacy local interface that extends `javax.ejb.EJBLocalObject`. */
class ExtendedLocalInterface extends LegacyEjbLocalInterface, LocalEjbInterface { }

/** A legacy local interface specified within an XML deployment descriptor. */
class XmlSpecifiedLocalInterface extends LegacyEjbLocalInterface {
  XmlSpecifiedLocalInterface() {
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getASessionElement().getALocalElement().getACharactersSet().getCharacters()
    )
  }

  /** Gets an EJB to which this interface belongs. */
  SessionEjb getAnEjb() {
    exists(EjbJarXmlFile f, EjbJarSessionElement se |
      se = f.getASessionElement() and
      this.getQualifiedName() = se.getALocalElement().getACharactersSet().getCharacters() and
      result.getQualifiedName() = se.getAnEjbClassElement().getACharactersSet().getCharacters()
    )
  }
}

/** A legacy local home interface. */
abstract class LegacyEjbLocalHomeInterface extends LegacyEjbHomeInterface { }

/** A legacy local home interface that extends `javax.ejb.EJBLocalHome`. */
class ExtendedLocalHomeInterface extends LegacyEjbLocalHomeInterface, LocalEjbHomeInterface { }

/** A legacy local home interface specified by means of a `@LocalHome` annotation. */
class AnnotatedLocalHomeInterface extends LegacyEjbLocalHomeInterface {
  AnnotatedLocalHomeInterface() {
    // An interface named within a `@LocalHome` annotation of another type.
    exists(LocalHomeAnnotation a | a.getANamedType() = this)
  }

  /** Gets an EJB to which this interface belongs. */
  SessionEjb getAnEjb() { result.getAnAnnotation().(LocalHomeAnnotation).getANamedType() = this }

  /** Gets a local interface associated with this legacy local home interface. */
  Interface getAnAssociatedLocalInterface() { result = this.getACreateMethod().getReturnType() }
}

/** A legacy local home interface specified within an XML deployment descriptor. */
class XmlSpecifiedLocalHomeInterface extends LegacyEjbLocalHomeInterface {
  XmlSpecifiedLocalHomeInterface() {
    exists(EjbJarXmlFile f |
      this.getQualifiedName() =
        f.getASessionElement().getALocalHomeElement().getACharactersSet().getCharacters()
    )
  }

  /** Gets an EJB to which this interface belongs. */
  SessionEjb getAnEjb() {
    exists(EjbJarXmlFile f, EjbJarSessionElement se |
      se = f.getASessionElement() and
      this.getQualifiedName() = se.getALocalHomeElement().getACharactersSet().getCharacters() and
      result.getQualifiedName() = se.getAnEjbClassElement().getACharactersSet().getCharacters()
    )
  }
}

/**
 * A `RemoteInterface` is either a remote business interface
 * or a legacy remote interface.
 */
class RemoteInterface extends Interface {
  RemoteInterface() {
    this instanceof RemoteAnnotatedBusinessInterface or
    this.(XmlSpecifiedBusinessInterface).isDeclaredRemote() or
    exists(SessionEjb ejb | this = ejb.getARemoteInterface())
  }

  /**
   * Any EJBs associated with this `RemoteInterface`
   * by means of annotations or `ejb-jar.xml` configuration files.
   */
  SessionEjb getAnEjb() {
    result.getAnAnnotation().(RemoteAnnotation).getANamedType() = this or
    result = this.(XmlSpecifiedRemoteInterface).getAnEjb() or
    result.getARemoteInterface() = this
  }

  /**
   * A "remote method" is a method that is available on the remote
   * interface (either because it's declared or inherited).
   */
  Method getARemoteMethod() { this.inherits(result) }

  /** Gets a remote method implementation for this remote interface. */
  Method getARemoteMethodImplementation() {
    result = this.getARemoteMethodImplementationChecked() or
    result = this.getARemoteMethodImplementationUnchecked()
  }

  /**
   * A checked remote method implementation is a method overriding one of this
   * interface's remote methods which also has a body -- this excludes
   * abstract methods or overriding within an interface hierarchy.
   */
  Method getARemoteMethodImplementationChecked() {
    result.overrides+(this.getARemoteMethod()) and
    exists(result.getBody())
  }

  /**
   * An unchecked remote method implementation is a method that
   *
   * - has a body,
   * - matches the signature of a remote method in this interface, and
   * - is declared or inherited by an EJB associated with this remote interface,
   * but the EJB is not a subtype of this remote interface.
   */
  Method getARemoteMethodImplementationUnchecked() {
    exists(SessionEjb ejb, Method rm |
      ejb = this.getAnEjb() and
      not ejb.getAnAncestor() = this and
      rm = this.getARemoteMethod() and
      result = getAnInheritedMatchingMethodIgnoreThrows(ejb, rm.getSignature()) and
      not exists(inheritsMatchingMethodExceptThrows(ejb, rm))
    ) and
    exists(result.getBody())
  }
}

/*
 * RMI/IIOP compatibility.
 */

/** Holds if type `t` is valid for use with RMI, i.e. whether it is serializable. */
predicate isValidRmiType(Type t) {
  t instanceof PrimitiveType or
  t.(RefType).getAnAncestor() instanceof TypeSerializable
}

/** Gets an argument or result type of method `m` that is not compatible for use with RMI. */
Type getAnRmiIncompatibleType(Method m) {
  not isValidRmiType(result) and
  (result = m.getReturnType() or result = m.getAParameter().getType())
}

/*
 * Specification of 'matching' methods.
 *
 * EJBs are not in general required to implement their interfaces
 * by specifying such interfaces in the `implements` clause of the
 * bean's class definition. However, session beans are nonetheless
 * required to implement the methods in their business interfaces
 * (and remote and local interfaces) by declaring (or inheriting)
 * a 'matching' method for each method declared in these interfaces.
 *
 * An EJB method implementation 'matching' an interface method needs
 * to have the same signature (the same name, the same number and types
 * of parameters, and the same return type) and each exception declared
 * in the `throws` clause of the method implementation must also be
 * declared in the `throws` clause of the corresponding interface method
 * declaration.
 */

/** Holds if exception `ex` is an unchecked exception. */
private predicate uncheckedException(Exception ex) {
  ex.getType().getAnAncestor().hasQualifiedName("java.lang", "Error") or
  ex.getType().getAnAncestor().hasQualifiedName("java.lang", "RuntimeException")
}

/**
 * Holds if method `m` contains an explicit `throws` clause
 * with the same (unchecked) exception type as `ex`.
 */
private predicate throwsExplicitUncheckedException(Method m, Exception ex) {
  exists(ThrowStmt ts | ts.getEnclosingCallable() = m |
    uncheckedException(ex) and
    ts.getExpr().getType() = ex.getType()
  )
}

/** Gets a method (inherited by `ejb`) matching the signature `sig`. (Ignores `throws` clauses.) */
Method getAnInheritedMatchingMethodIgnoreThrows(SessionEjb ejb, string sig) {
  ejb.inherits(result) and
  sig = result.getSignature()
}

/** Holds if `ejb` inherits a method matching the given signature. (Ignores `throws` clauses.) */
predicate inheritsMatchingMethodIgnoreThrows(SessionEjb ejb, string signature) {
  exists(getAnInheritedMatchingMethodIgnoreThrows(ejb, signature))
}

/**
 * If `ejb` inherits a method matching the signature of `m` except for the `throws` clause,
 * then return any type in the `throws` clause that does not match.
 */
Type inheritsMatchingMethodExceptThrows(SessionEjb ejb, Method m) {
  exists(Method n, string sig |
    ejb.inherits(n) and
    sig = n.getSignature() and
    sig = m.getSignature() and
    exists(Exception ex | ex = n.getAnException() and not throwsExplicitUncheckedException(n, ex) |
      not ex.getType().hasSupertype*(m.getAnException().getType()) and
      result = ex.getType()
    )
  )
}

/**
 * Holds if `ejb` inherits an `ejbCreate` or `@Init` method matching `create` method `m`.
 * (Ignores `throws` clauses.)
 */
predicate inheritsMatchingCreateMethodIgnoreThrows(
  StatefulSessionEjb ejb, EjbInterfaceCreateMethod icm
) {
  exists(EjbCreateMethod cm | cm = ejb.getAnEjbCreateMethod() |
    cm.getMethodSuffix() = icm.getMethodSuffix() and
    cm.getNumberOfParameters() = icm.getNumberOfParameters() and
    forall(Parameter p, Parameter q, int idx |
      p = cm.getParameter(idx) and q = icm.getParameter(idx)
    |
      p.getType() = q.getType()
    )
  )
  or
  exists(EjbAnnotatedInitMethod im | im = ejb.getAnAnnotatedInitMethod() |
    im.getNumberOfParameters() = icm.getNumberOfParameters() and
    forall(Parameter p, Parameter q, int idx |
      p = im.getParameter(idx) and q = icm.getParameter(idx)
    |
      p.getType() = q.getType()
    )
  )
}

/**
 * If `ejb` inherits an `ejbCreate` or `@Init` method matching `create` method `m` except for the `throws` clause,
 * then return any type in the `throws` clause that does not match.
 */
Type inheritsMatchingCreateMethodExceptThrows(StatefulSessionEjb ejb, EjbInterfaceCreateMethod icm) {
  exists(EjbCreateMethod cm | cm = ejb.getAnEjbCreateMethod() |
    cm.getMethodSuffix() = icm.getMethodSuffix() and
    cm.getNumberOfParameters() = icm.getNumberOfParameters() and
    forall(Parameter p, Parameter q, int idx |
      p = cm.getParameter(idx) and q = icm.getParameter(idx)
    |
      p.getType() = q.getType()
    ) and
    exists(Exception ex |
      ex = cm.getAnException() and not throwsExplicitUncheckedException(cm, ex)
    |
      not ex.getType().hasSupertype*(icm.getAnException().getType()) and
      result = ex.getType()
    )
  )
  or
  exists(EjbAnnotatedInitMethod im | im = ejb.getAnAnnotatedInitMethod() |
    im.getNumberOfParameters() = icm.getNumberOfParameters() and
    forall(Parameter p, Parameter q, int idx |
      p = im.getParameter(idx) and q = icm.getParameter(idx)
    |
      p.getType() = q.getType()
    ) and
    exists(Exception ex |
      ex = im.getAnException() and not throwsExplicitUncheckedException(im, ex)
    |
      not ex.getType().hasSupertype*(icm.getAnException().getType()) and
      result = ex.getType()
    )
  )
}

/*
 * Annotations in the `javax.ejb package`.
 */

/**
 * A `@javax.ejb.AccessTimeout` annotation.
 */
class AccessTimeoutAnnotation extends Annotation {
  AccessTimeoutAnnotation() { this.getType().hasQualifiedName("javax.ejb", "AccessTimeout") }
}

/**
 * A `@javax.ejb.ActivationConfigProperty` annotation.
 */
class ActivationConfigPropertyAnnotation extends Annotation {
  ActivationConfigPropertyAnnotation() {
    this.getType().hasQualifiedName("javax.ejb", "ActivationConfigProperty")
  }
}

/**
 * A `@javax.ejb.AfterBegin` annotation.
 */
class AfterBeginAnnotation extends Annotation {
  AfterBeginAnnotation() { this.getType().hasQualifiedName("javax.ejb", "AfterBegin") }
}

/**
 * A `@javax.ejb.AfterCompletion` annotation.
 */
class AfterCompletionAnnotation extends Annotation {
  AfterCompletionAnnotation() { this.getType().hasQualifiedName("javax.ejb", "AfterCompletion") }
}

/**
 * A `@javax.ejb.ApplicationException` annotation.
 */
class ApplicationExceptionAnnotation extends Annotation {
  ApplicationExceptionAnnotation() {
    this.getType().hasQualifiedName("javax.ejb", "ApplicationException")
  }
}

/**
 * A `@javax.ejb.Asynchronous` annotation.
 */
class AsynchronousAnnotation extends Annotation {
  AsynchronousAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Asynchronous") }
}

/**
 * A `@javax.ejb.BeforeCompletion` annotation.
 */
class BeforeCompletionAnnotation extends Annotation {
  BeforeCompletionAnnotation() { this.getType().hasQualifiedName("javax.ejb", "BeforeCompletion") }
}

/**
 * A `@javax.ejb.ConcurrencyManagement` annotation.
 */
class ConcurrencyManagementAnnotation extends Annotation {
  ConcurrencyManagementAnnotation() {
    this.getType().hasQualifiedName("javax.ejb", "ConcurrencyManagement")
  }
}

/**
 * A `@javax.ejb.DependsOn` annotation.
 */
class DependsOnAnnotation extends Annotation {
  DependsOnAnnotation() { this.getType().hasQualifiedName("javax.ejb", "DependsOn") }
}

/**
 * A `@javax.ejb.EJB` annotation.
 */
class EjbAnnotation extends Annotation {
  EjbAnnotation() { this.getType().hasQualifiedName("javax.ejb", "EJB") }
}

/**
 * A `@javax.ejb.EJBs` annotation.
 */
class EJBsAnnotation extends Annotation {
  EJBsAnnotation() { this.getType().hasQualifiedName("javax.ejb", "EJBs") }
}

/**
 * A `@javax.ejb.LocalBean` annotation.
 */
class LocalBeanAnnotation extends Annotation {
  LocalBeanAnnotation() { this.getType().hasQualifiedName("javax.ejb", "LocalBean") }
}

/**
 * A `@javax.ejb.Lock` annotation.
 */
class LockAnnotation extends Annotation {
  LockAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Lock") }
}

/**
 * A `@javax.ejb.MessageDriven` annotation.
 */
class MessageDrivenAnnotation extends Annotation {
  MessageDrivenAnnotation() { this.getType().hasQualifiedName("javax.ejb", "MessageDriven") }
}

/**
 * A `@javax.ejb.PostActivate` annotation.
 */
class PostActivateAnnotation extends Annotation {
  PostActivateAnnotation() { this.getType().hasQualifiedName("javax.ejb", "PostActivate") }
}

/**
 * A `@javax.ejb.PrePassivate` annotation.
 */
class PrePassivateAnnotation extends Annotation {
  PrePassivateAnnotation() { this.getType().hasQualifiedName("javax.ejb", "PrePassivate") }
}

/**
 * A `@javax.ejb.Remove` annotation.
 */
class RemoveAnnotation extends Annotation {
  RemoveAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Remove") }
}

/**
 * A `@javax.ejb.Schedule` annotation.
 */
class ScheduleAnnotation extends Annotation {
  ScheduleAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Schedule") }
}

/**
 * A `@javax.ejb.Schedules` annotation.
 */
class SchedulesAnnotation extends Annotation {
  SchedulesAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Schedules") }
}

/**
 * A `@javax.ejb.Singleton` annotation.
 */
class SingletonAnnotation extends Annotation {
  SingletonAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Singleton") }
}

/**
 * A `@javax.ejb.Startup` annotation.
 */
class StartupAnnotation extends Annotation {
  StartupAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Startup") }
}

/**
 * A `@javax.ejb.Stateful` annotation.
 */
class StatefulAnnotation extends Annotation {
  StatefulAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Stateful") }
}

/**
 * A `@javax.ejb.StatefulTimeout` annotation.
 */
class StatefulTimeoutAnnotation extends Annotation {
  StatefulTimeoutAnnotation() { this.getType().hasQualifiedName("javax.ejb", "StatefulTimeout") }
}

/**
 * A `@javax.ejb.Stateless` annotation.
 */
class StatelessAnnotation extends Annotation {
  StatelessAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Stateless") }
}

/**
 * A `@javax.ejb.Timeout` annotation.
 */
class TimeoutAnnotation extends Annotation {
  TimeoutAnnotation() { this.getType().hasQualifiedName("javax.ejb", "Timeout") }
}

/**
 * A `@javax.ejb.TransactionAttribute` annotation.
 */
class TransactionAttributeAnnotation extends Annotation {
  TransactionAttributeAnnotation() {
    this.getType().hasQualifiedName("javax.ejb", "TransactionAttribute")
  }
}

/**
 * A `@javax.ejb.TransactionManagement` annotation.
 */
class TransactionManagementAnnotation extends Annotation {
  TransactionManagementAnnotation() {
    this.getType().hasQualifiedName("javax.ejb", "TransactionManagement")
  }
}

/**
 * A `@javax.ejb.TransactionAttribute` annotation with the
 * transaction attribute type set to `REQUIRED`.
 */
class RequiredTransactionAttributeAnnotation extends TransactionAttributeAnnotation {
  RequiredTransactionAttributeAnnotation() {
    exists(FieldRead fr |
      this.getValue("value") = fr and
      fr.getField().getType().(RefType).hasQualifiedName("javax.ejb", "TransactionAttributeType") and
      fr.getField().getName() = "REQUIRED"
    )
  }
}

/**
 * A `@javax.ejb.TransactionAttribute` annotation with the
 * transaction attribute type set to `REQUIRES_NEW`.
 */
class RequiresNewTransactionAttributeAnnotation extends TransactionAttributeAnnotation {
  RequiresNewTransactionAttributeAnnotation() {
    exists(FieldRead fr |
      this.getValue("value") = fr and
      fr.getField().getType().(RefType).hasQualifiedName("javax.ejb", "TransactionAttributeType") and
      fr.getField().getName() = "REQUIRES_NEW"
    )
  }
}

/*
 * Convenience methods.
 */

/**
 * Gets the innermost `@javax.ejb.TransactionAttribute` annotation for method `m`.
 */
TransactionAttributeAnnotation getInnermostTransactionAttributeAnnotation(Method m) {
  // A `TransactionAttribute` annotation can either be on the method itself,
  // in which case it supersedes any such annotation on the declaring class...
  result = m.getAnAnnotation()
  or
  // ...or if the declaring class has such an annotation, the annotation applies to
  // any method declared within the class that does not itself have such an annotation.
  not exists(m.getAnAnnotation().(TransactionAttributeAnnotation)) and
  result = m.getDeclaringType().getSourceDeclaration().getAnAnnotation()
}

/*
 * Methods in the `javax.ejb package`.
 */

/**
 * A method named `setRollbackOnly` declared on the
 * interface `javax.ejb.EJBContext` or a subtype thereof.
 */
class SetRollbackOnlyMethod extends Method {
  SetRollbackOnlyMethod() {
    this.getDeclaringType().getAnAncestor().hasQualifiedName("javax.ejb", "EJBContext") and
    this.getName() = "setRollbackOnly" and
    this.hasNoParameters()
  }
}
