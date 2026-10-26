/**
 * @name EJB uses server socket
 * @description An EJB should not attempt to listen to or accept connections on a socket,
 *              or use a socket for multicast. Functioning as a general network server
 *              would conflict with the EJB's purpose to serve EJB clients.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/server-socket
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
 * - An enterprise bean must not attempt to listen on a socket, accept connections on a socket, or
 * use a socket for multicast.
 *
 * The EJB architecture allows an enterprise bean instance to be a network socket client, but it does not
 * allow it to be a network server. Allowing the instance to become a network server would conflict with
 * the basic function of the enterprise bean -- to serve the EJB clients.
 */

from Callable origin, ForbiddenServerSocketCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not use a socket as a server by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
