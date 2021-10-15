/**
 * @name EJB uses synchronization
 * @description An EJB should not use synchronization, since it will not work properly
 *              if an EJB is distributed across multiple JVMs.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/synchronization
 * @tags reliability
 *       external/cwe/cwe-574
 */

import java
import semmle.code.java.frameworks.javaee.ejb.EJB
import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions

/*
 * JSR 220: Enterprise JavaBeansTM,Version 3.0
 * EJB Core Contracts and Requirements
 * Section 21.1.2 Programming Restrictions
 *
 * - An enterprise bean must not use thread synchronization primitives to synchronize execution of
 * multiple instances.
 *
 * This is for the same reason as above. Synchronization would not work if the EJB container distributed
 * enterprise bean's instances across multiple JVMs.
 */

from Callable origin, ForbiddenSynchronizationCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not use synchronization by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
