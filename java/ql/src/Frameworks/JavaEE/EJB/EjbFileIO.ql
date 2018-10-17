/**
 * @name EJB uses file input/output
 * @description An EJB should not attempt to access files or directories in the file system.
 *              Such use could compromise security and is not a suitable data access method
 *              for enterprise components.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/ejb/file-io
 * @tags reliability
 *       external/cwe/cwe-576
 */

import java
import semmle.code.java.frameworks.javaee.ejb.EJB
import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions

/*
 * JSR 220: Enterprise JavaBeansTM,Version 3.0
 * EJB Core Contracts and Requirements
 * Section 21.1.2 Programming Restrictions
 *
 * - An enterprise bean must not use the java.io package to attempt to access files and directo-
 * ries in the file system.
 *
 * The file system APIs are not well-suited for business components to access data. Business components
 * should use a resource manager API, such as JDBC, to store data.
 *
 * - The enterprise bean must not attempt to directly read or write a file descriptor.
 *
 * Allowing the enterprise bean to read and write file descriptors directly could compromise security.
 */

from Callable origin, ForbiddenFileCallable target, Call call
where ejbCalls(origin, target, call)
select origin, "EJB should not access the file system by calling $@.", call,
  target.getDeclaringType().getName() + "." + target.getName()
