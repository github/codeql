/** Provides classes for identifying Micronaut configuration injection sources. */
overlay[local?]
module;

import java

/** The annotation type `@Value` from `io.micronaut.context.annotation`. */
class MicronautValueAnnotation extends AnnotationType {
  MicronautValueAnnotation() { this.hasQualifiedName("io.micronaut.context.annotation", "Value") }
}

/** The annotation type `@Property` from `io.micronaut.context.annotation`. */
class MicronautPropertyAnnotation extends AnnotationType {
  MicronautPropertyAnnotation() {
    this.hasQualifiedName("io.micronaut.context.annotation", "Property")
  }
}

/**
 * A field annotated with Micronaut's `@Value` or `@Property` annotation,
 * representing an injected configuration value.
 */
class MicronautConfigField extends Field {
  MicronautConfigField() {
    this.getAnAnnotation().getType() instanceof MicronautValueAnnotation
    or
    this.getAnAnnotation().getType() instanceof MicronautPropertyAnnotation
  }
}

/**
 * A parameter annotated with Micronaut's `@Value` or `@Property` annotation,
 * representing an injected configuration value.
 */
class MicronautConfigParameter extends Parameter {
  MicronautConfigParameter() {
    this.getAnAnnotation().getType() instanceof MicronautValueAnnotation
    or
    this.getAnAnnotation().getType() instanceof MicronautPropertyAnnotation
  }
}
