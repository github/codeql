/**
 * @name EJB uses reflection
 * @description An EJB should not attempt to use the Reflection API,
 *              as this could compromise security.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.8
 * @precision low
 * @id java/ejb/reflection
 * @tags external/cwe/cwe-573
 */

import java
import semmle.code.java.frameworks.javaee.ejb.EJB
import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions

/*
 * JSR 220: Enterprise JavaBeansTM,Version 3.0
 * EJB Core Contracts and Requirements
 * Section 21.1.2 Programming Restrictions
 *
 * - The enterprise bean must not attempt to query a class to obtain information about the declared
 * members that are not otherwise accessible to the enterprise bean because of the security rules
 * of the Java language. The enterprise bean must not attempt to use the Reflection API to access
 * information that the security rules of the Java programming language make unavailable.
 *
 * Allowing the enterprise bean to access information about other classes and to access the classes in a
 * manner that is normally disallowed by the Java programming language could compromise security.
 */

from Callable origin, ForbiddenReflectionCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not use reflection by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
