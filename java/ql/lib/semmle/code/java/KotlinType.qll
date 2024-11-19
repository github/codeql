/**
 * Provides classes and predicates for working with Kotlin types.
 */

import java

class KotlinType extends Element, @kt_type { }

class KotlinNullableType extends KotlinType, @kt_nullable_type {
  override string toString() {
    exists(KotlinType ktType |
      kt_nullable_types(this, ktType) and
      result = ktType.toString() + "?"
    )
  }

  override string getAPrimaryQlClass() { result = "KotlinNullableType" }
}

class KotlinClassType extends KotlinType, @kt_class_type {
  override string toString() { result = this.getClass().toString() }

  override string getAPrimaryQlClass() { result = "KotlinNotnullType" }

  RefType getClass() { kt_class_types(this, result) }
}

class KotlinTypeAlias extends KotlinType, @kt_type_alias {
  override string getAPrimaryQlClass() { result = "KotlinTypeAlias" }

  override string toString() {
    result = "{" + this.getKotlinType().toString() + "}" + this.getName()
  }

  override string getName() { kt_type_alias(this, result, _) }

  KotlinType getKotlinType() { kt_type_alias(this, _, result) }
}
