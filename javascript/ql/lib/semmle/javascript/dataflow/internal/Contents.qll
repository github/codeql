private import javascript
private import semmle.javascript.frameworks.data.internal.ApiGraphModels as ApiGraphModels
private import semmle.javascript.dataflow.internal.FlowSummaryPrivate as FlowSummaryPrivate
private import semmle.javascript.dataflow.internal.VariableOrThis
private import codeql.dataflow.internal.AccessPathSyntax as AccessPathSyntax

module Private {
  import Public

  /**
   * Gets the largest array index should be propagated precisely through flow summaries.
   *
   * Note that all known array indices have a corresponding singleton content, but some will
   * be collapsed in flow summaries that operate on array elements.
   */
  int getMaxPreciseArrayIndex() { result = 9 }

  /** Gets the largest array index should be propagated precisely through flow summaries. */
  int getAPreciseArrayIndex() { result = [0 .. getMaxPreciseArrayIndex()] }

  /**
   * Holds if a MaD access path token of form `name[arg]` exists.
   */
  predicate isAccessPathTokenPresent(string name, string arg) {
    arg = any(FlowSummaryPrivate::AccessPathToken tok).getAnArgument(name)
    or
    arg = any(ApiGraphModels::AccessPathToken tok).getAnArgument(name)
  }

  /**
   * Holds if values associated with `key` should be tracked as a individual contents of a `Map` object.
   */
  private predicate isKnownMapKey(string key) {
    exists(MethodCallExpr call |
      call.getMethodName() = "get" and
      call.getNumArgument() = 1 and
      call.getArgument(0).getStringValue() = key
    )
    or
    isAccessPathTokenPresent("MapValue", key)
  }

  /**
   * A known property name.
   */
  class PropertyName extends string {
    // Note: unlike the similarly-named class in StepSummary.qll, this class must not depend on DataFlow::Node
    PropertyName() {
      this = any(PropAccess access).getPropertyName()
      or
      this = any(Property p).getName()
      or
      this = any(PropertyPattern p).getName()
      or
      this = any(GlobalVariable v).getName()
      or
      this = getAPreciseArrayIndex().toString()
      or
      isAccessPathTokenPresent("Member", this)
    }

    /** Gets the array index corresponding to this property name. */
    pragma[nomagic]
    int asArrayIndex() { result = this.toInt() and result >= 0 and this = result.toString() }
  }

  cached
  newtype TContent =
    MkPropertyContent(PropertyName name) or
    MkArrayElementUnknown() or // note: array elements with known index are just properties
    MkMapKey() or
    MkMapValueWithUnknownKey() or
    MkMapValueWithKnownKey(string key) { isKnownMapKey(key) } or
    MkSetElement() or
    MkIteratorElement() or
    MkIteratorError() or
    MkPromiseValue() or
    MkPromiseError() or
    MkCapturedContent(LocalVariableOrThis v) { v.isCaptured() }

  cached
  newtype TContentSet =
    MkSingletonContent(Content content) or
    MkArrayElementKnown(int index) { index = any(PropertyName name).asArrayIndex() } or
    MkArrayElementLowerBound(int index) { index = [0 .. getMaxPreciseArrayIndex() + 1] } or
    MkMapValueKnown(string key) { isKnownMapKey(key) } or
    MkMapValueAll() or
    MkPromiseFilter() or
    MkIteratorFilter() or
    MkAnyProperty() or
    MkAnyCapturedContent() or
    // The following content sets are used exclusively as an intermediate value in flow summaries.
    // These are encoded as a ContentSummaryComponent, although the flow graphs we generate are different
    // than an ordinary content component. These special content sets should never appear in a step.
    MkAwaited() or
    MkAnyPropertyDeep() or
    MkArrayElementDeep() or
    MkOptionalStep(string name) { isAccessPathTokenPresent("OptionalStep", name) } or
    MkOptionalBarrier(string name) { isAccessPathTokenPresent("OptionalBarrier", name) }

  /**
   * Holds if `cs` is used to encode a special operation as a content component, but should not
   * be treated as an ordinary content component.
   */
  predicate isSpecialContentSet(ContentSet cs) {
    cs = MkAwaited() or
    cs = MkAnyPropertyDeep() or
    cs = MkArrayElementDeep() or
    cs instanceof MkOptionalStep or
    cs instanceof MkOptionalBarrier
  }
}

module Public {
  private import Private

  /**
   * A storage location on an object, such as a property name.
   */
  class Content extends TContent {
    /** Gets a string representation of this content. */
    cached
    string toString() {
      // Note that these strings are visible to the end-user, in the access path of a PathNode.
      result = this.asPropertyName()
      or
      this.isUnknownArrayElement() and
      result = "ArrayElement"
      or
      this = MkMapKey() and
      result = "MapKey"
      or
      this = MkMapValueWithUnknownKey() and
      result = "MapValue"
      or
      exists(string key |
        this = MkMapValueWithKnownKey(key) and
        result = "MapValue[" + key + "]"
      )
      or
      this = MkSetElement() and
      result = "SetElement"
      or
      this = MkIteratorElement() and
      result = "IteratorElement"
      or
      this = MkIteratorError() and
      result = "IteratorError"
      or
      this = MkPromiseValue() and
      result = "PromiseValue"
      or
      this = MkPromiseError() and
      result = "PromiseError"
      or
      result = this.asCapturedVariable().getName()
    }

    /** Gets the property name represented by this content, if any. */
    string asPropertyName() { this = MkPropertyContent(result) }

    /** Gets the array index represented by this content, if any. */
    pragma[nomagic]
    int asArrayIndex() { result = this.asPropertyName().(PropertyName).asArrayIndex() }

    /** Gets the captured variable represented by this content, if any. */
    LocalVariableOrThis asCapturedVariable() { this = MkCapturedContent(result) }

    /** Holds if this represents values stored at an unknown array index. */
    predicate isUnknownArrayElement() { this = MkArrayElementUnknown() }

    /** Holds if this represents values stored in a `Map` at an unknown key. */
    predicate isMapValueWithUnknownKey() { this = MkMapValueWithUnknownKey() }

    /** Holds if this represents values stored in a `Map` as the given string key. */
    predicate isMapValueWithKnownKey(string key) { this = MkMapValueWithKnownKey(key) }
  }

  /**
   * An entity that represents the set of `Content`s being accessed at a read or store operation.
   */
  class ContentSet extends TContentSet {
    /** Gets a content that may be stored into when storing into this set. */
    pragma[inline]
    Content getAStoreContent() {
      result = this.asSingleton()
      or
      // For array element access with known lower bound, just store into the unknown array element
      this = ContentSet::arrayElementLowerBound(_) and
      result.isUnknownArrayElement()
      or
      exists(int n |
        this = ContentSet::arrayElementKnown(n) and
        result.asArrayIndex() = n
      )
      or
      exists(string key |
        this = ContentSet::mapValueWithKnownKey(key) and
        result.isMapValueWithKnownKey(key)
      )
      or
      this = ContentSet::mapValueAll() and
      result.isMapValueWithUnknownKey()
    }

    /** Gets a content that may be read from when reading from this set. */
    pragma[nomagic]
    Content getAReadContent() {
      result = this.asSingleton()
      or
      this = ContentSet::promiseFilter() and
      (
        result = MkPromiseValue()
        or
        result = MkPromiseError()
      )
      or
      this = ContentSet::iteratorFilter() and
      (
        result = MkIteratorElement()
        or
        result = MkIteratorError()
      )
      or
      exists(int bound | this = ContentSet::arrayElementLowerBound(bound) |
        result.isUnknownArrayElement()
        or
        result.asArrayIndex() >= bound
      )
      or
      exists(int n | this = ContentSet::arrayElementKnown(n) |
        result.isUnknownArrayElement()
        or
        result.asArrayIndex() = n
      )
      or
      exists(string key | this = ContentSet::mapValueWithKnownKey(key) |
        result.isMapValueWithUnknownKey()
        or
        result.isMapValueWithKnownKey(key)
      )
      or
      this = ContentSet::mapValueAll() and
      (
        result.isMapValueWithUnknownKey()
        or
        result.isMapValueWithKnownKey(_)
      )
      or
      this = ContentSet::anyProperty() and
      (
        result instanceof MkPropertyContent
        or
        result instanceof MkArrayElementUnknown
      )
      or
      this = ContentSet::anyCapturedContent() and
      result instanceof Private::MkCapturedContent
    }

    /** Gets the singleton content to be accessed. */
    Content asSingleton() { this = MkSingletonContent(result) }

    /** Gets the property name to be accessed, provided that this is a singleton content set. */
    PropertyName asPropertyName() { result = this.asSingleton().asPropertyName() }

    /**
     * Gets a string representation of this content set.
     */
    string toString() {
      result = this.asSingleton().toString()
      or
      this = ContentSet::promiseFilter() and result = "PromiseFilter"
      or
      this = ContentSet::iteratorFilter() and result = "IteratorFilter"
      or
      exists(int bound |
        this = ContentSet::arrayElementLowerBound(bound) and
        result = "ArrayElement[" + bound + "..]"
      )
      or
      exists(int n | this = ContentSet::arrayElementKnown(n) and result = "ArrayElement[" + n + "]")
      or
      this = ContentSet::mapValueAll() and
      result = "MapValue"
      or
      this = ContentSet::anyProperty() and
      result = "AnyMember"
      or
      this = MkAwaited() and result = "Awaited (with coercion)"
      or
      this = MkAnyPropertyDeep() and result = "AnyMemberDeep"
      or
      this = MkArrayElementDeep() and result = "ArrayElementDeep"
      or
      this = MkAnyCapturedContent() and
      result = "AnyCapturedContent"
      or
      exists(string name |
        this = MkOptionalStep(name) and
        result = "OptionalStep[" + name + "]"
      )
      or
      exists(string name |
        this = MkOptionalBarrier(name) and
        result = "OptionalBarrier[" + name + "]"
      )
    }
  }

  /**
   * Companion module to the `ContentSet` class, providing access to various content sets.
   */
  module ContentSet {
    /**
     * A content set containing only the given content.
     */
    pragma[inline]
    ContentSet singleton(Content content) { result.asSingleton() = content }

    /**
     * A content set corresponding to the given property name.
     */
    pragma[inline]
    ContentSet property(PropertyName name) { result.asSingleton().asPropertyName() = name }

    /**
     * A content set that should only be used in `withContent` and `withoutContent` steps, which
     * matches the two promise-related contents, `Awaited[value]` and `Awaited[error]`.
     */
    ContentSet promiseFilter() { result = MkPromiseFilter() }

    /**
     * A content set that should only be used in `withContent` and `withoutContent` steps, which
     * matches the two iterator-related contents, `IteratorElement` and `IteratorError`.
     */
    ContentSet iteratorFilter() { result = MkIteratorFilter() }

    /**
     * A content set describing the result of a resolved promise.
     */
    ContentSet promiseValue() { result = singleton(MkPromiseValue()) }

    /**
     * A content set describing the error stored in a rejected promise.
     */
    ContentSet promiseError() { result = singleton(MkPromiseError()) }

    /**
     * A content set describing all array elements, regardless of their index in the array.
     */
    ContentSet arrayElement() { result = MkArrayElementLowerBound(0) }

    /**
     * A content set describing array elements at index `bound` or greater.
     *
     * For `bound=0` this gets the same content set as `ContentSet::arrayElement()`, that is,
     * the content set describing all array elements.
     *
     * For large values of `bound` this has no result - see `ContentSet::arrayElementLowerBoundFromInt`.
     */
    ContentSet arrayElementLowerBound(int bound) { result = MkArrayElementLowerBound(bound) }

    /**
     * A content set describing an access to array index `n`.
     *
     * This content set reads from element `n` and the unknown element, and stores to index `n`.
     *
     * For large values of `n` this has no result - see `ContentSet::arrayElementFromInt`.
     */
    ContentSet arrayElementKnown(int n) { result = MkArrayElementKnown(n) }

    /**
     * The singleton content set describing array elements stored at an unknown index.
     */
    ContentSet arrayElementUnknown() { result = singleton(MkArrayElementUnknown()) }

    /**
     * Gets a content set describing array elements at index `bound` or greater.
     *
     * If `bound` is too large, it is truncated to the greatest lower bound we can represent.
     */
    bindingset[bound]
    ContentSet arrayElementLowerBoundFromInt(int bound) {
      result = arrayElementLowerBound(bound.minimum(getMaxPreciseArrayIndex() + 1))
    }

    /**
     * Gets the content set describing an access to array index `n`.
     *
     * If `n` is too large, it is truncated to the greatest lower bound we can represent.
     */
    bindingset[n]
    ContentSet arrayElementFromInt(int n) {
      result = arrayElementKnown(n)
      or
      not exists(arrayElementKnown(n)) and
      result = arrayElementLowerBoundFromInt(n)
    }

    /** Gets the content set describing the keys of a `Map` object. */
    ContentSet mapKey() { result = singleton(MkMapKey()) }

    /** Gets the content set describing the values of a `Map` object stored with an unknown key. */
    ContentSet mapValueWithUnknownKey() { result = singleton(MkMapValueWithUnknownKey()) }

    /**
     * Gets the content set describing the value of a `Map` object stored with the given known `key`.
     *
     * This has no result if `key` is not one of the keys we track precisely. See also `mapValueFromKey`.
     */
    ContentSet mapValueWithKnownKeyStrict(string key) { result = MkMapValueKnown(key) }

    /**
     * Gets the content set describing an access to a map value with the given `key`.
     *
     * This content set also reads from a value stored with an unknown key. Use `mapValueWithKnownKeyStrict` to strictly
     * refer to known keys.
     *
     * This has no result if `key` is not one of the keys we track precisely. See also `mapValueFromKey`.
     */
    ContentSet mapValueWithKnownKey(string key) { result = singleton(MkMapValueWithKnownKey(key)) }

    /** Gets the content set describing all values in a map (with known or unknown key). */
    ContentSet mapValueAll() { result = MkMapValueAll() }

    /**
     * Gets the content set describing the value in a `Map` object stored at the given `key`.
     *
     * If `key` is not one of the keys we track precisely, this is mapped to the unknown key instead.
     */
    bindingset[key]
    ContentSet mapValueFromKey(string key) {
      result = mapValueWithKnownKey(key)
      or
      not exists(mapValueWithKnownKey(key)) and
      result = mapValueWithUnknownKey()
    }

    /** Gets the content set describing the elements of a `Set` object. */
    ContentSet setElement() { result = singleton(MkSetElement()) }

    /** Gets the content set describing the elements of an iterator object. */
    ContentSet iteratorElement() { result = singleton(MkIteratorElement()) }

    /** Gets the content set describing the exception to be thrown when attempting to iterate over the given value. */
    ContentSet iteratorError() { result = singleton(MkIteratorError()) }

    /**
     * Gets a content set that reads from all ordinary properties.
     *
     * This includes array elements, but not the contents of `Map`, `Set`, `Promise`, or iterator objects.
     *
     * This content set has no effect if used in a store step.
     */
    ContentSet anyProperty() { result = MkAnyProperty() }

    /**
     * Gets a content set corresponding to the pseudo-property `propertyName`.
     */
    pragma[nomagic]
    private ContentSet fromLegacyPseudoProperty(string propertyName) {
      propertyName = Promises::valueProp() and
      result = promiseValue()
      or
      propertyName = Promises::errorProp() and
      result = promiseError()
      or
      propertyName = DataFlow::PseudoProperties::arrayElement() and
      result = arrayElement()
      or
      propertyName = DataFlow::PseudoProperties::iteratorElement() and
      result = iteratorElement()
      or
      propertyName = DataFlow::PseudoProperties::setElement() and
      result = setElement()
      or
      propertyName = DataFlow::PseudoProperties::mapValueAll() and
      result = mapValueAll()
      or
      propertyName = DataFlow::PseudoProperties::mapValueUnknownKey() and
      result = mapValueWithUnknownKey()
      or
      exists(string key |
        propertyName = DataFlow::PseudoProperties::mapValueKey(key) and
        result = mapValueWithKnownKey(key)
      )
    }

    /**
     * Gets the content set corresponding to the given property name, where legacy pseudo-properties
     * are mapped to their corresponding content sets (which are no longer seen as property names).
     */
    bindingset[propertyName]
    ContentSet fromLegacyProperty(string propertyName) {
      result = fromLegacyPseudoProperty(propertyName)
      or
      not exists(fromLegacyPseudoProperty(propertyName)) and
      (
        // In case a map-value key was contributed via a SharedFlowStep, but we don't have a ContentSet for it,
        // convert it to the unknown key.
        if DataFlow::PseudoProperties::isMapValueKey(propertyName)
        then result = mapValueWithUnknownKey()
        else result = property(propertyName)
      )
    }

    /**
     * Gets a content set that reads from all captured variables stored on a function.
     */
    ContentSet anyCapturedContent() { result = Private::MkAnyCapturedContent() }
  }
}
