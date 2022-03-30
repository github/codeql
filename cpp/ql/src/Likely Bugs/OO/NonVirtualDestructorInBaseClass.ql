/**
 * @name Non-virtual destructor in base class
 * @description All base classes with a virtual function should define a virtual destructor. If an application attempts to delete a derived class object through a base class pointer, the result is undefined if the base class destructor is non-virtual.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/virtual-destructor
 * @tags reliability
 *       readability
 *       language-features
 */

import cpp

/*
 * Find classes with virtual functions that have a destructor that is not virtual and for which there exists a derived class
 * when calling the destructor of a derived class the destructor in the base class may not be called
 */

from Class c
where
  exists(VirtualFunction f | f.getDeclaringType() = c) and
  exists(Destructor d |
    d.getDeclaringType() = c and
    // Ignore non-public destructors, which prevent an object of the declaring class from being deleted
    // directly (except from within the class itself). This is a common pattern in real-world code.
    d.hasSpecifier("public") and
    not d.isVirtual() and
    not d.isDeleted() and
    not d.isCompilerGenerated()
  ) and
  exists(ClassDerivation d | d.getBaseClass() = c)
select c, "A base class with a virtual function should define a virtual destructor."
