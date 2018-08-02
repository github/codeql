/**
 * @name Exposes internal representation
 * @description Finds code that may expose an object's internal representation by
 *              incorporating reference to mutable object.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/expose-implementation
 * @tags reliability
 *       external/cwe/cwe-485
 */
import csharp

/* This code stores a reference to an externally mutable object into the internal
   representation of the object.
   If instances are accessed by untrusted code, and unchecked changes to the mutable
   object would compromise security or other important properties,
   you will need to do something different. Storing a copy of the object is better
   approach in many situations.

   In this analysis an object is considered mutable if it is an array, a
   java.util.Hashtable, or a java.util.Date.
   The analysis detects stores to fields of these types where the value is given as a
   parameter. */

from Assignment a, Field f, VariableAccess va, RefType t
where a.getLValue() = va and
      va.getTarget() = f and
      f.getType().(RefType).getSourceDeclaration() = t and
      (   (va.(MemberAccess).hasQualifier() and
           va.(MemberAccess).getQualifier() instanceof ThisAccess)
       or not va.(MemberAccess).hasQualifier()) and
      a.getRValue().(VariableAccess).getTarget() instanceof Parameter and
      (   t instanceof ArrayType
      //Add mutable types here as necessary. Kept the java types as a reference
      /*or t.hasQualifiedName("java.util", "Hashtable")
       or t.hasQualifiedName("java.util", "Date")*/)
select a,
       "May expose internal representation by storing an externally mutable object in "
       + f.getName() + "."
