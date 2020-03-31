/**
 * @name Inheritance hierarchy cannot be inferred for class
 * @description Inability to infer the inheritance hierarchy for a class will impair analysis.
 * @id py/failed-inheritance-inference
 * @kind problem
 * @problem.severity info
 * @tags debug
 */

import python

from Class cls, string reason
where exists(ClassObject c | c.getPyClass() = cls | c.failedInference(reason))
select cls, "Inference of class hierarchy failed for class '" + cls.getName() + "': " + reason + "."
