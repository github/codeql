// BEGIN ALIASES.QLL
// Database scripts can't import, but this is the definitive copy of the support routines for mapping types to their unaliased equivalent. Ensure this code is in sync between aliases.qll and all copies in individual table .ql files.
/** A Go type. */
class Type extends @type {
  /**
   * Gets this type with all aliases substituted for their underlying type.
   *
   * Note named types are not substituted.
   */
  Type getDeepUnaliasedType() { result = this }

  /**
   * Gets a basic textual representation of this type.
   */
  string toString() { result = "type" }
}

/** A composite type, that is, not a basic type. */
class CompositeType extends @compositetype, Type { }

/** An array type. */
class ArrayType extends @arraytype, CompositeType {
  /** Gets the element type of this array type. */
  Type getElementType() { element_type(this, result) }

  /** Gets the length of this array type as a string. */
  string getLengthString() { array_length(this, result) }

  override ArrayType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType() and
    result.getLengthString() = this.getLengthString()
  }
}

/** A slice type. */
class SliceType extends @slicetype, CompositeType {
  /** Gets the element type of this slice type. */
  Type getElementType() { element_type(this, result) }

  override SliceType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType()
  }
}

// Improve efficiency of matching a struct to its unaliased equivalent
// by unpacking the first 5 fields and tags, allowing a single join
// to strongly constrain the available candidates.
private predicate hasComponentTypeAndTag(StructType s, int i, string name, Type tp, string tag) {
  component_types(s, i, name, tp) and struct_tags(s, i, tag)
}

private newtype TOptStructComponent =
  MkNoComponent() or
  MkSomeComponent(string name, Type tp, string tag) { hasComponentTypeAndTag(_, _, name, tp, tag) }

private class OptStructComponent extends TOptStructComponent {
  OptStructComponent getWithDeepUnaliasedType() {
    this = MkNoComponent() and result = MkNoComponent()
    or
    exists(string name, Type tp, string tag |
      this = MkSomeComponent(name, tp, tag) and
      result = MkSomeComponent(name, tp.getDeepUnaliasedType(), tag)
    )
  }

  string toString() { result = "struct component" }
}

private class StructComponent extends MkSomeComponent {
  string toString() { result = "struct component" }

  predicate isComponentOf(StructType s, int i) {
    exists(string name, Type tp, string tag |
      hasComponentTypeAndTag(s, i, name, tp, tag) and
      this = MkSomeComponent(name, tp, tag)
    )
  }
}

pragma[nomagic]
predicate unpackStructType(
  StructType s, TOptStructComponent c0, TOptStructComponent c1, TOptStructComponent c2,
  TOptStructComponent c3, TOptStructComponent c4, int nComponents
) {
  nComponents = count(int i | component_types(s, i, _, _)) and
  (
    if nComponents >= 1
    then c0 = any(StructComponent sc | sc.isComponentOf(s, 0))
    else c0 = MkNoComponent()
  ) and
  (
    if nComponents >= 2
    then c1 = any(StructComponent sc | sc.isComponentOf(s, 1))
    else c1 = MkNoComponent()
  ) and
  (
    if nComponents >= 3
    then c2 = any(StructComponent sc | sc.isComponentOf(s, 2))
    else c2 = MkNoComponent()
  ) and
  (
    if nComponents >= 4
    then c3 = any(StructComponent sc | sc.isComponentOf(s, 3))
    else c3 = MkNoComponent()
  ) and
  (
    if nComponents >= 5
    then c4 = any(StructComponent sc | sc.isComponentOf(s, 4))
    else c4 = MkNoComponent()
  )
}

pragma[nomagic]
predicate unpackAndUnaliasStructType(
  StructType s, TOptStructComponent c0, TOptStructComponent c1, TOptStructComponent c2,
  TOptStructComponent c3, TOptStructComponent c4, int nComponents
) {
  exists(
    OptStructComponent c0a, OptStructComponent c1a, OptStructComponent c2a, OptStructComponent c3a,
    OptStructComponent c4a
  |
    unpackStructType(s, c0a, c1a, c2a, c3a, c4a, nComponents) and
    c0 = c0a.getWithDeepUnaliasedType() and
    c1 = c1a.getWithDeepUnaliasedType() and
    c2 = c2a.getWithDeepUnaliasedType() and
    c3 = c3a.getWithDeepUnaliasedType() and
    c4 = c4a.getWithDeepUnaliasedType()
  )
}

/** A struct type. */
class StructType extends @structtype, CompositeType {
  private StructType getDeepUnaliasedTypeCandidate() {
    exists(
      OptStructComponent c0, OptStructComponent c1, OptStructComponent c2, OptStructComponent c3,
      OptStructComponent c4, int nComponents
    |
      unpackAndUnaliasStructType(this, c0, c1, c2, c3, c4, nComponents) and
      unpackStructType(result, c0, c1, c2, c3, c4, nComponents)
    )
  }

  private predicate isDeepUnaliasedTypeUpTo(StructType unaliased, int i) {
    // Note we must use component_types not hasOwnField here because component_types may specify
    // interface-in-struct embedding, but hasOwnField does not return such members.
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 5 and
    (
      i = 5 or
      this.isDeepUnaliasedTypeUpTo(unaliased, i - 1)
    ) and
    exists(string name, Type tp, string tag | hasComponentTypeAndTag(this, i, name, tp, tag) |
      hasComponentTypeAndTag(unaliased, i, name, tp.getDeepUnaliasedType(), tag)
    )
  }

  override StructType getDeepUnaliasedType() {
    result = this.getDeepUnaliasedTypeCandidate() and
    exists(int nComponents | nComponents = count(int i | component_types(this, i, _, _)) |
      this.isDeepUnaliasedTypeUpTo(result, nComponents - 1)
      or
      nComponents <= 5
    )
  }
}

/** A pointer type. */
class PointerType extends @pointertype, CompositeType {
  /** Gets the base type of this pointer type. */
  Type getBaseType() { base_type(this, result) }

  override PointerType getDeepUnaliasedType() {
    result.getBaseType() = this.getBaseType().getDeepUnaliasedType()
  }
}

private predicate isInterfaceComponentWithQualifiedName(
  InterfaceType intf, int idx, string qualifiedName, Type tp
) {
  exists(string name | component_types(intf, idx, name, tp) |
    interface_private_method_ids(intf, idx, qualifiedName)
    or
    not interface_private_method_ids(intf, idx, _) and qualifiedName = name
  )
}

private newtype TOptInterfaceComponent =
  MkNoIComponent() or
  MkSomeIComponent(string name, Type tp) {
    isInterfaceComponentWithQualifiedName(any(InterfaceType i), _, name, tp)
  }

private class OptInterfaceComponent extends TOptInterfaceComponent {
  OptInterfaceComponent getWithDeepUnaliasedType() {
    this = MkNoIComponent() and result = MkNoIComponent()
    or
    exists(string name, Type tp |
      this = MkSomeIComponent(name, tp) and
      result = MkSomeIComponent(name, tp.getDeepUnaliasedType())
    )
  }

  string toString() { result = "interface component" }
}

private class InterfaceComponent extends MkSomeIComponent {
  string toString() { result = "interface component" }

  predicate isComponentOf(InterfaceType intf, int i) {
    exists(string name, Type tp |
      isInterfaceComponentWithQualifiedName(intf, i, name, tp) and
      this = MkSomeIComponent(name, tp)
    )
  }
}

pragma[nomagic]
predicate unpackInterfaceType(
  InterfaceType intf, TOptInterfaceComponent c0, TOptInterfaceComponent c1,
  TOptInterfaceComponent c2, TOptInterfaceComponent c3, TOptInterfaceComponent c4,
  TOptInterfaceComponent e1, TOptInterfaceComponent e2, int nComponents, int nEmbeds,
  boolean isComparable
) {
  nComponents = count(int i | isInterfaceComponentWithQualifiedName(intf, i, _, _) and i >= 0) and
  nEmbeds = count(int i | isInterfaceComponentWithQualifiedName(intf, i, _, _) and i < 0) and
  (
    if intf = any(ComparableType comparable).getBaseType()
    then isComparable = true
    else isComparable = false
  ) and
  (
    if nComponents >= 1
    then c0 = any(InterfaceComponent ic | ic.isComponentOf(intf, 0))
    else c0 = MkNoIComponent()
  ) and
  (
    if nComponents >= 2
    then c1 = any(InterfaceComponent ic | ic.isComponentOf(intf, 1))
    else c1 = MkNoIComponent()
  ) and
  (
    if nComponents >= 3
    then c2 = any(InterfaceComponent ic | ic.isComponentOf(intf, 2))
    else c2 = MkNoIComponent()
  ) and
  (
    if nComponents >= 4
    then c3 = any(InterfaceComponent ic | ic.isComponentOf(intf, 3))
    else c3 = MkNoIComponent()
  ) and
  (
    if nComponents >= 5
    then c4 = any(InterfaceComponent ic | ic.isComponentOf(intf, 4))
    else c4 = MkNoIComponent()
  ) and
  (
    if nEmbeds >= 1
    then e1 = any(InterfaceComponent ic | ic.isComponentOf(intf, -1))
    else e1 = MkNoIComponent()
  ) and
  (
    if nEmbeds >= 2
    then e2 = any(InterfaceComponent ic | ic.isComponentOf(intf, -2))
    else e2 = MkNoIComponent()
  )
}

pragma[nomagic]
predicate unpackAndUnaliasInterfaceType(
  InterfaceType intf, TOptInterfaceComponent c0, TOptInterfaceComponent c1,
  TOptInterfaceComponent c2, TOptInterfaceComponent c3, TOptInterfaceComponent c4,
  TOptInterfaceComponent e1, TOptInterfaceComponent e2, int nComponents, int nEmbeds,
  boolean isComparable
) {
  exists(
    OptInterfaceComponent c0a, OptInterfaceComponent c1a, OptInterfaceComponent c2a,
    OptInterfaceComponent c3a, OptInterfaceComponent c4a, OptInterfaceComponent e1a,
    OptInterfaceComponent e2a
  |
    unpackInterfaceType(intf, c0a, c1a, c2a, c3a, c4a, e1a, e2a, nComponents, nEmbeds, isComparable) and
    c0 = c0a.getWithDeepUnaliasedType() and
    c1 = c1a.getWithDeepUnaliasedType() and
    c2 = c2a.getWithDeepUnaliasedType() and
    c3 = c3a.getWithDeepUnaliasedType() and
    c4 = c4a.getWithDeepUnaliasedType() and
    e1 = e1a.getWithDeepUnaliasedType() and
    e2 = e2a.getWithDeepUnaliasedType()
  )
}

/** An interface type. */
class InterfaceType extends @interfacetype, CompositeType {
  private Type getMethodType(int i, string name) {
    i >= 0 and isInterfaceComponentWithQualifiedName(this, i, name, result)
  }

  /**
   * Holds if `tp` is a directly embedded type with index `index`.
   *
   * `tp` (or its underlying type) is either a type set literal type or an
   * interface type.
   */
  private predicate hasDirectlyEmbeddedType(int index, Type tp) {
    index >= 0 and isInterfaceComponentWithQualifiedName(this, -(index + 1), _, tp)
  }

  private InterfaceType getDeepUnaliasedTypeCandidate() {
    exists(
      OptInterfaceComponent c0, OptInterfaceComponent c1, OptInterfaceComponent c2,
      OptInterfaceComponent c3, OptInterfaceComponent c4, OptInterfaceComponent e1,
      OptInterfaceComponent e2, int nComponents, int nEmbeds, boolean isComparable
    |
      unpackAndUnaliasInterfaceType(this, c0, c1, c2, c3, c4, e1, e2, nComponents, nEmbeds,
        isComparable) and
      unpackInterfaceType(result, c0, c1, c2, c3, c4, e1, e2, nComponents, nEmbeds, isComparable)
    )
  }

  private predicate hasDeepUnaliasedComponentTypesUpTo(InterfaceType unaliased, int i) {
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 5 and
    (
      i = 5 or
      this.hasDeepUnaliasedComponentTypesUpTo(unaliased, i - 1)
    ) and
    exists(string name |
      unaliased.getMethodType(i, name) = this.getMethodType(i, name).getDeepUnaliasedType()
    )
  }

  private predicate hasDeepUnaliasedEmbeddedTypesUpTo(InterfaceType unaliased, int i) {
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 2 and
    (
      i = 2 or
      this.hasDeepUnaliasedEmbeddedTypesUpTo(unaliased, i - 1)
    ) and
    exists(Type tp | this.hasDirectlyEmbeddedType(i, tp) |
      unaliased.hasDirectlyEmbeddedType(i, tp.getDeepUnaliasedType())
    )
  }

  override InterfaceType getDeepUnaliasedType() {
    result = this.getDeepUnaliasedTypeCandidate() and
    exists(int nComponents | nComponents = count(int i | exists(this.getMethodType(i, _))) |
      this.hasDeepUnaliasedComponentTypesUpTo(result, nComponents - 1)
      or
      nComponents <= 5
    ) and
    exists(int nEmbeds | nEmbeds = count(int i | this.hasDirectlyEmbeddedType(i, _)) |
      this.hasDeepUnaliasedEmbeddedTypesUpTo(result, nEmbeds - 1)
      or
      nEmbeds <= 2
    )
  }
}

pragma[nomagic]
private predicate unpackTupleType(
  TupleType tt, TOptType c0, TOptType c1, TOptType c2, int nComponents
) {
  nComponents = count(int i | component_types(tt, i, _, _)) and
  (if nComponents >= 1 then c0 = MkSomeType(tt.getComponentType(0)) else c0 = MkNoType()) and
  (if nComponents >= 2 then c1 = MkSomeType(tt.getComponentType(1)) else c1 = MkNoType()) and
  (if nComponents >= 3 then c2 = MkSomeType(tt.getComponentType(2)) else c2 = MkNoType())
}

pragma[nomagic]
private predicate unpackAndUnaliasTupleType(
  TupleType tt, TOptType c0, TOptType c1, TOptType c2, int nComponents
) {
  exists(OptType c0a, OptType c1a, OptType c2a |
    unpackTupleType(tt, c0a, c1a, c2a, nComponents) and
    c0 = c0a.getDeepUnaliasedType() and
    c1 = c1a.getDeepUnaliasedType() and
    c2 = c2a.getDeepUnaliasedType()
  )
}

/** A tuple type. */
class TupleType extends @tupletype, CompositeType {
  /** Gets the `i`th component type of this tuple type. */
  Type getComponentType(int i) { component_types(this, i, _, result) }

  private TupleType getCandidateDeepUnaliasedType() {
    exists(OptType c0, OptType c1, OptType c2, int nComponents |
      unpackAndUnaliasTupleType(this, c0, c1, c2, nComponents) and
      unpackTupleType(result, c0, c1, c2, nComponents)
    )
  }

  private predicate isDeepUnaliasedTypeUpTo(TupleType tt, int i) {
    tt = this.getCandidateDeepUnaliasedType() and
    i >= 3 and
    (
      i = 3
      or
      this.isDeepUnaliasedTypeUpTo(tt, i - 1)
    ) and
    tt.getComponentType(i) = this.getComponentType(i).getDeepUnaliasedType()
  }

  override TupleType getDeepUnaliasedType() {
    result = this.getCandidateDeepUnaliasedType() and
    exists(int nComponents | nComponents = count(int i | component_types(this, i, _, _)) |
      this.isDeepUnaliasedTypeUpTo(result, nComponents - 1)
      or
      nComponents <= 3
    )
  }
}

// Reasonably efficiently map from a signature type to its
// deep-unaliased equivalent, by using a single join for the leading 5 parameters
// and/or 3 results.
private newtype TOptType =
  MkNoType() or
  MkSomeType(Type tp)

private class OptType extends TOptType {
  OptType getDeepUnaliasedType() {
    exists(Type t | this = MkSomeType(t) | result = MkSomeType(t.getDeepUnaliasedType()))
    or
    this = MkNoType() and result = MkNoType()
  }

  string toString() {
    exists(Type t | this = MkSomeType(t) | result = t.toString())
    or
    this = MkNoType() and result = "no type"
  }
}

pragma[nomagic]
private predicate unpackSignatureType(
  SignatureType sig, OptType param0, OptType param1, OptType param2, OptType param3, OptType param4,
  int nParams, OptType result0, OptType result1, OptType result2, int nResults, boolean isVariadic
) {
  nParams = sig.getNumParameter() and
  nResults = sig.getNumResult() and
  (if nParams >= 1 then param0 = MkSomeType(sig.getParameterType(0)) else param0 = MkNoType()) and
  (if nParams >= 2 then param1 = MkSomeType(sig.getParameterType(1)) else param1 = MkNoType()) and
  (if nParams >= 3 then param2 = MkSomeType(sig.getParameterType(2)) else param2 = MkNoType()) and
  (if nParams >= 4 then param3 = MkSomeType(sig.getParameterType(3)) else param3 = MkNoType()) and
  (if nParams >= 5 then param4 = MkSomeType(sig.getParameterType(4)) else param4 = MkNoType()) and
  (if nResults >= 1 then result0 = MkSomeType(sig.getResultType(0)) else result0 = MkNoType()) and
  (if nResults >= 2 then result1 = MkSomeType(sig.getResultType(1)) else result1 = MkNoType()) and
  (if nResults >= 3 then result2 = MkSomeType(sig.getResultType(2)) else result2 = MkNoType()) and
  (if sig.isVariadic() then isVariadic = true else isVariadic = false)
}

pragma[nomagic]
private predicate unpackAndUnaliasSignatureType(
  SignatureType sig, OptType param0, OptType param1, OptType param2, OptType param3, OptType param4,
  int nParams, OptType result0, OptType result1, OptType result2, int nResults, boolean isVariadic
) {
  exists(
    OptType param0a, OptType param1a, OptType param2a, OptType param3a, OptType param4a,
    OptType result0a, OptType result1a, OptType result2a
  |
    unpackSignatureType(sig, param0a, param1a, param2a, param3a, param4a, nParams, result0a,
      result1a, result2a, nResults, isVariadic)
  |
    param0 = param0a.getDeepUnaliasedType() and
    param1 = param1a.getDeepUnaliasedType() and
    param2 = param2a.getDeepUnaliasedType() and
    param3 = param3a.getDeepUnaliasedType() and
    param4 = param4a.getDeepUnaliasedType() and
    result0 = result0a.getDeepUnaliasedType() and
    result1 = result1a.getDeepUnaliasedType() and
    result2 = result2a.getDeepUnaliasedType()
  )
}

/** A signature type. */
class SignatureType extends @signaturetype, CompositeType {
  /** Gets the `i`th parameter type of this signature type. */
  Type getParameterType(int i) { i >= 0 and component_types(this, i + 1, _, result) }

  /** Gets the `i`th result type of this signature type. */
  Type getResultType(int i) { i >= 0 and component_types(this, -(i + 1), _, result) }

  /** Gets the number of parameters specified by this signature. */
  int getNumParameter() { result = count(int i | exists(this.getParameterType(i))) }

  /** Gets the number of results specified by this signature. */
  int getNumResult() { result = count(int i | exists(this.getResultType(i))) }

  /** Holds if this signature type is variadic. */
  predicate isVariadic() { variadic(this) }

  private SignatureType getDeepUnaliasedTypeCandidate() {
    exists(
      OptType param0, OptType param1, OptType param2, OptType param3, OptType param4, int nParams,
      OptType result0, OptType result1, OptType result2, int nResults, boolean isVariadic
    |
      unpackAndUnaliasSignatureType(this, param0, param1, param2, param3, param4, nParams, result0,
        result1, result2, nResults, isVariadic) and
      unpackSignatureType(result, param0, param1, param2, param3, param4, nParams, result0, result1,
        result2, nResults, isVariadic)
    )
  }

  // These incremental recursive implementations only apply from parameter 5 or result 3
  // upwards to avoid constructing large squares of candidates -- the initial parameters
  // and results are taken care of by the candidate predicate.
  private predicate hasDeepUnaliasedParameterTypesUpTo(SignatureType unaliased, int i) {
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 5 and
    (i = 5 or this.hasDeepUnaliasedParameterTypesUpTo(unaliased, i - 1)) and
    unaliased.getParameterType(i) = this.getParameterType(i).getDeepUnaliasedType()
  }

  private predicate hasDeepUnaliasedResultTypesUpTo(SignatureType unaliased, int i) {
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 3 and
    (i = 3 or this.hasDeepUnaliasedResultTypesUpTo(unaliased, i - 1)) and
    unaliased.getResultType(i) = this.getResultType(i).getDeepUnaliasedType()
  }

  override SignatureType getDeepUnaliasedType() {
    result = this.getDeepUnaliasedTypeCandidate() and
    exists(int nParams, int nResults |
      this.getNumParameter() = nParams and this.getNumResult() = nResults
    |
      (
        nParams <= 5
        or
        this.hasDeepUnaliasedParameterTypesUpTo(result, nParams - 1)
      ) and
      (
        nResults <= 3
        or
        this.hasDeepUnaliasedResultTypesUpTo(result, nResults - 1)
      )
    )
  }
}

/** A map type. */
class MapType extends @maptype, CompositeType {
  /** Gets the key type of this map type. */
  Type getKeyType() { key_type(this, result) }

  /** Gets the value type of this map type. */
  Type getValueType() { element_type(this, result) }

  override MapType getDeepUnaliasedType() {
    result.getKeyType() = this.getKeyType().getDeepUnaliasedType() and
    result.getValueType() = this.getValueType().getDeepUnaliasedType()
  }
}

/** A channel type. */
class ChanType extends @chantype, CompositeType {
  /** Gets the element type of this channel type. */
  Type getElementType() { element_type(this, result) }
}

/** A channel type that can only send. */
class SendChanType extends @sendchantype, ChanType {
  override SendChanType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType()
  }
}

/** A channel type that can only receive. */
class RecvChanType extends @recvchantype, ChanType {
  override RecvChanType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType()
  }
}

/** A channel type that can both send and receive. */
class SendRecvChanType extends @sendrcvchantype, ChanType {
  override SendRecvChanType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType()
  }
}

/** A named type. */
class NamedType extends @namedtype, CompositeType {
  Type getBaseType() { underlying_type(this, result) }
}

/**
 * The predeclared `comparable` type.
 */
class ComparableType extends NamedType {
  ComparableType() { typename(this, "comparable") }
}

/** An alias type. */
class AliasType extends @typealias, CompositeType {
  /** Gets the aliased type (i.e. that appears on the RHS of the alias definition). */
  Type getRhs() { alias_rhs(this, result) }

  override Type getDeepUnaliasedType() { result = unalias(this).getDeepUnaliasedType() }
}

/**
 * Gets the non-alias type at the end of the alias chain starting at `t`.
 *
 * If `t` is not an alias type then `result` is `t`.
 */
Type unalias(Type t) {
  not t instanceof AliasType and result = t
  or
  result = unalias(t.(AliasType).getRhs())
}

predicate containsAliases(Type t) { t != t.getDeepUnaliasedType() }

class Object extends @object {
  string toString() { result = "object" }
}

class Ident extends @ident {
  string toString() { result = "identifier" }
}

class Expr extends @expr {
  string toString() { result = "expr" }
}

class TypeParamType extends @typeparamtype {
  string toString() { result = "type parameter" }
}

class TypeParamParentObject extends @typeparamparentobject {
  string toString() { result = "type parameter parent object" }
}

// Redirect references to e.g. a struct field `x MyInt`
// onto the corresponding field `x int` of the unaliased type.
Object getReplacementField(Object o) {
  exists(StructType st, StructType unaliasedSt, string name |
    fieldstructs(o, st) and
    unaliasedSt = st.getDeepUnaliasedType() and
    objects(o, _, name) and
    fieldstructs(result, unaliasedSt) and
    objects(result, _, name)
  )
}

query predicate new_array_length(ArrayType at, string length) {
  array_length(at, length) and
  not containsAliases(at)
}

query predicate new_base_type(PointerType pt, Type base) {
  base_type(pt, base) and
  not containsAliases(pt)
}

query predicate new_component_types(CompositeType ct, int i, string name, Type tp) {
  component_types(ct, i, name, tp) and
  not containsAliases(ct)
}

query predicate new_defs(Ident i, Object replacementO) {
  exists(Object o | defs(i, o) |
    replacementO = getReplacementField(o)
    or
    not exists(getReplacementField(o)) and replacementO = o
  )
}

query predicate new_element_type(CompositeType ct, Type et) {
  element_type(ct, et) and
  not containsAliases(ct)
}

query predicate new_fieldstructs(Object field, StructType st) {
  fieldstructs(field, st) and
  not containsAliases(st)
}

query predicate new_key_type(MapType mt, Type kt) {
  key_type(mt, kt) and
  not containsAliases(mt)
}

query predicate new_objects(Object o, int kind, string name) {
  objects(o, kind, name) and
  not exists(StructType st | fieldstructs(o, st) and containsAliases(st))
}

query predicate new_objecttypes(Object o, Type newT) {
  exists(Type t |
    objecttypes(o, t) and
    not exists(StructType st | fieldstructs(o, st) and containsAliases(st))
  |
    // Note this means that type aliases really do have an object in the new database;
    // they just have types that resolve to the target of the alias, not the alias itself.
    newT = t.getDeepUnaliasedType()
  )
}

query predicate new_type_objects(Type type, Object object) {
  type_objects(type, object) and
  not containsAliases(type)
}

query predicate new_type_of(Expr e, Type newT) {
  exists(Type t | type_of(e, t) | newT = t.getDeepUnaliasedType())
}

query predicate new_typename(Type type, string name) {
  typename(type, name) and
  not containsAliases(type)
}

query predicate new_typeparam(
  TypeParamType tp, string name, CompositeType newBound, TypeParamParentObject parent, int idx
) {
  exists(Type bound | typeparam(tp, name, bound, parent, idx) |
    newBound = bound.getDeepUnaliasedType()
  )
}

query predicate new_types(Type t, int kind) {
  types(t, kind) and
  not containsAliases(t)
}

query predicate new_underlying_type(NamedType nt, Type newUnderlyingType) {
  exists(Type ut | underlying_type(nt, ut) | newUnderlyingType = ut.getDeepUnaliasedType())
}

query predicate new_uses(Ident i, Object replacementO) {
  exists(Object o | uses(i, o) |
    replacementO = getReplacementField(o)
    or
    not exists(getReplacementField(o)) and replacementO = o
  )
}

query predicate new_variadic(Type t) {
  variadic(t) and
  not containsAliases(t)
}
