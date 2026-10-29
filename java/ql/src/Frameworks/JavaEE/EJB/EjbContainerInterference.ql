/**
 * @name EJB interferes with container operation
 * @description An EJB should not attempt to create a class loader,
 *              obtain the current class loader, set the context class loader,
 *              set a security manager, create a new security manager,
 *              stop the JVM, or change the input, output or error streams.
 *              Such operations could interfere with the EJB container's operation.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/container-interference
 * @tags reliability
 *       external/cwe/cwe-578
 *       external/cwe/cwe-382
 */

import java
import semmle.code.java.frameworks.javaee.ejb.EJB
import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions

/*
 * JSR 220: Enterprise JavaBeansTM,Version 3.0
 * EJB Core Contracts and Requirements
 * Section 21.1.2 Programming Restrictions
 *
 * - The enterprise bean must not attempt to create a class loader; obtain the current class loader;
 * set the context class loader; set security manager; create a new security manager; stop the
 * JVM; or change the input, output, and error streams.
 *
 * These functions are reserved for the EJB container. Allowing the enterprise bean to use these functions
 * could compromise security and decrease the container's ability to properly manage the runtime envi-
 * ronment.
 */

from Callable origin, ForbiddenContainerInterferenceCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not interfere with its container's operation by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
