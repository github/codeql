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
    this.hasAnnotation("org.springframework.context.annotation", "Bean") and
    this.getDeclaringType().(SpringComponent).isLive()
  }
}

/**
 * A live entry point within a Spring controller.
 */
class SpringControllerEntryPoint extends CallableEntryPoint instanceof SpringControllerMethod { }

/**
 * A method that is accessible in a response, because it is part of the returned model,
 * for example when rendering a JSP page.
 */
class SpringResponseAccessibleMethod extends CallableEntryPoint {
  SpringResponseAccessibleMethod() {
    // Must be on a type used in a Model response.
    this.getDeclaringType() instanceof SpringModelResponseType and
    // Must be public.
    this.isPublic()
  }
}

/**
 * A Spring "managed resource" is a JMX bean, where only methods annotated with `@ManagedAttribute`
 * or `@ManagedOperation` are exposed.
 */
class SpringManagedResource extends CallableEntryPoint {
  SpringManagedResource() {
    (
      this.hasAnnotation("org.springframework.jmx.export.annotation", "ManagedAttribute") or
      this.hasAnnotation("org.springframework.jmx.export.annotation", "ManagedOperation")
    ) and
    this.getDeclaringType()
        .hasAnnotation("org.springframework.jmx.export.annotation", "ManagedResource")
  }
}

/**
 * Spring allows persistence entities to have constructors other than the default constructor.
 */
class SpringPersistenceConstructor extends CallableEntryPoint {
  SpringPersistenceConstructor() {
    this.hasAnnotation("org.springframework.data.annotation", "PersistenceConstructor") and
    this.getDeclaringType() instanceof PersistentEntity
  }
}

class SpringAspect extends CallableEntryPoint {
  SpringAspect() {
    (
      this.hasAnnotation("org.aspectj.lang.annotation", "Around") or
      this.hasAnnotation("org.aspectj.lang.annotation", "Before")
    ) and
    this.getDeclaringType().hasAnnotation("org.aspectj.lang.annotation", "Aspect")
  }
}

/**
 * Spring Shell provides annotations for identifying methods that contribute CLI commands.
 */
class SpringCli extends CallableEntryPoint {
  SpringCli() {
    (
      this.hasAnnotation("org.springframework.shell.core.annotation", "CliCommand") or
      this.hasAnnotation("org.springframework.shell.core.annotation", "CliAvailabilityIndicator")
    ) and
    this.getDeclaringType()
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
