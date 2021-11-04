/**
 * Provides classes and predicates for working with Kotlin types.
 */

import java

class KotlinType extends Element, @kt_type {
}

class KotlinNullableType extends KotlinType, @kt_nullable_type {
  override string toString() {
    exists(ClassOrInterface ci |
           kt_nullable_types(this, ci) and
           result = "Kotlin nullable " + ci.toString())
  }
  override string getAPrimaryQlClass() { result = "KotlinNullableType" }
}

class KotlinNotnullType extends KotlinType, @kt_notnull_type {
  override string toString() {
    exists(ClassOrInterface ci |
           kt_notnull_types(this, ci) and
           result = "Kotlin not-null " + ci.toString())
  }
  override string getAPrimaryQlClass() { result = "KotlinNotnullType" }
}

class KotlinTypeAlias extends Element, @kt_type_alias {
  override string getAPrimaryQlClass() { result = "KotlinTypeAlias" }

  KotlinType getKotlinType() {
    kt_type_alias(this, _, result)
  }
}
