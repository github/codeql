/** Provides classes for identifying Micronaut Data repositories and query annotations. */
overlay[local?]
module;

import java

/**
 * The annotation type `@Query` from `io.micronaut.data.annotation`.
 */
class MicronautQueryAnnotation extends AnnotationType {
  MicronautQueryAnnotation() { this.hasQualifiedName("io.micronaut.data.annotation", "Query") }
}

/**
 * The annotation type `@Repository` from `io.micronaut.data.annotation`.
 */
class MicronautRepositoryAnnotation extends AnnotationType {
  MicronautRepositoryAnnotation() {
    this.hasQualifiedName("io.micronaut.data.annotation", "Repository")
  }
}

/**
 * A class annotated with Micronaut's `@Repository` annotation.
 */
class MicronautRepositoryClass extends RefType {
  MicronautRepositoryClass() {
    this.getAnAnnotation().getType() instanceof MicronautRepositoryAnnotation
    or
    this.getAnAncestor().hasQualifiedName("io.micronaut.data.repository", "GenericRepository")
  }
}
