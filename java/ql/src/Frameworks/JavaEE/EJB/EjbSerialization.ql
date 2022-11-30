/**
 * @name EJB uses substitution in serialization
 * @description An EJB should not use the subclass or object substitution features of
 *              the Java serialization protocol, since their use could compromise security.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/substitution-in-serialization
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
 * - The enterprise bean must not attempt to use the subclass and object substitution features of the
 * Java Serialization Protocol.
 *
 * Allowing the enterprise bean to use these functions could compromise security.
 */

from Callable origin, ForbiddenSerializationCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not use a substitution feature of serialization by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName() + " $@"
