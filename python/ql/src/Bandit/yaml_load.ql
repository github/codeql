/**
 * @name Use of unsafe yaml load.
 * @description Use of unsafe yaml load. Allows instantiation of arbitrary objects. Consider yaml.safe_load().
 *          https://bandit.readthedocs.io/en/latest/plugins/b506_yaml_load.html
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision high
 * @id py/bandit/yaml-load
 */

import python

predicate isAttribute(Attribute a, string enumName, string attrName) {
  a.getObject().toString() = enumName
  and a.getName() = attrName
}

from Expr e
where isAttribute(e, "yaml", "load")
select e, " Use of unsafe yaml load. Allows instantiation of arbitrary objects. Consider yaml.safe_load()."