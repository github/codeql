/**
 * @name Raise exception of a class
 * @description Finds places where we raise AnException or one of its subclasses
 * @tags throw
 *       raise
 *       exception
 */
 
import python

from Raise raise, ClassObject ex
where
    ex.getName() = "AnException" and
    (
        raise.getException().refersTo(ex.getAnImproperSuperType())
        or
        raise.getException().refersTo(_, ex.getAnImproperSuperType(), _)
    )
select raise, "Don't raise instances of 'AnException'"
