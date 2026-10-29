/**
 * @name EJB sets socket factory or URL stream handler factory
 * @description An EJB should not set the socket factory used by ServerSocket or Socket,
 *              or the stream handler factory used by URL. Such operations could
 *              compromise security or interfere with the EJB container's operation.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/socket-or-stream-handler-factory
 * @tags reliability
 *       external/cwe/cwe-577
 */

import java
import semmle.code.java.frameworks.javaee.ejb.EJB
import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions

/*
 * JSR 220: Enterprise JavaBeansTM,Version 3.0
 * EJB Core Contracts and Requirements
 * Section 21.1.2 Programming Restrictions
 *
 * - The enterprise bean must not attempt to set the socket factory used by ServerSocket, Socket, or
 * the stream handler factory used by URL.
 *
 * These networking functions are reserved for the EJB container. Allowing the enterprise bean to use
 * these functions could compromise security and decrease the container's ability to properly manage the
 * runtime environment.
 */

from Callable origin, ForbiddenSetFactoryCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not set a factory by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
