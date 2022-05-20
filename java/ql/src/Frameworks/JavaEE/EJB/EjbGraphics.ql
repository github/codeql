/**
 * @name EJB uses graphics
 * @description An EJB should not use AWT or other graphics functionality.
 *              Such operations are normally performed by an end-user interface
 *              that accesses a server but not by the server itself.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/graphics
 * @tags reliability
 *       external/cwe/cwe-575
 */

import java
import semmle.code.java.frameworks.javaee.ejb.EJB
import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions

/*
 * JSR 220: Enterprise JavaBeansTM,Version 3.0
 * EJB Core Contracts and Requirements
 * Section 21.1.2 Programming Restrictions
 *
 * - An enterprise bean must not use the AWT functionality to attempt to output information to a
 * display, or to input information from a keyboard.
 *
 * Most servers do not allow direct interaction between an application program and a keyboard/display
 * attached to the server system.
 */

from Callable origin, ForbiddenGraphicsCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not use AWT or other graphics functionality by $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
