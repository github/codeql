/**
 * @name Unhashable object hashed
 * @description Hashing an object which is not hashable will result in a TypeError at runtime.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/hash-unhashable-value
 */

import python

/* This assumes that any indexing operation where the value is not a sequence or numpy array involves hashing.
 * For sequences, the index must be an int, which are hashable, so we don't need to treat them specially.
 * For numpy arrays, the index may be a list, which are not hashable and needs to be treated specially.
 */
 
predicate numpy_array_type(ClassObject na) {
    exists(ModuleObject np | np.getName() = "numpy" or np.getName() = "numpy.core" |
        na.getAnImproperSuperType() = np.getAttribute("ndarray")
    )
}

predicate has_custom_getitem(ClassObject cls) {
    cls.lookupAttribute("__getitem__") instanceof PyFunctionObject
    or
    numpy_array_type(cls)
}

predicate explicitly_hashed(ControlFlowNode f) {
     exists(CallNode c, GlobalVariable hash | c.getArg(0) = f and c.getFunction().(NameNode).uses(hash) and hash.getId() = "hash")
}

predicate unhashable_subscript(ControlFlowNode f, ClassObject c, ControlFlowNode origin) {
    is_unhashable(f, c, origin) and
    exists(SubscriptNode sub | sub.getIndex() = f |
        exists(ClassObject custom_getitem |
            sub.getObject().refersTo(_, custom_getitem, _) and
            not has_custom_getitem(custom_getitem)
        )
    )
}

predicate is_unhashable(ControlFlowNode f, ClassObject cls, ControlFlowNode origin) {
    f.refersTo(_, cls, origin) and
    (not cls.hasAttribute("__hash__") and not cls.unknowableAttributes() and cls.isNewStyle()
     or
     cls.lookupAttribute("__hash__") = theNoneObject()
    )
}

from ControlFlowNode f, ClassObject c, ControlFlowNode origin
where 
explicitly_hashed(f) and is_unhashable(f, c, origin)
or
unhashable_subscript(f, c, origin)
select f.getNode(), "This $@ of $@ is unhashable.", origin, "instance", c, c.getQualifiedName()
