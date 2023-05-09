/**
 * Provides classes and predicates for identifying use of the Lombok framework.
 */

import java

/*
 * Lombok annotations.
 */

/**
 * An annotation from the Lombok framework.
 */
class LombokAnnotation extends Annotation {
  LombokAnnotation() {
    this.getType().getPackage().hasName("lombok") or
    this.getType().getPackage().getName().matches("lombok.%")
  }
}

/**
 * A Lombok `@NonNull` annotation.
 */
class LombokNonNullAnnotation extends LombokAnnotation {
  LombokNonNullAnnotation() { this.getType().hasName("NonNull") }
}

/**
 * A Lombok `@Cleanup` annotation.
 *
 * Local variable declarations annotated with `@Cleanup` are
 * automatically closed by Lombok in a generated try-finally block.
 */
class LombokCleanupAnnotation extends LombokAnnotation {
  LombokCleanupAnnotation() { this.getType().hasName("Cleanup") }
}

/**
 * A Lombok `@Getter` annotation.
 *
 * For fields annotated with `@Getter`, Lombok automatically
 * generates a corresponding getter method.
 *
 * For classes annotated with `@Getter`, Lombok automatically
 * generates corresponding getter methods for all non-static
 * fields in the annotated class, unless this behavior is
 * overridden by specifying `AccessLevel.NONE` for a field.
 */
class LombokGetterAnnotation extends LombokAnnotation {
  LombokGetterAnnotation() { this.getType().hasName("Getter") }
}

/**
 * A Lombok `@Setter` annotation.
 *
 * For fields annotated with `@Setter`, Lombok automatically
 * generates a corresponding setter method.
 *
 * For classes annotated with `@Setter`, Lombok automatically
 * generates corresponding setter methods for all non-static
 * fields in the annotated class, unless this behavior is
 * overridden by specifying `AccessLevel.NONE` for a field.
 */
class LombokSetterAnnotation extends LombokAnnotation {
  LombokSetterAnnotation() { this.getType().hasName("Setter") }
}

/**
 * A Lombok `@ToString` annotation.
 *
 * For classes annotated with `@ToString`, Lombok automatically
 * generates a `toString()` method.
 */
class LombokToStringAnnotation extends LombokAnnotation {
  LombokToStringAnnotation() { this.getType().hasName("ToString") }
}

/**
 * A Lombok `@EqualsAndHashCode` annotation.
 *
 * For classes annotated with `@EqualsAndHashCode`, Lombok automatically
 * generates suitable `equals` and `hashCode` methods.
 */
class LombokEqualsAndHashCodeAnnotation extends LombokAnnotation {
  LombokEqualsAndHashCodeAnnotation() { this.getType().hasName("EqualsAndHashCode") }
}

/**
 * A Lombok `@NoArgsConstructor` annotation.
 *
 * For classes annotated with `@NoArgsConstructor`, Lombok automatically
 * generates a constructor with no parameters.
 */
class LombokNoArgsConstructorAnnotation extends LombokAnnotation {
  LombokNoArgsConstructorAnnotation() { this.getType().hasName("NoArgsConstructor") }
}

/**
 * A Lombok `@RequiredArgsConstructor` annotation.
 *
 * For classes annotated with `@RequiredArgsConstructor`, Lombok automatically
 * generates a constructor with a parameter for each non-initialized final
 * field as well as any field annotated with `@NonNull` that is not initialized
 * where it is declared.
 */
class LombokRequiredArgsConstructorAnnotation extends LombokAnnotation {
  LombokRequiredArgsConstructorAnnotation() { this.getType().hasName("RequiredArgsConstructor") }
}

/**
 * A Lombok `@AllArgsConstructor` annotation.
 *
 * For classes annotated with `@AllArgsConstructor`, Lombok automatically
 * generates a constructor with a parameter for each field in the class.
 */
class LombokAllArgsConstructorAnnotation extends LombokAnnotation {
  LombokAllArgsConstructorAnnotation() { this.getType().hasName("AllArgsConstructor") }
}

/**
 * A Lombok `@Data` annotation.
 *
 * A shortcut for `@ToString`, `@EqualsAndHashCode`, `@Getter` on all
 * fields, `@Setter` on all non-final fields, and `@RequiredArgsConstructor`.
 */
class LombokDataAnnotation extends LombokAnnotation {
  LombokDataAnnotation() { this.getType().hasName("Data") }
}

/**
 * A Lombok `@Value` annotation.
 *
 * Effectively a shortcut for:
 *
 * ```
 * final @ToString @EqualsAndHashCode @AllArgsConstructor
 * @FieldDefaults(makeFinal=true,level=AccessLevel.PRIVATE) @Getter
 * ```
 */
class LombokValueAnnotation extends LombokAnnotation {
  LombokValueAnnotation() { this.getType().hasName("Value") }
}

/**
 * A Lombok `@Builder` annotation.
 *
 * For classes annotated with `@Builder`, Lombok automatically
 * generates complex builder APIs for the class.
 */
class LombokBuilderAnnotation extends LombokAnnotation {
  LombokBuilderAnnotation() { this.getType().hasName("Builder") }
}

/**
 * A Lombok `@SneakyThrows` annotation.
 *
 * This annotation allows throwing checked exceptions
 * without declaring them in a `throws` clause.
 */
class LombokSneakyThrowsAnnotation extends LombokAnnotation {
  LombokSneakyThrowsAnnotation() { this.getType().hasName("SneakyThrows") }
}

/**
 * A Lombok `@Synchronized` annotation.
 *
 * This annotation is treated by Lombok as a variant of the
 * `synchronized` modifier. Lombok automatically generates
 * suitable lock objects and `synchronized` statements for
 * methods annotated with `@Synchronized`.
 */
class LombokSynchronizedAnnotation extends LombokAnnotation {
  LombokSynchronizedAnnotation() { this.getType().hasName("Synchronized") }
}

/**
 * A Lombok `@Log` annotation.
 *
 * For classes annotated with `@Log`, Lombok automatically
 * generates a logger field named `log` with a specified type.
 */
class LombokLogAnnotation extends LombokAnnotation {
  LombokLogAnnotation() { this.getType().hasName("Log") }
}

/*
 * Elements annotated with Lombok annotations.
 */

/**
 * A field for which a getter method is generated by the Lombok framework.
 *
 * Specifically, a field that is either directly annotated with a Lombok
 * `@Getter` annotation or is declared in a class annotated with a Lombok
 * `@Getter`, `@Data` or `@Value` annotation.
 */
class LombokGetterAnnotatedField extends Field {
  LombokGetterAnnotatedField() {
    this.getAnAnnotation() instanceof LombokGetterAnnotation
    or
    exists(LombokAnnotation a |
      a instanceof LombokGetterAnnotation or
      a instanceof LombokDataAnnotation or
      a instanceof LombokValueAnnotation
    |
      a = this.getDeclaringType().getSourceDeclaration().getAnAnnotation()
    )
  }
}

/**
 * A class for which `equals` and `hashCode` methods are generated
 * by the Lombok framework.
 *
 * Specifically, a class with one of the following annotations:
 * `@EqualsAndHashCode`, `@Data`, or `@Value`.
 */
class LombokEqualsAndHashCodeGeneratedClass extends Class {
  LombokEqualsAndHashCodeGeneratedClass() {
    this.getAnAnnotation() instanceof LombokEqualsAndHashCodeAnnotation or
    this.getAnAnnotation() instanceof LombokDataAnnotation or
    this.getAnAnnotation() instanceof LombokValueAnnotation
  }
}
