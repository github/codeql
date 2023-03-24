import python

/** Retained for backwards compatibility use ClassObject.isIterator() instead. */
deprecated predicate is_iterator(ClassObject c) { c.isIterator() }

/** Retained for backwards compatibility use ClassObject.isIterable() instead. */
deprecated predicate is_iterable(ClassObject c) { c.isIterable() }

/** Retained for backwards compatibility use ClassObject.isCollection() instead. */
deprecated predicate is_collection(ClassObject c) { c.isCollection() }

/** Retained for backwards compatibility use ClassObject.isMapping() instead. */
deprecated predicate is_mapping(ClassObject c) { c.isMapping() }

/** Retained for backwards compatibility use ClassObject.isSequence() instead. */
deprecated predicate is_sequence(ClassObject c) { c.isSequence() }

/** Retained for backwards compatibility use ClassObject.isContextManager() instead. */
deprecated predicate is_context_manager(ClassObject c) { c.isContextManager() }
