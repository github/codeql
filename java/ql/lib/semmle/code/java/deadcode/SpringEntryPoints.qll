import java
import semmle.code.java.deadcode.DeadCode
import semmle.code.java.frameworks.spring.Spring

/**
 * A method called by Spring to construct a Spring class, or inject a parameter into a Spring class.
 */
class SpringInjectionCallableEntryPoint extends CallableEntryPoint {
  SpringInjectionCallableEntryPoint() {
    // The constructor of a Spring component, constructed by the container in response to context scanning.
    this instanceof SpringComponentConstructor or
    // The constructor of a Spring bean, constructed by the container.
    this instanceof SpringBeanReflectivelyConstructed or
    // A setter method specified in the context.
    this instanceof SpringBeanPropertySetterMethod or
    exists(this.(SpringBeanXmlAutowiredSetterMethod).getInjectedBean()) or
    this instanceof SpringBeanAutowiredCallable
  }
}

/**
 * A method called by Spring when a bean is initialized or destroyed.
 */
class SpringBeanInitDestroyMethod extends CallableEntryPoint {
  SpringBeanInitDestroyMethod() {
    exists(SpringBean bean |
      this = bean.getInitMethod() or
      this = bean.getDestroyMethod()
    )
  }
}

/**
 * A factory method called to construct an instance of a bean.
 */
class SpringFactoryMethod extends CallableEntryPoint {
  SpringFactoryMethod() { exists(SpringBean bean | this = bean.getFactoryMethod()) }
}

/**
 * A method that creates a Spring bean.
 */
class SpringBeanAnnotatedMethod extends CallableEntryPoint {
  SpringBeanAnnotatedMethod() {
    hasAnnotation("org.springframework.context.annotation", "Bean") and
    getDeclaringType().(SpringComponent).isLive()
  }
}

/**
 * A live entry point within a Spring controller.
 */
class SpringControllerEntryPoint extends CallableEntryPoint {
  SpringControllerEntryPoint() { this instanceof SpringControllerMethod }
}

/**
 * A method that is accessible in a response, because it is part of the returned model,
 * for example when rendering a JSP page.
 */
class SpringResponseAccessibleMethod extends CallableEntryPoint {
  SpringResponseAccessibleMethod() {
    // Must be on a type used in a Model response.
    getDeclaringType() instanceof SpringModelResponseType and
    // Must be public.
    isPublic()
  }
}

/**
 * A Spring "managed resource" is a JMX bean, where only methods annotated with `@ManagedAttribute`
 * or `@ManagedOperation` are exposed.
 */
class SpringManagedResource extends CallableEntryPoint {
  SpringManagedResource() {
    (
      hasAnnotation("org.springframework.jmx.export.annotation", "ManagedAttribute") or
      hasAnnotation("org.springframework.jmx.export.annotation", "ManagedOperation")
    ) and
    getDeclaringType().hasAnnotation("org.springframework.jmx.export.annotation", "ManagedResource")
  }
}

/**
 * Spring allows persistence entities to have constructors other than the default constructor.
 */
class SpringPersistenceConstructor extends CallableEntryPoint {
  SpringPersistenceConstructor() {
    hasAnnotation("org.springframework.data.annotation", "PersistenceConstructor") and
    getDeclaringType() instanceof PersistentEntity
  }
}

class SpringAspect extends CallableEntryPoint {
  SpringAspect() {
    (
      hasAnnotation("org.aspectj.lang.annotation", "Around") or
      hasAnnotation("org.aspectj.lang.annotation", "Before")
    ) and
    getDeclaringType().hasAnnotation("org.aspectj.lang.annotation", "Aspect")
  }
}

/**
 * Spring Shell provides annotations for identifying methods that contribute CLI commands.
 */
class SpringCLI extends CallableEntryPoint {
  SpringCLI() {
    (
      hasAnnotation("org.springframework.shell.core.annotation", "CliCommand") or
      hasAnnotation("org.springframework.shell.core.annotation", "CliAvailabilityIndicator")
    ) and
    getDeclaringType()
        .getAnAncestor()
        .hasQualifiedName("org.springframework.shell.core", "CommandMarker")
  }
}

/**
 * An entry point which acts as a remote API for a Flex application to access a Spring application.
 */
class SpringFlexEntryPoint extends CallableEntryPoint {
  SpringFlexEntryPoint() {
    exists(SpringRemotingDestinationClass remotingDestination |
      this = remotingDestination.getARemotingMethod()
    )
  }
}
