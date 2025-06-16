/**
 * Provides classes and predicates for working with Kotlin types.
 */
overlay[local?]
module;

import java

class KotlinType extends Element, @kt_type { }

class KotlinNullableType extends KotlinType, @kt_nullable_type {
  override string toString() {
    exists(RefType javaType |
      kt_nullable_types(this, javaType) and
      result = "Kotlin nullable " + javaType.toString()
    )
  }

  override string getAPrimaryQlClass() { result = "KotlinNullableType" }
}

class KotlinNotnullType extends KotlinType, @kt_notnull_type {
  override string toString() {
    exists(RefType javaType |
      kt_notnull_types(this, javaType) and
      result = "Kotlin not-null " + javaType.toString()
    )
  }

  override string getAPrimaryQlClass() { result = "KotlinNotnullType" }
}

class KotlinTypeAlias extends Element, @kt_type_alias {
  override string getAPrimaryQlClass() { result = "KotlinTypeAlias" }

  KotlinType getKotlinType() { kt_type_alias(this, _, result) }
}
