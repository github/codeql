/**
 * Provides classes for identifying Micronaut Security annotations.
 *
 * Micronaut Security provides the `@Secured` annotation and integrates
 * with standard `@RolesAllowed` for method-level access control.
 */
overlay[local?]
module;

import java

/**
 * The annotation type `@Secured` from `io.micronaut.security.annotation`.
 */
class MicronautSecuredAnnotation extends AnnotationType {
  MicronautSecuredAnnotation() {
    this.hasQualifiedName("io.micronaut.security.annotation", "Secured")
  }
}

/**
 * A callable (method or constructor) that is annotated with Micronaut's `@Secured`
 * annotation, either directly or via its declaring type.
 */
class MicronautSecuredCallable extends Callable {
  MicronautSecuredCallable() {
    this.getAnAnnotation().getType() instanceof MicronautSecuredAnnotation
    or
    this.getDeclaringType().getAnAnnotation().getType() instanceof MicronautSecuredAnnotation
  }
}

/**
 * A class annotated with Micronaut's `@Secured` annotation.
 */
class MicronautSecuredClass extends Class {
  MicronautSecuredClass() { this.getAnAnnotation().getType() instanceof MicronautSecuredAnnotation }
}
