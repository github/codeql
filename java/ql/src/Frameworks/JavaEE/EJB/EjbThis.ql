/**
 * @name EJB uses 'this' as argument or result
 * @description An EJB should not use 'this' as a method argument or result.
 *              Instead, it should use the result of SessionContext.getBusinessObject,
 *              SessionContext.getEJBObject, SessionContext.getEJBLocalObject,
 *              EntityContext.getEJBObject, or EntityContext.getEJBLocalObject.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/this
 * @tags portability
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
 * - The enterprise bean must not attempt to pass this as an argument or method result. The
 * enterprise bean must pass the result of SessionContext.getBusinessObject,
 * SessionContext.getEJBObject, SessionContext.getEJBLocalObject,
 * EntityContext.getEJBObject, or EntityContext.getEJBLocalObject instead.
 */

from Callable origin, ForbiddenThisCallable target, Call call, ThisAccess ta
where
  ejbCalls(origin, target, call) and
  ta = forbiddenThisUse(target)
select origin, "EJB should not use 'this' as a method argument or result $@.", ta, "here"
