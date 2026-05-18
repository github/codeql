/**
 * Provides classes for modeling typedefs and type aliases.
 */

import semmle.code.cpp.Type
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ typedef type. See 4.9.1.  For example the types declared on each line of the following code:
 * ```
 * typedef int my_int;
 * using my_int2 = int;
 * ```
 */
class TypedefType extends UserType {
  TypedefType() { usertypes(underlyingElement(this), _, 18) }

  /**
   * Gets the base type of this typedef type.
   */
  Type getBaseType() { typedefbase(underlyingElement(this), unresolveElement(result)) }

  override Type getUnderlyingType() { result = this.getBaseType().getUnderlyingType() }

  override Type stripTopLevelSpecifiers() { result = this.getBaseType().stripTopLevelSpecifiers() }

  override int getSize() { result = this.getBaseType().getSize() }

  override int getAlignment() { result = this.getBaseType().getAlignment() }

  override int getPointerIndirectionLevel() {
    result = this.getBaseType().getPointerIndirectionLevel()
  }

  override predicate isDeeplyConst() { this.getBaseType().isDeeplyConst() } // Just an alias

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConstBelow() } // Just an alias

  override Specifier internal_getAnAdditionalSpecifier() {
    result = this.getBaseType().getASpecifier()
  }

  override predicate involvesReference() { this.getBaseType().involvesReference() }

  override Type resolveTypedefs() { result = this.getBaseType().resolveTypedefs() }

  override Type stripType() { result = this.getBaseType().stripType() }
}

/**
 * A traditional C/C++ typedef type. See 4.9.1.  For example the type declared in the following code:
 * ```
 * typedef int my_int;
 * ```
 */
class CTypedefType extends TypedefType {
  CTypedefType() { usertype_alias_kind(underlyingElement(this), 0) }

  override string getAPrimaryQlClass() { result = "CTypedefType" }

  override string explain() {
    result = "typedef {" + this.getBaseType().explain() + "} as \"" + this.getName() + "\""
  }
}

/**
 * DEPRECATED: Use `TypeAlias` instead.
 *
 * A C++ type alias or alias template.
 *
 * For example the type declared in the following code:
 * ```
 * using my_int2 = int;
 * ```
 */
deprecated class UsingAliasTypedefType = TypeAliasType;

/**
 * A C++ type alias or alias template.
 *
 * For example the type declared in the following code:
 * ```
 * using my_int2 = int;
 * ```
 */
class TypeAliasType extends TypedefType {
  TypeAliasType() { usertype_alias_kind(underlyingElement(this), 1) }

  override string getAPrimaryQlClass() { result = "TypeAliasType" }

  override string explain() {
    result = "using {" + this.getBaseType().explain() + "} as \"" + this.getName() + "\""
  }

  /**
   * Holds if this alias is constructed from another alias as a result of
   * template instantiation.
   */
  predicate isConstructedFrom(TypeAliasType t) {
    alias_instantiation(underlyingElement(this), unresolveElement(t))
  }
}

/**
 * A C++ alias template.
 *
 * For example the type declared in the following code:
 * ```
 * template <typename T>
 * using my_type = T;
 * ```
 */
class AliasTemplateType extends TypeAliasType {
  AliasTemplateType() { is_alias_template(underlyingElement(this)) }

  override string getAPrimaryQlClass() { result = "AliasTemplateType" }

  /**
   * Gets a alias instantiated from this template.
   *
   * For example for `MyAliasTemplate<T>` in the following code, the results are
   * `MyAliasTemplate<int>` and `MyAliasTemplate<long>`:
   * ```
   * template<typename T>
   * using MyAliasTemplate = ;
   *
   * MyAliasTemplate<int> instance1;
   *
   * MyAliasTemplate<long> instance2;
   * ```
   */
  TypeAliasType getAnInstantiation() { result.isConstructedFrom(this) }
}

/**
 * A C++ alias template instantiation.
 *
 * For example the `my_int_type` type declared in the following code:
 * ```
 * template <typename T>
 * using my_type = T;
 *
 * using my_int_type = my_type<int>;
 * ```
 */
class AliasTemplateInstantiationType extends TypeAliasType {
  AliasTemplateType at;

  AliasTemplateInstantiationType() { at.getAnInstantiation() = this }

  override string getAPrimaryQlClass() { result = "AliasTemplateInstantiationType" }

  /**
   * Gets the alias template from which this instantiation was instantiated.
   */
  AliasTemplateType getTemplate() { result = at }
}

/**
 * A C++ `typedef` type that is directly enclosed by a function.
 *
 * For example the type declared inside the function `foo` in
 * the following code:
 * ```
 * int foo(void) { typedef int local; }
 * ```
 */
class LocalTypedefType extends TypedefType {
  LocalTypedefType() { this.isLocal() }

  override string getAPrimaryQlClass() { result = "LocalTypedefType" }
}

/**
 * A C++ `typedef` type that is directly enclosed by a `class`, `struct` or `union`.  For example the type declared inside
 * the class `C` in the following code:
 * ```
 * class C { typedef int nested; };
 * ```
 */
class NestedTypedefType extends TypedefType {
  NestedTypedefType() { this.isMember() }

  override string getAPrimaryQlClass() { result = "NestedTypedefType" }
}
