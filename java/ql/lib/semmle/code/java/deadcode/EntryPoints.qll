import java
import semmle.code.java.deadcode.DeadCode
import semmle.code.java.deadcode.frameworks.CamelEntryPoints
import semmle.code.java.deadcode.frameworks.GigaSpacesXAPEntryPoints
import semmle.code.java.deadcode.SpringEntryPoints
import semmle.code.java.deadcode.StrutsEntryPoints
import semmle.code.java.deadcode.TestEntryPoints
import semmle.code.java.deadcode.WebEntryPoints
import semmle.code.java.frameworks.javaee.JavaServerFaces
import semmle.code.java.frameworks.JAXB
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.JMX
import semmle.code.java.Reflection
import semmle.code.java.frameworks.JavaxAnnotations
import semmle.code.java.frameworks.Selenium

/**
 * An entry point into our system, marking some number of `Callable`s
 * as live.
 */
abstract class EntryPoint extends Top {
  /**
   * One of the `Callable`s associated with this entry point.
   */
  abstract Callable getALiveCallable();
}

/**
 * An entry point corresponding to a single method or constructor.
 */
abstract class CallableEntryPoint extends EntryPoint, Callable {
  override Callable getALiveCallable() { result = this }
}

/**
 * An entry point that is a single method, that is only live if there is a live constructor on the
 * class.
 */
abstract class CallableEntryPointOnConstructedClass extends EntryPoint {
  CallableEntryPointOnConstructedClass() {
    exists(Constructor c | c = this.(Callable).getDeclaringType().getAConstructor() and isLive(c))
  }

  override Callable getALiveCallable() { result = this }
}

/**
 * A callable which is dead, but should be considered as live.
 *
 * This should be used for cases where the callable is dead, but should not be removed - for
 * example, because it may be useful in the future. If the callable is live, but is not marked as a
 * such, then a new `CallableEntryPoint` should be added instead.
 *
 * Whitelisting a callable will automatically cause the containing class to be considered as live.
 */
abstract class WhitelistedLiveCallable extends CallableEntryPoint { }

/**
 * A `public static void main(String[] args)` method.
 */
class MainMethodEntry extends CallableEntryPoint instanceof MainMethod { }

/**
 * A method that overrides a library method -- the result is
 * that when the library calls the overridden method, it may
 * instead call this method, which makes it live even if we
 * don't directly see the call.
 */
class LibOverrideMethodEntry extends CallableEntryPoint {
  LibOverrideMethodEntry() {
    this.fromSource() and
    exists(Method libraryMethod | this.(Method).overrides*(libraryMethod) |
      // The library method must not come from source, either directly, or added automatically.
      // For example, `values()` and `valueOf(...)` methods are not `fromSource()`, but are added
      // automatically to source types.
      not libraryMethod.getDeclaringType().getSourceDeclaration().fromSource()
    )
  }
}

/**
 * A class that may be constructed reflectively, making its default constructor live.
 */
abstract class ReflectivelyConstructedClass extends EntryPoint, Class {
  /**
   * Reflectively constructed classes have a live default constructor.
   */
  override Callable getALiveCallable() {
    result = this.getAConstructor() and
    result.getNumberOfParameters() = 0
  }
}

/**
 * Classes that are deserialized by Jackson are reflectively constructed.
 */
class JacksonReflectivelyConstructedClass extends ReflectivelyConstructedClass instanceof JacksonDeserializableType
{
  override Callable getALiveCallable() {
    // Constructors may be called by Jackson, if they are a no-arg, they have a suitable annotation,
    // or inherit a suitable annotation through a mixin.
    result = this.getAConstructor() and
    (
      result.getNumberOfParameters() = 0 or
      result.getAnAnnotation() instanceof JacksonAnnotation or
      result.getAParameter().getAnAnnotation() instanceof JacksonAnnotation or
      exists(JacksonMixedInCallable mixinCallable | result = mixinCallable.getATargetCallable())
    )
  }
}

/**
 * A callable that is used when applying Jackson mixins.
 */
class JacksonMixinCallableEntryPoint extends EntryPoint {
  JacksonMixinCallableEntryPoint() {
    exists(JacksonMixinType mixinType, JacksonAddMixinCall mixinCall |
      this = mixinType.getAMixedInCallable() and
      mixinType = mixinCall.getAMixedInType()
    |
      isLive(mixinCall.getEnclosingCallable())
    )
  }

  override Callable getALiveCallable() { result = this }
}

/** A JAX annotation seen as a reflectively constructed class. */
class JaxAnnotationReflectivelyConstructedClass extends ReflectivelyConstructedClass {
  JaxAnnotationReflectivelyConstructedClass() {
    this instanceof JaxWsEndpoint or
    this instanceof JaxbXmlRegistry or
    this instanceof JaxRsResourceClass or
    this instanceof JaxbXmlEnum
  }
}

class DeserializedClass extends ReflectivelyConstructedClass {
  DeserializedClass() {
    exists(CastingExpr cast, ReadObjectMethod readObject |
      cast.getExpr().(MethodCall).getMethod() = readObject
    |
      hasDescendant(cast.getType(), this)
    )
  }
}

/**
 * A call to `Class.newInstance()` or `Constructor.newInstance()` which may imply that a number of
 * constructors are live.
 */
class NewInstanceCall extends EntryPoint, NewInstance {
  override Constructor getALiveCallable() {
    result = this.getInferredConstructor() and
    // The `newInstance(...)` call must be used in a live context.
    isLive(this.getEnclosingCallable())
  }
}

/**
 * A call to either `Class.getMethod(...)` or `Class.getDeclaredMethod(...)`.
 */
class ReflectiveGetMethodCallEntryPoint extends EntryPoint, ReflectiveGetMethodCall {
  override Method getALiveCallable() {
    result = this.inferAccessedMethod() and
    // The `getMethod(...)` call must be used in a live context.
    isLive(this.getEnclosingCallable())
  }
}

/**
 * Classes that are entry points recognised by annotations.
 */
abstract class AnnotationEntryPoint extends EntryPoint, Class {
  /**
   * By default assume all public methods might be called, but not
   * constructors -- be sure to register any further subtypes with
   * `ReflectivelyConstructedClass`.
   */
  override Callable getALiveCallable() {
    result = this.getAMethod() and
    result.isPublic()
  }
}

/**
 * A JAXB XML registry, used reflectively to construct objects based on
 * the contents of XML files.
 */
class JaxbXmlRegistry extends AnnotationEntryPoint {
  JaxbXmlRegistry() { this.(JaxbAnnotated).hasJaxbAnnotation("XmlRegistry") }
}

/**
 * An enum annotated with `@XmlEnum` can be used by JAXB when constructing objects reflectively based
 * on the contents of XML files. Unlike classes, these are never referred to from the `@XmlRegistry`
 * class, because they do not need to be instantiated, just used. We therefore need to special case
 * them.
 */
class JaxbXmlEnum extends AnnotationEntryPoint {
  JaxbXmlEnum() { this.(JaxbAnnotated).hasJaxbAnnotation("XmlEnum") }
}

/**
 * A type annotated with `@XmlType`, indicating that this class is used when marshalling or
 * unmarshalling XML documents.
 */
class JaxbXmlType extends AnnotationEntryPoint, JaxbType {
  override Callable getALiveCallable() {
    // Must have a live no-arg constructor for JAXB to perform marshal/unmarshal.
    exists(Constructor c | c = this.getAConstructor() and c.getNumberOfParameters() = 0 | isLive(c)) and
    result = this.getACallable() and
    (
      // A bound getter or setter.
      result instanceof JaxbBoundGetterSetter
      or
      // Methods called by reflection when unmarshalling or marshalling.
      result.hasName("afterUnmarshal") and result.paramsString() = "(Unmarshaller, Object)"
      or
      result.hasName("beforeUnmarshal") and result.paramsString() = "(Unmarshaller, Object)"
      or
      result.hasName("afterMarshal") and result.paramsString() = "(Marshaller, Object)"
      or
      result.hasName("beforeMarshal") and result.paramsString() = "(Marshaller, Object)"
    )
  }
}

/**
 * A JAX WS endpoint is constructed by the container, and its methods
 * are -- where annotated -- called remotely.
 */
class JaxWsEndpointEntry extends JaxWsEndpoint, AnnotationEntryPoint {
  override Callable getALiveCallable() { result = this.getARemoteMethod() }
}

/**
 * A JAX RS resource class. `@GET` and `@POST` annotated methods are reflectively called by the container. The
 * class itself may be reflectively constructed by the container.
 */
class JaxRsResourceClassEntry extends JaxRsResourceClass, AnnotationEntryPoint {
  override Callable getALiveCallable() { result = this.getAnInjectableCallable() }
}

/**
 * A constructor that may be called when injecting values into a JaxRS resource class constructor or method.
 */
class JaxRsBeanParamConstructorEntryPoint extends JaxRsBeanParamConstructor, CallableEntryPoint { }

/**
 * Entry point for methods that can be accessed through JMX.
 *
 * The instance here is a `ManagedBean` (`MBean` or `MXBean`) implementation class, that is seen to be
 * registered with the `MBeanServer`, directly or indirectly. The live callables are all the
 * methods in this class that override something declared in one or more of the managed beans
 * that this class implements.
 */
class ManagedBeanImplEntryPoint extends EntryPoint, RegisteredManagedBeanImpl {
  override Method getALiveCallable() {
    // Find the method that will be called for each method on each managed bean that this class
    // implements.
    this.inherits(result) and
    result.overrides+(this.getAnImplementedManagedBean().getAMethod())
  }
}

/**
 * Entry point for bean classes. Should be extended to define any
 * project specific types of bean.
 */
abstract class BeanClass extends EntryPoint, Class {
  override Callable getALiveCallable() {
    result = this.getACallable() and
    (result.(Method).isPublic() or result.(Constructor).getNumberOfParameters() = 0)
  }
}

/**
 * Entry point for J2EE beans (`EnterpriseBean`, `EntityBean`, `MessageBean`, `SessionBean`).
 */
class J2EEBean extends BeanClass {
  J2EEBean() {
    this instanceof EnterpriseBean or
    this instanceof EntityBean or
    this instanceof MessageBean or
    this instanceof SessionBean
  }
}

/**
 * Entry point for Java Server Faces `ManagedBean`s.
 */
class FacesManagedBeanEntryPoint extends BeanClass, FacesManagedBean { }

/**
 * Entry point for methods that may be called by Java Server Faces.
 */
class FacesAccessibleMethodEntryPoint extends CallableEntryPoint {
  FacesAccessibleMethodEntryPoint() {
    exists(FacesAccessibleType accessibleType | this = accessibleType.getAnAccessibleMethod())
  }
}

/**
 * A Java Server Faces custom component, that is reflectively constructed by the framework when
 * used in a view (JSP or facelet).
 */
class FacesComponentReflectivelyConstructedClass extends ReflectivelyConstructedClass instanceof FacesComponent
{ }

/**
 * Entry point for EJB home interfaces.
 */
class EjbHome extends Interface, EntryPoint {
  EjbHome() { this.getAnAncestor().hasQualifiedName("javax.ejb", "EJBHome") }

  override Callable getALiveCallable() { result = this.getACallable() }
}

/**
 * Entry point for EJB object interfaces.
 */
class EjbObject extends Interface, EntryPoint {
  EjbObject() { this.getAnAncestor().hasQualifiedName("javax.ejb", "EJBObject") }

  override Callable getALiveCallable() { result = this.getACallable() }
}

class GsonDeserializationEntryPoint extends ReflectivelyConstructedClass {
  GsonDeserializationEntryPoint() {
    // Assume any class with a gson annotated field can be deserialized.
    this.getAField().getAnAnnotation().getType().hasQualifiedName("com.google.gson.annotations", _)
  }
}

/** A JAXB deserialization entry point seen as a reflectively constructed class. */
class JaxbDeserializationEntryPoint extends ReflectivelyConstructedClass {
  JaxbDeserializationEntryPoint() {
    // A class can be deserialized by JAXB if it's an `XmlRootElement`...
    this.getAnAnnotation().getType().hasQualifiedName("javax.xml.bind.annotation", "XmlRootElement")
    or
    // ... or the type of an `XmlElement` field.
    exists(Field elementField |
      elementField.getAnAnnotation().getType() instanceof JaxbMemberAnnotation
    |
      usesType(elementField.getType(), this)
    )
  }
}

/**
 * A `javax.annotation` for a method that is called after or before dependency injection on a type.
 *
 * Consider this to be live if and only if there is a live constructor.
 */
class PreOrPostDIMethod extends CallableEntryPointOnConstructedClass {
  PreOrPostDIMethod() {
    this.(Method).getAnAnnotation() instanceof PostConstructAnnotation or
    this.(Method).getAnAnnotation() instanceof PreDestroyAnnotation
  }
}

/**
 * A `javax.annotation` for a method that is called to inject a resource into the class.
 *
 * Consider this to be live if and only if there is a live constructor.
 */
class JavaxResourceAnnotatedMethod extends CallableEntryPointOnConstructedClass {
  JavaxResourceAnnotatedMethod() { this.(Method).getAnAnnotation() instanceof ResourceAnnotation }
}

/**
 * A `javax.annotation.ManagedBean` annotated class, which may be constructed by a container of some
 * description.
 */
class JavaxManagedBeanReflectivelyConstructed extends ReflectivelyConstructedClass {
  JavaxManagedBeanReflectivelyConstructed() {
    this.getAnAnnotation() instanceof JavaxManagedBeanAnnotation
  }
}

/**
 * Classes marked as Java persistence entities can be reflectively constructed when the data is
 * loaded.
 */
class PersistentEntityEntryPoint extends ReflectivelyConstructedClass instanceof PersistentEntity {
}

/**
 * A method (getter or setter) called on a persistent entity class by the persistence framework.
 */
class PersistencePropertyMethod extends CallableEntryPoint {
  PersistencePropertyMethod() {
    exists(PersistentEntity e |
      this = e.getACallable() and
      (
        e.getAccessType() = "property" or
        this.hasAnnotation("javax.persistence", "Access")
      ) and
      (
        this.getName().matches("get%") or
        this.getName().matches("set%")
      )
    )
  }
}

/**
 * Methods that are registered by annotations as callbacks for certain Java persistence events.
 */
class PersistenceCallbackMethod extends CallableEntryPoint {
  PersistenceCallbackMethod() {
    this.getAnAnnotation() instanceof PrePersistAnnotation or
    this.getAnAnnotation() instanceof PreRemoveAnnotation or
    this.getAnAnnotation() instanceof PreUpdateAnnotation or
    this.getAnAnnotation() instanceof PostPersistAnnotation or
    this.getAnAnnotation() instanceof PostRemoveAnnotation or
    this.getAnAnnotation() instanceof PostUpdateAnnotation or
    this.getAnAnnotation() instanceof PostLoadAnnotation
  }
}

/**
 * A source class which is referred to by fully qualified name in the value of an arbitrary XML
 * attribute which has a name containing "className" or "ClassName".
 */
class ArbitraryXmlEntryPoint extends ReflectivelyConstructedClass {
  ArbitraryXmlEntryPoint() {
    this.fromSource() and
    exists(XmlAttribute attribute |
      attribute.getName() = "className" or
      attribute.getName().matches("%ClassName") or
      attribute.getName() = "class" or
      attribute.getName().matches("%Class")
    |
      attribute.getValue() = this.getQualifiedName()
    )
  }

  override Callable getALiveCallable() {
    // Any constructor on these classes, as we don't know which may be called.
    result = this.getAConstructor()
  }
}

/** A Selenium PageObject, created by a call to PageFactory.initElements(..). */
class SeleniumPageObjectEntryPoint extends ReflectivelyConstructedClass instanceof SeleniumPageObject
{ }
