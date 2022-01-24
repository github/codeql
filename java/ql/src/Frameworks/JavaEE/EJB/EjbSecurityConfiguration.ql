/**
 * @name EJB accesses security configuration
 * @description An EJB should not attempt to access or modify any Java security configuration,
 *              including the Policy, Security, Provider, Signer and Identity objects.
 *              This functionality is reserved for the EJB container for security reasons.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.8
 * @precision low
 * @id java/ejb/security-configuration-access
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
 * - The enterprise bean must not attempt to obtain the security policy information for a particular
 * code source.
 *
 * Allowing the enterprise bean to access the security policy information would create a security hole.
 *
 * - The enterprise bean must not attempt to access or modify the security configuration objects
 * (Policy, Security, Provider, Signer, and Identity).
 *
 * These functions are reserved for the EJB container. Allowing the enterprise bean to use these functions
 * could compromise security.
 */

from Callable origin, ForbiddenSecurityConfigurationCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not access a security configuration by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
