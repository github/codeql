/**
 * @name No virtual destructor
 * @description All base classes with a virtual function should define a virtual destructor. If an application attempts to delete a derived class object through a base class pointer, the result is undefined if the base class destructor is non-virtual.
 * @kind problem
 * @problem.severity warning
 * @id cpp/jsf/av-rule-78
 * @tags reliability
 *       readability
 *       language-features
 *       external/jsf
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
    not d.isVirtual() and
    not d.isDeleted() and
    not d.isCompilerGenerated()
  ) and
  exists(ClassDerivation d | d.getBaseClass() = c)
select c, "Base classes with a virtual function must define a virtual destructor."
