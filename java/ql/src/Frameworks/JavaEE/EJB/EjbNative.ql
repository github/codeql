/**
 * @name EJB uses native code
 * @description An EJB should not attempt to load or execute native code.
 *              Such use could compromise security and system stability.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.8
 * @precision low
 * @id java/ejb/native-code
 * @tags reliability
 *       external/cwe/cwe-573
 */

import java
import semmle.code.java.frameworks.javaee.ejb.EJB
import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions

/*
 * JSR 220: Enterprise JavaBeansTM,Version 3.0
 * EJB Core Contracts and Requirements
 * Section 21.1.2 Programming Restrictions
 *
 * - The enterprise bean must not attempt to load a native library.
 *
 * This function is reserved for the EJB container. Allowing the enterprise bean to load native code would
 * create a security hole.
 */

from Callable origin, ForbiddenNativeCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not use native code by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
