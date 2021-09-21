/**
 * @name External Entity Expansion
 * @description
 * @kind problem
 * @id cpp/external-entity-expansion
 * @problem.severity warning
 * @tags security
 *       external/cwe/cwe-611
 */

import cpp

class XercesDOMParser extends Class {
  XercesDOMParser() { this.hasName("XercesDOMParser") }
}

class AbstractDOMParser extends Class {
    AbstractDOMParser() { this.hasName("AbstractDOMParser") }
}

/*
parser created
needs doSchema set?
needs validation set?
needs namespaces?
(
no security manager
OR
no 
 */