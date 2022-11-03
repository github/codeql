import python

/** Retained for backwards compatibility use ClassObject.isIterator() instead. */
predicate is_iterator(ClassObject c) { c.isIterator() }

/** Retained for backwards compatibility use ClassObject.isIterable() instead. */
predicate is_iterable(ClassObject c) { c.isIterable() }

/** Retained for backwards compatibility use ClassObject.isCollection() instead. */
predicate is_collection(ClassObject c) { c.isCollection() }

/** Retained for backwards compatibility use ClassObject.isMapping() instead. */
predicate is_mapping(ClassObject c) { c.isMapping() }

/** Retained for backwards compatibility use ClassObject.isSequence() instead. */
predicate is_sequence(ClassObject c) { c.isSequence() }

/** Retained for backwards compatibility use ClassObject.isContextManager() instead. */
predicate is_context_manager(ClassObject c) { c.isContextManager() }
