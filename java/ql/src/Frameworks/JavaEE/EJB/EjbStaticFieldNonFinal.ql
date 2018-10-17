/**
 * @name EJB uses non-final static field
 * @description An EJB should not make use of non-final static fields,
 *              since a consistent state of such fields is not guaranteed
 *              if an EJB instance is distributed across multiple JVMs.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/non-final-static-field
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
 * - An enterprise bean must not use read/write static fields. Using read-only static fields is
 * allowed. Therefore, it is recommended that all static fields in the enterprise bean class be
 * declared as final.
 *
 * This rule is required to ensure consistent runtime semantics because while some EJB containers may
 * use a single JVM to execute all enterprise bean's instances, others may distribute the instances across
 * multiple JVMs.
 */

from Callable origin, ForbiddenStaticFieldCallable target, Call call, FieldAccess fa, Field f
where
  ejbCalls(origin, target, call) and
  fa = forbiddenStaticFieldUse(target) and
  fa.getField() = f
select origin, "EJB should not access non-final static field $@ $@.", f,
  f.getDeclaringType().getName() + "." + f.getName(), fa, "here"
