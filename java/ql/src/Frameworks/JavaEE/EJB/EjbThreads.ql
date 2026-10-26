/**
 * @name EJB uses threads
 * @description An EJB should not attempt to manage threads,
 *              as it could interfere with the EJB container's operation.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/threads
 * @tags reliability
 *       external/cwe/cwe-383
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
 * - The enterprise bean must not attempt to manage threads. The enterprise bean must not attempt
 * to start, stop, suspend, or resume a thread, or to change a thread's priority or name. The enter-
 * prise bean must not attempt to manage thread groups.
 *
 * These functions are reserved for the EJB container. Allowing the enterprise bean to manage threads
 * would decrease the container's ability to properly manage the runtime environment.
 */

from Callable origin, ForbiddenThreadingCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not attempt to manage threads by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
